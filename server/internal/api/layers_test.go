package api

import (
	"bytes"
	"go/ast"
	"go/parser"
	"go/printer"
	"go/token"
	"os"
	"path/filepath"
	"runtime"
	"strings"
	"testing"
)

// The five layer rules of AGENTS.md section 3 are prose, and prose does not fail
// a build. The tests below turn the four of them that are mechanically decidable
// into assertions, so a later change that reaches across a layer boundary breaks
// CI instead of quietly eroding the architecture.
//
// The rules, verbatim:
//
//	1. api never touches store or the Mongo driver directly.
//	2. store returns models structs and typed errors only; no bson.M leaks out.
//	3. service never touches http/gin.
//	4. middleware is the only place that inspects the Authorization header.

// internalDir locates `server/internal` from this file's own position, so the
// audit does not depend on the process working directory.
func internalDir(t *testing.T) string {
	t.Helper()
	_, file, _, ok := runtime.Caller(0)
	if !ok {
		t.Fatal("runtime.Caller failed")
	}
	// .../server/internal/api/layers_test.go -> .../server/internal
	return filepath.Dir(filepath.Dir(file))
}

// packageImports maps every .go file under internal/<dir> to its import paths,
// keyed by the slash separated path relative to `server/internal`. Test files are
// included: they live in the same package and can break the same rule.
func packageImports(t *testing.T, dir string) map[string][]string {
	t.Helper()
	root := internalDir(t)
	base := filepath.Join(root, filepath.FromSlash(dir))
	out := map[string][]string{}
	err := filepath.WalkDir(base, func(path string, d os.DirEntry, err error) error {
		if err != nil || d.IsDir() || !strings.HasSuffix(path, ".go") {
			return err
		}
		fset := token.NewFileSet()
		file, parseErr := parser.ParseFile(fset, path, nil, parser.ImportsOnly)
		if parseErr != nil {
			return parseErr
		}
		paths := make([]string, 0, len(file.Imports))
		for _, spec := range file.Imports {
			paths = append(paths, strings.Trim(spec.Path.Value, `"`))
		}
		rel, relErr := filepath.Rel(root, path)
		if relErr != nil {
			return relErr
		}
		out[filepath.ToSlash(rel)] = paths
		return nil
	})
	if err != nil {
		t.Fatalf("scan internal/%s: %v", dir, err)
	}
	if len(out) == 0 {
		t.Fatalf("internal/%s contains no Go files; the audit would pass vacuously", dir)
	}
	return out
}

// TestLayerRule1APINeverTouchesStoreOrDriver pins rule 1. The handler layer
// addresses everything through `service`, and ids arrive typed via the
// `models.ObjectID` alias so the driver never has to be named here.
func TestLayerRule1APINeverTouchesStoreOrDriver(t *testing.T) {
	forbidden := []string{
		"github.com/minoic/peo/server/internal/store",
		"go.mongodb.org/mongo-driver",
	}
	for file, imports := range packageImports(t, "api") {
		for _, imp := range imports {
			for _, bad := range forbidden {
				if imp == bad || strings.HasPrefix(imp, bad+"/") {
					t.Errorf("internal/%s imports %q, but AGENTS.md section 3 rule 1 keeps the api layer off store and the Mongo driver",
						file, imp)
				}
			}
		}
	}
}

// TestLayerRule2StoreSurfaceHasNoBSONM pins rule 2. `bson.M` is the store
// package's own query vocabulary; the moment one appears in an exported
// signature, a caller outside the package is holding a raw driver filter.
func TestLayerRule2StoreSurfaceHasNoBSONM(t *testing.T) {
	root := internalDir(t)
	base := filepath.Join(root, "store")
	checked := 0
	err := filepath.WalkDir(base, func(path string, d os.DirEntry, err error) error {
		if err != nil || d.IsDir() || !strings.HasSuffix(path, ".go") {
			return err
		}
		fset := token.NewFileSet()
		file, parseErr := parser.ParseFile(fset, path, nil, 0)
		if parseErr != nil {
			return parseErr
		}
		rel, relErr := filepath.Rel(root, path)
		if relErr != nil {
			return relErr
		}
		rel = filepath.ToSlash(rel)

		report := func(kind, name string, node any) {
			checked++
			var buf bytes.Buffer
			if printErr := printer.Fprint(&buf, fset, node); printErr != nil {
				t.Errorf("print internal/%s: %v", rel, printErr)
				return
			}
			if strings.Contains(buf.String(), "bson.M") {
				t.Errorf("internal/%s: exported %s %s exposes bson.M, but AGENTS.md section 3 rule 2 keeps raw driver types inside store",
					rel, kind, name)
			}
		}

		for _, decl := range file.Decls {
			switch d := decl.(type) {
			case *ast.FuncDecl:
				if ast.IsExported(d.Name.Name) {
					report("func", d.Name.Name, d.Type)
				}
			case *ast.GenDecl:
				for _, spec := range d.Specs {
					if ts, ok := spec.(*ast.TypeSpec); ok && ast.IsExported(ts.Name.Name) {
						report("type", ts.Name.Name, ts.Type)
					}
				}
			}
		}
		return nil
	})
	if err != nil {
		t.Fatalf("scan internal/store: %v", err)
	}
	if checked == 0 {
		t.Fatal("internal/store exports nothing; the audit would pass vacuously")
	}
}

// TestLayerRule3ServiceNeverTouchesGin pins rule 3. `net/http` is deliberately
// allowed: the Pterodactyl client is an HTTP client, and the rule forbids the
// transport framework, not the standard library's client types.
func TestLayerRule3ServiceNeverTouchesGin(t *testing.T) {
	for file, imports := range packageImports(t, "service") {
		for _, imp := range imports {
			if imp == "github.com/gin-gonic/gin" || strings.HasPrefix(imp, "github.com/gin-gonic/gin/") {
				t.Errorf("internal/%s imports %q, but AGENTS.md section 3 rule 3 keeps gin out of the service layer",
					file, imp)
			}
		}
	}
}

// TestLayerRule4OnlyMiddlewareReadsAuthorization pins rule 4. Sending an
// Authorization header outward (to Pterodactyl) is not the same act as reading
// the caller's, so only the header-read call is matched.
func TestLayerRule4OnlyMiddlewareReadsAuthorization(t *testing.T) {
	root := internalDir(t)
	// Assembled at run time so that this file does not contain the very pattern
	// it searches for -- otherwise the audit would flag itself.
	needle := "GetHeader(" + `"` + "Authorization" + `"` + ")"
	scanned := 0
	err := filepath.WalkDir(root, func(path string, d os.DirEntry, err error) error {
		if err != nil || d.IsDir() || !strings.HasSuffix(path, ".go") {
			return err
		}
		rel, relErr := filepath.Rel(root, path)
		if relErr != nil {
			return relErr
		}
		rel = filepath.ToSlash(rel)
		if strings.HasPrefix(rel, "middleware/") {
			return nil
		}
		src, readErr := os.ReadFile(path)
		if readErr != nil {
			return readErr
		}
		scanned++
		if strings.Contains(string(src), needle) {
			t.Errorf("internal/%s reads the Authorization header, but AGENTS.md section 3 rule 4 makes middleware the only place that may",
				rel)
		}
		return nil
	})
	if err != nil {
		t.Fatalf("scan internal: %v", err)
	}
	if scanned == 0 {
		t.Fatal("internal contains no Go files; the audit would pass vacuously")
	}
}
