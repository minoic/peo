/// Small display helpers shared by the pages.
///
/// The server deliberately sends data rather than markup: prices are integers,
/// durations are nanosecond counts and dates arrive in one of four documented
/// string forms. Everything that turns those into something a human reads lives
/// here, so the four time formats in `docs/API.md` are handled in one place.
library;

/// Renders an amount the way every legacy template did: the fullwidth yen sign
/// followed by the integer, with no separators or decimals.
String money(int amount) => '\uFFE5$amount';

/// Renders a capacity sent in megabytes using the most readable unit.
String resourceSize(int megabytes) {
  if (megabytes < 1024) return '$megabytes MB';

  final gigabytes = (megabytes / 1024)
      .toStringAsFixed(2)
      .replaceFirst(RegExp(r'\.?0+$'), '');
  return '$gigabytes GB';
}

/// Applies the percentage discount used by storefront product cards.
int discountedAmount(int amount, int discountPercent) {
  if (discountPercent <= 0) return amount;
  if (discountPercent >= 100) return 0;
  return amount * (100 - discountPercent) ~/ 100;
}

/// Renders a nanosecond count as a compact human duration.
///
/// Server side clocks count server uptime, so the useful scale is days and
/// hours; anything under a minute reads as `0m` rather than a stream of
/// near-zero units.
String uptime(int nanoseconds) {
  final total = Duration(microseconds: nanoseconds ~/ 1000);
  final days = total.inDays;
  final hours = total.inHours % 24;
  final minutes = total.inMinutes % 60;
  if (days > 0) return '${days}d ${hours}h';
  if (hours > 0) return '${hours}h ${minutes}m';
  return '${minutes}m';
}

/// Renders a validity window, which the API sends as nanoseconds.
String validityDays(int nanoseconds) {
  final value = Duration(microseconds: nanoseconds ~/ 1000);
  return '${value.inDays}d';
}

/// Parses a date string into a friendly local form.
///
/// The API uses four shapes: RFC 3339 for documents, `yyyy-MM-dd HH:mm` for the
/// joined rows and `yyyy-MM-dd HH:mm:ss` for recharge history. [DateTime.parse]
/// accepts all but the space-separated forms' missing timezone, so the value is
/// normalised to a `T` separator first.
String readableDate(String raw) {
  if (raw.isEmpty) return '';
  final normalised = raw.contains(' ') ? raw.replaceFirst(' ', 'T') : raw;
  final parsed = DateTime.tryParse(normalised);
  if (parsed == null) return raw;
  final local = parsed.toLocal();
  return '${local.year.toString().padLeft(4, '0')}-'
      '${local.month.toString().padLeft(2, '0')}-'
      '${local.day.toString().padLeft(2, '0')} '
      '${local.hour.toString().padLeft(2, '0')}:'
      '${local.minute.toString().padLeft(2, '0')}';
}

/// Renders one of the product card's intro bullets.
///
/// The server sends either a translatable [key] (with the value to append) or a
/// free-form [label], so the wording stays on the client the way it did when the
/// templates owned it. A missing key falls back to the label.
String introText(String key, String value, String label) {
  final name = introLabels[key] ?? label;
  var displayValue = value;
  if (key == 'memory' || key == 'disk') {
    final megabytes = int.tryParse(value);
    if (megabytes != null) displayValue = resourceSize(megabytes);
  }
  if (name.isEmpty) return displayValue;
  if (displayValue.isEmpty) return name;
  return '$name $displayValue';
}

/// The English wording of every product card bullet.
const Map<String, String> introLabels = <String, String>{
  'cpu': 'CPU cores',
  'memory': 'Memory',
  'disk': 'Disk',
  'backups': 'Server backups',
  'virtualEnv': 'Virtualization isolation',
  'retention': 'Keep server after expiration for',
};
