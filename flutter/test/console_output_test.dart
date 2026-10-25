import 'package:flutter_test/flutter_test.dart';
import 'package:peo_web/widgets/console_output.dart';

void main() {
  test('preserves Wings line and control-character boundaries', () {
    const ansi = '\u001b[32mready\u001b[0m';
    expect(
      consoleOutputText({
        'event': 'console output',
        'args': [ansi, 'already ended\n', 'progress\r'],
      }),
      '$ansi\nalready ended\nprogress\n',
    );
    expect(
      consoleOutputText({
        'event': 'console output',
        'args': ['help', 'version'],
      }),
      'help\nversion\n',
    );
    expect(
      consoleOutputText({
        'event': 'console output',
        'args': [
          'first\r',
          'second\r',
          'third\n',
          'fourth\r\n',
          'fifth\n\u001b[0m',
          'sixth\r\n\u001b[0m',
        ],
      }),
      'first\nsecond\nthird\nfourth\nfifth\u001b[0m\nsixth\u001b[0m\n',
    );
    expect(
      consoleOutputText({
        'event': 'console output',
        'args': ['\u001b[32mprogress\r\u001b[0m'],
      }),
      '\u001b[32mprogress\u001b[0m\n',
    );
    expect(
      consoleOutputText({
        'event': 'console output',
        'args': ['updating 10%\r', 'updating 20%\rfinished'],
      }),
      'updating 10%\nupdating 20%\rfinished\n',
    );
    expect(
      consoleOutputText({
        'event': 'status',
        'args': ['running'],
      }),
      isEmpty,
    );
  });
}
