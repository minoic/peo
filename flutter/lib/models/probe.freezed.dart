// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'probe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Probe {

 String get id; String? get note;
/// Create a copy of Probe
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProbeCopyWith<Probe> get copyWith => _$ProbeCopyWithImpl<Probe>(this as Probe, _$identity);

  /// Serializes this Probe to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Probe;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Probe&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.note, _this.note) || other.note == _this.note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Probe;
  return Object.hash(runtimeType,_this.id,_this.note);
}

@override
String toString() {
  final _this = this as Probe;
  return 'Probe(id: ${_this.id}, note: ${_this.note})';
}


}

/// @nodoc
abstract mixin class $ProbeCopyWith<$Res>  {
  factory $ProbeCopyWith(Probe value, $Res Function(Probe) _then) = _$ProbeCopyWithImpl;
@useResult
$Res call({
 String id, String? note
});




}
/// @nodoc
class _$ProbeCopyWithImpl<$Res>
    implements $ProbeCopyWith<$Res> {
  _$ProbeCopyWithImpl(this._self, this._then);

  final Probe _self;
  final $Res Function(Probe) _then;

/// Create a copy of Probe
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? note = freezed,}) {
  return _then(Probe(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Probe].
extension ProbePatterns on Probe {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Probe value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Probe() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Probe value)  $default,){
final _that = this;
switch (_that) {
case _Probe():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Probe value)?  $default,){
final _that = this;
switch (_that) {
case _Probe() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Probe() when $default != null:
return $default(_that.id,_that.note);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? note)  $default,) {final _that = this;
switch (_that) {
case _Probe():
return $default(_that.id,_that.note);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _Probe() when $default != null:
return $default(_that.id,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Probe implements Probe {
  const _Probe({required this.id, this.note});
  factory _Probe.fromJson(Map<String, dynamic> json) => _$ProbeFromJson(json);

@override final  String id;
@override final  String? note;

/// Create a copy of Probe
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProbeCopyWith<_Probe> get copyWith => __$ProbeCopyWithImpl<_Probe>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProbeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Probe&&(identical(other.id, id) || other.id == id)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,note);
}

@override
String toString() {
    return 'Probe(id: $id, note: $note)';
}


}

/// @nodoc
abstract mixin class _$ProbeCopyWith<$Res> implements $ProbeCopyWith<$Res> {
  factory _$ProbeCopyWith(_Probe value, $Res Function(_Probe) _then) = __$ProbeCopyWithImpl;
@override @useResult
$Res call({
 String id, String? note
});




}
/// @nodoc
class __$ProbeCopyWithImpl<$Res>
    implements _$ProbeCopyWith<$Res> {
  __$ProbeCopyWithImpl(this._self, this._then);

  final _Probe _self;
  final $Res Function(_Probe) _then;

/// Create a copy of Probe
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? note = freezed,}) {
  return _then(_Probe(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
