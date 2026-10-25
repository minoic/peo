/// The two places the SPA has to step outside the Flutter canvas.
///
/// Both are web-only by nature: handing a file to the browser's own download
/// manager, and opening a second top-level tab for the Pterodactyl panel.
library;

import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Hands [bytes] to the browser as a download named [filename].
void saveBytes(
  List<int> bytes,
  String filename, {
  String mimeType = 'application/zip',
}) {
  final data = Uint8List.fromList(bytes);
  final parts = <JSAny>[data.toJS];
  final blob = web.Blob(parts.toJS, web.BlobPropertyBag(type: mimeType));
  final url = web.URL.createObjectURL(blob);
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = filename
    ..target = '_self';
  anchor.style.display = 'none';
  web.document.body?.appendChild(anchor);
  anchor.click();
  anchor.remove();
  web.URL.revokeObjectURL(url);
}

/// Opens [url] in a new top-level tab for links and panel session hand-off.
void openExternal(String url) {
  if (url.isEmpty) return;
  web.window.open(url, '_blank');
}
