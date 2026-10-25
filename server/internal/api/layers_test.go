package api

import (
	"go/ast"
	"go/parser"
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

		report := func(kind, name string, node ast.Node) {
			checked++
			if exportedTypeHasBSONM(node, file) {
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

func exportedTypeHasBSONM(node ast.Node, file *ast.File) bool {
	aliases := map[string]bool{}
	for _, imp := range file.Imports {
		path := strings.Trim(imp.Path.Value, `"`)
		if path != "go.mongodb.org/mongo-driver/bson" && path != "go.mongodb.org/mongo-driver/v2/bson" {
			continue
		}
		name := "bson"
		if imp.Name != nil {
			name = imp.Name.Name
		}
		if name != "_" && name != "." {
			aliases[name] = true
		}
	}
	found := false
	ast.Inspect(node, func(n ast.Node) bool {
		sel, ok := n.(*ast.SelectorExpr)
		if !ok || sel.Sel.Name != "M" {
			return true
		}
		id, ok := sel.X.(*ast.Ident)
		if ok && aliases[id.Name] {
			found = true
		}
		return true
	})
	return found
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
		// Tests may read outgoing HTTP headers to assert that clients send the
		// caller's token upstream; this rule applies to production request paths.
		if strings.HasPrefix(rel, "middleware/") || strings.HasSuffix(rel, "_test.go") {
			return nil
		}
		fset := token.NewFileSet()
		file, readErr := parser.ParseFile(fset, path, nil, 0)
		if readErr != nil {
			return readErr
		}
		scanned++
		if readsAuthorization(file) {
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

func readsAuthorization(file *ast.File) bool {
	reads := false
	headerAliases := map[string]bool{}
	ast.Inspect(file, func(node ast.Node) bool {
		switch stmt := node.(type) {
		case *ast.AssignStmt:
			for i, rhs := range stmt.Rhs {
				selector, ok := rhs.(*ast.SelectorExpr)
				if !ok || selector.Sel.Name != "Header" || i >= len(stmt.Lhs) {
					continue
				}
				if alias, ok := stmt.Lhs[i].(*ast.Ident); ok {
					headerAliases[alias.Name] = true
				}
			}
		case *ast.ValueSpec:
			for i, value := range stmt.Values {
				selector, ok := value.(*ast.SelectorExpr)
				if !ok || selector.Sel.Name != "Header" || i >= len(stmt.Names) {
					continue
				}
				headerAliases[stmt.Names[i].Name] = true
			}
		}
		return true
	})
	isAuthorization := func(expr ast.Expr) bool {
		lit, ok := expr.(*ast.BasicLit)
		return ok && lit.Kind == token.STRING && strings.EqualFold(strings.Trim(lit.Value, `"`), "Authorization")
	}
	ast.Inspect(file, func(node ast.Node) bool {
		switch expr := node.(type) {
		case *ast.CallExpr:
			selector, ok := expr.Fun.(*ast.SelectorExpr)
			if !ok || len(expr.Args) == 0 || !isAuthorization(expr.Args[0]) {
				return true
			}
			if selector.Sel.Name == "GetHeader" {
				reads = true
				return true
			}
			if selector.Sel.Name == "Get" {
				if header, ok := selector.X.(*ast.SelectorExpr); ok && header.Sel.Name == "Header" {
					reads = true
				}
				if header, ok := selector.X.(*ast.Ident); ok && headerAliases[header.Name] {
					reads = true
				}
			}
		case *ast.IndexExpr:
			if isAuthorization(expr.Index) {
				if header, ok := expr.X.(*ast.SelectorExpr); ok && header.Sel.Name == "Header" {
					reads = true
				}
				if header, ok := expr.X.(*ast.Ident); ok && headerAliases[header.Name] {
					reads = true
				}
			}
		}
		return true
	})
	return reads
}

func TestLayerRule4AuthorizationASTFixtures(t *testing.T) {
	for _, source := range []string{
		`package p; func f(c *Context) { c.GetHeader("authorization") }`,
		`package p; func f(r *http.Request) { r.Header.Get("Authorization") }`,
		`package p; func f(r *http.Request) { _ = r.Header["Authorization"] }`,
		`package p; func f(r *http.Request) { h := r.Header; _ = h.Get("Authorization") }`,
	} {
		file, err := parser.ParseFile(token.NewFileSet(), "fixture.go", source, 0)
		if err != nil {
			t.Fatal(err)
		}
		if !readsAuthorization(file) {
			t.Fatalf("did not detect Authorization read in %s", source)
		}
	}
	file, err := parser.ParseFile(token.NewFileSet(), "outbound.go", `package p; func f(r *http.Request) { r.Header.Set("Authorization", "token") }`, 0)
	if err != nil {
		t.Fatal(err)
	}
	if readsAuthorization(file) {
		t.Fatal("outbound Authorization header write was treated as a read")
	}
}

func TestLayerRule2BSONAliasFixture(t *testing.T) {
	file, err := parser.ParseFile(token.NewFileSet(), "fixture.go", `package store; import driver "go.mongodb.org/mongo-driver/v2/bson"; type Public struct { Filter driver.M }`, 0)
	if err != nil {
		t.Fatal(err)
	}
	typeDecl := file.Decls[1].(*ast.GenDecl).Specs[0].(*ast.TypeSpec)
	if !exportedTypeHasBSONM(typeDecl.Type, file) {
		t.Fatal("aliased bson.M in exported field was not detected")
	}
	file, err = parser.ParseFile(token.NewFileSet(), "control.go", `package store; type Public struct { Filter map[string]any }`, 0)
	if err != nil {
		t.Fatal(err)
	}
	typeDecl = file.Decls[0].(*ast.GenDecl).Specs[0].(*ast.TypeSpec)
	if exportedTypeHasBSONM(typeDecl.Type, file) {
		t.Fatal("ordinary map was treated as bson.M")
	}
}
