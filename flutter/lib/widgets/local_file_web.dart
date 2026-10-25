import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

Future<(String, Uint8List)?> pickLocalFile() async {
  final completer = Completer<(String, Uint8List)?>();
  final input = web.HTMLInputElement()
    ..type = 'file'
    ..style.display = 'none';
  input.onchange = ((web.Event _) {
    if (completer.isCompleted) return;
    final files = input.files;
    if (files == null || files.length == 0) {
      completer.complete(null);
    } else {
      final file = files.item(0)!;
      final reader = web.FileReader();
      reader.onload = ((web.ProgressEvent _) {
        final result = reader.result;
        if (result == null) {
          completer.completeError(
            StateError('Could not read the selected file.'),
          );
          return;
        }
        final buffer = result as JSArrayBuffer;
        completer.complete((file.name, Uint8List.view(buffer.toDart)));
      }).toJS;
      reader.onerror = ((web.ProgressEvent _) => completer.completeError(
        StateError('Could not read the selected file.'),
      )).toJS;
      reader.readAsArrayBuffer(file);
    }
    input.remove();
  }).toJS;
  input.oncancel = ((web.Event _) {
    if (!completer.isCompleted) completer.complete(null);
    input.remove();
  }).toJS;
  web.document.body?.appendChild(input);
  input.click();
  return completer.future;
}
