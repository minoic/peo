# Flutter visual system

Peo's Flutter Web UI uses a light Material 3 content theme with dark Vultr-blue
navigation, defined in `flutter/lib/theme/peo_theme.dart` and attached by
`PeoApp`. Keep page styling in theme values and shared widgets so public, user,
and admin screens stay consistent.

## Tokens

- Brand reference: [Vultr Brand Assets](https://www.vultr.com/company/brand-assets/).
  The page provides official marks and artwork but does not publish a UI color
  specification; this application uses the blue identity visible in the marks.
- Main content and cards are white with pale blue-gray surfaces and dark navy
  text. `#142149` is reserved for the top bar, mobile drawer, and user sidebar.
- Main accent: `#007BFC`; secondary blue: `#51B9FF`; pale highlight: `#C9F4FF`.
  Use the dark `onAccent` token for legible text on the main accent.
- The storefront hero keeps its deep-blue gradient and curved lower edge.
  Keep its copy and decoration local to the hero instead of changing global
  content surfaces.
- Semantic success, warning, and error colors are tuned for light surfaces and
  remain independent from the brand palette.
- Text hierarchy, muted text, borders, semantic success/warning/error colors,
  spacing, radii, focus width, shadows, and motion durations are in `PeoTokens`.
- Keep the existing Flutter font setup. Use semantic `ColorScheme` roles for
  standard controls and `PeoTokens` for success and warning states.

## Shared building blocks

- `AppShell` owns responsive site navigation, the page width, page entrance,
  and the desktop user sidebar.
- `PageHeader`, `ResponsivePage`, `SectionCard`, `StatusBadge`, and `HoverCard`
  provide page headings, constrained content, grouped sections, statuses, and
  interactive card feedback.
- `AsyncView`, `ErrorPanel`, and `EmptyPanel` render loading, failure, and empty
  states in one style. `AdaptiveGrid` sizes cards from available width.
- Use the Material buttons, fields, menus, tabs, dialogs, and list tiles with
  the application theme. Keep explicit colors for meaningful status only.

## Responsive layout

- Below `640px`, use the app drawer and single-column page content.
- From `640px` through `1023px`, use compact icon navigation and fluid grids.
- At `1024px` and above, show full navigation and the user sidebar on user
  routes.
- Keep the shared site content width at or below `1600px` across public, user,
  admin, and server workspace routes. Use `ResponsivePage` for centered
  page content and `AdaptiveGrid` for repeatable card collections. Use `Wrap`
  for admin actions and form controls that need to flow onto another line.

### Server workspace

- `/servers/:id/:tab` uses the shared site header and server picker in the
  desktop sidebar or mobile drawer. The `Server List` entry opens `/console`;
  the selected server name appears in a row with a dropdown button on its
  right. Choosing another owned server keeps the current workspace tab.
  Console, Files, Backups, Startup, and Manage appear as indented entries below
  the selected server row.
- The workspace content uses the shared `1600px` width. It shows a `Server List`
  breadcrumb, the server name and status, then the selected workspace view.
  Switching tabs for the same server keeps its Cubit and mounted tab state.
- Keep terminal output in a dark, selectable region with explicit follow and
  reconnect states. Resource polling failures retain the latest successful
  sample. Do not add panel credentials or authentication bypasses for previews.

## Motion and accessibility

`PageEntrance`, route content, `AsyncView`, and `HoverCard` use short
transitions. Route transitions keep the shared shell and sidebar mounted and
use a near-opaque fade with a small vertical movement so navigation remains
visible while content changes. They read the system reduced-motion setting and
remove visible motion when it is enabled. Preserve visible keyboard focus,
descriptive tooltips for icon-only tablet navigation, and sufficiently large
Material control targets.

For a new page, keep API and state work in the existing Cubit/API layers, use
`PageHeader` and shared state components, and verify the layout at roughly
`390px`, `768px`, and `1280px` widths.

## Console acceptance (2026-10)

- `dart analyze lib test` passed. Six Chrome/WASM test suites passed 32 tests;
  `app_test.dart` passed 13/13. Mock-browser checks passed 12/12 flows and
  4/4 operations, including file save/reopen/API readback, startup variable
  saves, backup creation and restore confirmation, and the standalone message
  dialog.
- Browser checks used mock API responses and data. This run did not exercise a
  real Panel/Wings backend, real file upload, or destructive management actions.
