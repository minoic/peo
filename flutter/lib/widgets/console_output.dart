String consoleOutputText(Object? value) {
  if (value is! Map ||
      value['event'] != 'console output' ||
      value['args'] is! List) {
    return '';
  }

  return (value['args'] as List).map((argument) {
    final line = argument.toString();
    if (line.isEmpty) {
      return line;
    }

    // Wings may end a complete console record with CR, LF, or CRLF. Keep CR
    // characters inside a record for progress updates, and keep trailing SGR
    // resets attached to the record they style.
    final trailingNewline = RegExp(r'(\r\n|\r|\n)((?:\x1B\[[0-9;]*m)*)$')
        .firstMatch(line);
    if (trailingNewline != null) {
      return '${line.substring(0, trailingNewline.start)}'
          '${trailingNewline.group(2)}\n';
    }

    return '$line\n';
  }).join();
}
