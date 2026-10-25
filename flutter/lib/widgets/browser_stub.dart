/// Browser-only operations have no implementation on native Dart platforms.
void saveBytes(
  List<int> bytes,
  String filename, {
  String mimeType = 'application/zip',
}) {
  throw UnsupportedError('Downloading files is only supported on the web.');
}

void openExternal(String url) {
  throw UnsupportedError('Opening external URLs is only supported on the web.');
}
