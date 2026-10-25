import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peo_web/widgets/server_text_editor.dart';

void main() {
  test('language inference prefers filename and falls back to MIME type', () {
    expect(serverFileLanguage('/server/config.yml', 'text/plain'), 'yaml');
    expect(serverFileLanguage('/server/unknown', 'application/json'), 'json');
    expect(serverFileLanguage('/server/binary.dat', ''), 'plain');
  });

  testWidgets('syntax spans preserve every original character', (tester) async {
    late ServerEditorController controller;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            const samples = {
              'yaml': 'server:\n  online-mode: true\n',
              'json': '{"online": true, "port": 25565}',
              'properties': 'online-mode=true\n',
              'toml': '[server]\nonline = true\n',
              'xml': '<server online="true" />',
              'shell': 'export PORT=25565 # server',
            };
            for (final entry in samples.entries) {
              controller = ServerEditorController(
                text: entry.value,
                language: entry.key,
              );
              final spans = controller.buildTextSpan(
                context: context,
                withComposing: false,
              );
              expect(spans.toPlainText(), controller.text);
              expect(
                spans.children!.whereType<TextSpan>().any(
                  (span) => span.style?.color != null,
                ),
                isTrue,
              );
              controller.dispose();
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  });

  test('Enter inherits indentation and indents YAML mappings', () {
    const formatter = ServerIndentFormatter('  ', language: 'yaml');
    const oldValue = TextEditingValue(
      text: '  server:',
      selection: TextSelection.collapsed(offset: 9),
    );
    const entered = TextEditingValue(
      text: '  server:\n',
      selection: TextSelection.collapsed(offset: 10),
    );
    final result = formatter.formatEditUpdate(oldValue, entered);
    expect(result.text, '  server:\n    ');
    expect(result.selection.baseOffset, result.text.length);
  });

  test('paste containing newlines is left unchanged by auto indentation', () {
    const formatter = ServerIndentFormatter('  ', language: 'yaml');
    const oldValue = TextEditingValue(
      text: 'key:',
      selection: TextSelection.collapsed(offset: 4),
    );
    const pasted = TextEditingValue(
      text: 'key:\n  value: yes',
      selection: TextSelection.collapsed(offset: 17),
    );
    expect(formatter.formatEditUpdate(oldValue, pasted), pasted);
  });

  test('Tab and Shift+Tab preserve forward and reverse selections', () {
    final controller = TextEditingController.fromValue(
      const TextEditingValue(
        text: 'a\nb',
        selection: TextSelection(baseOffset: 0, extentOffset: 3),
      ),
    );
    indentEditorSelection(controller, '  ');
    expect(controller.text, '  a\n  b');
    expect(
      controller.selection,
      const TextSelection(baseOffset: 0, extentOffset: 7),
    );
    indentEditorSelection(controller, '  ', outdent: true);
    expect(controller.text, 'a\nb');
    expect(
      controller.selection,
      const TextSelection(baseOffset: 0, extentOffset: 3),
    );

    controller.value = const TextEditingValue(
      text: 'a\nb',
      selection: TextSelection(baseOffset: 3, extentOffset: 0),
    );
    indentEditorSelection(controller, '  ');
    expect(
      controller.selection,
      const TextSelection(baseOffset: 7, extentOffset: 0),
    );
    indentEditorSelection(controller, '  ', outdent: true);
    expect(
      controller.selection,
      const TextSelection(baseOffset: 3, extentOffset: 0),
    );
    controller.dispose();
  });

  test('Shift+Tab at a line start outdents the current line', () {
    final controller = TextEditingController.fromValue(
      const TextEditingValue(
        text: '  first\n  second',
        selection: TextSelection.collapsed(offset: 0),
      ),
    );
    indentEditorSelection(controller, '  ', outdent: true);
    expect(controller.text, 'first\n  second');
    expect(controller.selection, const TextSelection.collapsed(offset: 0));

    controller.value = const TextEditingValue(
      text: 'first\n  second',
      selection: TextSelection.collapsed(offset: 6),
    );
    indentEditorSelection(controller, '  ', outdent: true);
    expect(controller.text, 'first\nsecond');
    expect(controller.selection, const TextSelection.collapsed(offset: 6));
    controller.dispose();
  });
}
