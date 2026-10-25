import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String serverFileLanguage(String path, String mimeType) {
  final name = path.split('/').last.toLowerCase();
  final extension = name.contains('.') ? name.split('.').last : '';
  final byExtension = switch (extension) {
    'yml' || 'yaml' => 'yaml',
    'json' || 'mcmeta' => 'json',
    'properties' || 'conf' || 'ini' => 'properties',
    'toml' => 'toml',
    'xml' || 'svg' => 'xml',
    'sh' || 'bash' => 'shell',
    _ => '',
  };
  if (byExtension.isNotEmpty) return byExtension;
  final mime = mimeType.toLowerCase();
  if (mime.contains('yaml')) return 'yaml';
  if (mime.contains('json')) return 'json';
  if (mime.contains('toml')) return 'toml';
  if (mime.contains('xml')) return 'xml';
  if (mime.contains('shell') || mime.contains('x-sh')) return 'shell';
  if (mime.contains('properties') || mime.contains('ini')) return 'properties';
  return 'plain';
}

class ServerEditorController extends TextEditingController {
  ServerEditorController({super.text, required this.language});

  String language;
  String? _cachedText;
  String? _cachedLanguage;
  ColorScheme? _cachedColors;
  TextStyle? _cachedStyle;
  List<TextSpan>? _cachedSpans;

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final source = text;
    if (language == 'plain' || source.length > 256 * 1024) {
      return super.buildTextSpan(
        context: context,
        style: style,
        withComposing: withComposing,
      );
    }
    final colors = Theme.of(context).colorScheme;
    if (_cachedText != source ||
        _cachedLanguage != language ||
        _cachedColors != colors ||
        _cachedStyle != style) {
      _cachedText = source;
      _cachedLanguage = language;
      _cachedColors = colors;
      _cachedStyle = style;
      _cachedSpans = _highlight(source, language, context, style);
    }
    final composing = withComposing && value.composing.isValid
        ? value.composing
        : TextRange.empty;
    final spans = _cachedSpans ?? [TextSpan(text: source, style: style)];
    if (!composing.isValid || composing.isCollapsed) {
      return TextSpan(style: style, children: spans);
    }
    return TextSpan(style: style, children: _withComposing(spans, composing));
  }

  List<TextSpan> _highlight(
    String source,
    String language,
    BuildContext context,
    TextStyle? baseStyle,
  ) {
    final colors = Theme.of(context).colorScheme;
    final pattern = switch (language) {
      'yaml' => RegExp(
        r"""(?<comment>^\s*#.*$)|(?<key>^\s*[^#\s][^:\r\n]*)(?=\s*:)|(?<string>"(?:\\.|[^"\\])*"|'(?:''|[^'])*')|(?<literal>\b(?:true|false|null|yes|no|on|off)\b)|(?<number>\b-?\d+(?:\.\d+)?\b)|(?<punct>[:{}\[\],])""",
        multiLine: true,
        caseSensitive: false,
      ),
      'json' => RegExp(
        r"""(?<key>"(?:\\.|[^"\\])*"(?=\s*:))|(?<string>"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*')|(?<literal>\b(?:true|false|null)\b)|(?<number>-?\b\d+(?:\.\d+)?(?:[eE][+-]?\d+)?\b)|(?<punct>[{}\[\],:])""",
        caseSensitive: false,
      ),
      'properties' || 'toml' => RegExp(
        r"""(?<comment>^\s*[#!].*$)|(?<section>^\s*\[[^\]\r\n]+\])|(?<key>^\s*[^=:\r\n]+)(?=\s*[=:])|(?<string>"(?:\\.|[^"\\])*"|'(?:''|[^'])*')|(?<literal>\b(?:true|false)\b)|(?<number>\b-?\d+(?:\.\d+)?\b)|(?<punct>[=:,{}\[\]])""",
        multiLine: true,
        caseSensitive: false,
      ),
      'xml' => RegExp(
        r"""(?<comment><!--[\s\S]*?-->)|(?<tag><\/?[A-Za-z_:][\w:.-]*)|(?<punct>\/?>)|(?<key>\b[A-Za-z_:][\w:.-]*(?=\s*=))|(?<string>"[^"]*"|'[^']*')""",
      ),
      'shell' => RegExp(
        r"""(?<comment>^\s*#.*$)|(?<string>"(?:\\.|[^"\\])*"|'[^']*')|(?<variable>\$\{?[A-Za-z_][\w]*\}?)|(?<literal>\b(?:if|then|else|fi|for|in|do|done|case|esac|function|export|local|return)\b)|(?<number>\b\d+\b)""",
        multiLine: true,
      ),
      _ => null,
    };
    if (pattern == null) return [TextSpan(text: source, style: baseStyle)];
    final spans = <TextSpan>[];
    var cursor = 0;
    for (final match in pattern.allMatches(source)) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: source.substring(cursor, match.start)));
      }
      final group = match.groupNames.firstWhere(
        (name) => match.namedGroup(name) != null,
        orElse: () => '',
      );
      final color = switch (group) {
        'comment' => colors.outline,
        'key' || 'tag' || 'section' => colors.primary,
        'string' => const Color(0xff357a38),
        'literal' => const Color(0xff9c3f8f),
        'number' => const Color(0xffb05a16),
        'variable' => const Color(0xff167c80),
        'punct' => colors.onSurfaceVariant,
        _ => colors.onSurface,
      };
      spans.add(
        TextSpan(
          text: source.substring(match.start, match.end),
          style: (baseStyle ?? const TextStyle()).copyWith(color: color),
        ),
      );
      cursor = match.end;
    }
    if (cursor < source.length) {
      spans.add(TextSpan(text: source.substring(cursor)));
    }
    return spans;
  }

  List<TextSpan> _withComposing(List<TextSpan> spans, TextRange range) {
    final result = <TextSpan>[];
    var offset = 0;
    for (final span in spans) {
      final text = span.text ?? '';
      final start = offset;
      final end = start + text.length;
      final overlapStart = range.start.clamp(start, end).toInt();
      final overlapEnd = range.end.clamp(start, end).toInt();
      if (overlapStart > start) {
        result.add(
          TextSpan(
            text: text.substring(0, overlapStart - start),
            style: span.style,
          ),
        );
      }
      if (overlapEnd > overlapStart) {
        result.add(
          TextSpan(
            text: text.substring(overlapStart - start, overlapEnd - start),
            style: (span.style ?? const TextStyle()).copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        );
      }
      if (end > overlapEnd) {
        result.add(
          TextSpan(text: text.substring(overlapEnd - start), style: span.style),
        );
      }
      offset = end;
    }
    return result;
  }
}

class ServerIndentFormatter extends TextInputFormatter {
  const ServerIndentFormatter(this.indent, {this.language = 'plain'});
  final String indent;
  final String language;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (indent.isEmpty ||
        newValue.composing.isValid && !newValue.composing.isCollapsed ||
        !oldValue.selection.isCollapsed ||
        newValue.text.length != oldValue.text.length + 1 ||
        oldValue.selection.baseOffset < 0) {
      return newValue;
    }
    final oldCaret = oldValue.selection.baseOffset;
    if (oldCaret < 0 || oldCaret > oldValue.text.length) return newValue;
    if (!newValue.text.startsWith(oldValue.text.substring(0, oldCaret)) ||
        !newValue.text.endsWith(oldValue.text.substring(oldCaret)) ||
        newValue.text.substring(oldCaret, oldCaret + 1) != '\n') {
      return newValue;
    }
    final lineStart = oldCaret == 0
        ? 0
        : oldValue.text.lastIndexOf('\n', oldCaret - 1) + 1;
    final previousLine = oldValue.text.substring(lineStart, oldCaret);
    final trimmedLine = previousLine.trimRight();
    final leading = RegExp(r'^[\t ]*').firstMatch(previousLine)!.group(0)!;
    final structuralIndent =
        language == 'yaml' && trimmedLine.endsWith(':') ||
        language == 'json' &&
            (trimmedLine.endsWith('{') || trimmedLine.endsWith('['));
    if (leading.isEmpty && !structuralIndent) return newValue;
    final nextIndent = '$leading${structuralIndent ? indent : ''}';
    final caret = oldCaret + 1;
    final text = newValue.text.replaceRange(caret, caret, nextIndent);
    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: caret + nextIndent.length),
    );
  }
}

void indentEditorSelection(
  TextEditingController controller,
  String indent, {
  bool outdent = false,
}) {
  final value = controller.value;
  final text = value.text;
  final selection = value.selection;
  if (!selection.isValid || indent.isEmpty && !outdent) return;
  final start = selection.start == 0
      ? 0
      : text.lastIndexOf('\n', selection.start - 1) + 1;
  final endLine = selection.isCollapsed
      ? text.indexOf('\n', selection.end)
      : text.indexOf('\n', selection.end - 1);
  final end = endLine < 0 ? text.length : endLine;
  final selected = text.substring(start, end);
  final lines = selected.split('\n');
  final changed = lines
      .map((line) {
        if (!outdent) return '$indent$line';
        if (line.startsWith(indent)) return line.substring(indent.length);
        if (line.startsWith('\t')) return line.substring(1);
        final spaces = RegExp(r'^ {1,4}').firstMatch(line)?.group(0);
        return spaces == null ? line : line.substring(spaces.length);
      })
      .join('\n');
  final updated = text.replaceRange(start, end, changed);
  int mappedOffset(int original) {
    final local = (original - start).clamp(0, selected.length).toInt();
    var adjustment = 0;
    var lineStart = 0;
    for (final line in lines) {
      final removed = line.startsWith(indent)
          ? indent.length
          : line.startsWith('\t')
          ? 1
          : RegExp(r'^ {1,4}').firstMatch(line)?.group(0)?.length ?? 0;
      final lineEnd = lineStart + line.length;
      if (local <= lineEnd) {
        final withinLine = local - lineStart;
        final withinAdjustment = outdent
            ? withinLine - withinLine.clamp(0, removed).toInt()
            : withinLine == 0
            ? 0
            : withinLine + indent.length;
        return start + lineStart + adjustment + withinAdjustment;
      }
      adjustment += outdent ? -removed : indent.length;
      lineStart = lineEnd + 1;
    }
    return start + adjustment + local;
  }

  controller.value = value.copyWith(
    text: updated,
    selection: TextSelection(
      baseOffset: mappedOffset(selection.baseOffset)
          .clamp(0, updated.length)
          .toInt(),
      extentOffset: mappedOffset(selection.extentOffset)
          .clamp(0, updated.length)
          .toInt(),
    ),
  );
}
