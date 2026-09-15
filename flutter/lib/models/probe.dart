import 'package:freezed_annotation/freezed_annotation.dart';

part 'probe.freezed.dart';
part 'probe.g.dart';

@freezed
abstract class Probe with _$Probe {
  const factory Probe({required String id, String? note}) = _Probe;
  factory Probe.fromJson(Map<String, dynamic> json) => _$ProbeFromJson(json);
}
