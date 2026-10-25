// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recharge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RechargeByKeyRequest {

 String get key;
/// Create a copy of RechargeByKeyRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RechargeByKeyRequestCopyWith<RechargeByKeyRequest> get copyWith => _$RechargeByKeyRequestCopyWithImpl<RechargeByKeyRequest>(this as RechargeByKeyRequest, _$identity);

  /// Serializes this RechargeByKeyRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RechargeByKeyRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RechargeByKeyRequest&&(identical(other.key, _this.key) || other.key == _this.key));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RechargeByKeyRequest;
  return Object.hash(runtimeType,_this.key);
}

@override
String toString() {
  final _this = this as RechargeByKeyRequest;
  return 'RechargeByKeyRequest(key: ${_this.key})';
}


}

/// @nodoc
abstract mixin class $RechargeByKeyRequestCopyWith<$Res>  {
  factory $RechargeByKeyRequestCopyWith(RechargeByKeyRequest value, $Res Function(RechargeByKeyRequest) _then) = _$RechargeByKeyRequestCopyWithImpl;
@useResult
$Res call({
 String key
});




}
/// @nodoc
class _$RechargeByKeyRequestCopyWithImpl<$Res>
    implements $RechargeByKeyRequestCopyWith<$Res> {
  _$RechargeByKeyRequestCopyWithImpl(this._self, this._then);

  final RechargeByKeyRequest _self;
  final $Res Function(RechargeByKeyRequest) _then;

/// Create a copy of RechargeByKeyRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,}) {
  return _then(RechargeByKeyRequest(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RechargeByKeyRequest].
extension RechargeByKeyRequestPatterns on RechargeByKeyRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RechargeByKeyRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RechargeByKeyRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RechargeByKeyRequest value)  $default,){
final _that = this;
switch (_that) {
case _RechargeByKeyRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RechargeByKeyRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RechargeByKeyRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RechargeByKeyRequest() when $default != null:
return $default(_that.key);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key)  $default,) {final _that = this;
switch (_that) {
case _RechargeByKeyRequest():
return $default(_that.key);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key)?  $default,) {final _that = this;
switch (_that) {
case _RechargeByKeyRequest() when $default != null:
return $default(_that.key);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RechargeByKeyRequest implements RechargeByKeyRequest {
  const _RechargeByKeyRequest({required this.key});
  factory _RechargeByKeyRequest.fromJson(Map<String, dynamic> json) => _$RechargeByKeyRequestFromJson(json);

@override final  String key;

/// Create a copy of RechargeByKeyRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RechargeByKeyRequestCopyWith<_RechargeByKeyRequest> get copyWith => __$RechargeByKeyRequestCopyWithImpl<_RechargeByKeyRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RechargeByKeyRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RechargeByKeyRequest&&(identical(other.key, key) || other.key == key));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key);
}

@override
String toString() {
    return 'RechargeByKeyRequest(key: $key)';
}


}

/// @nodoc
abstract mixin class _$RechargeByKeyRequestCopyWith<$Res> implements $RechargeByKeyRequestCopyWith<$Res> {
  factory _$RechargeByKeyRequestCopyWith(_RechargeByKeyRequest value, $Res Function(_RechargeByKeyRequest) _then) = __$RechargeByKeyRequestCopyWithImpl;
@override @useResult
$Res call({
 String key
});




}
/// @nodoc
class __$RechargeByKeyRequestCopyWithImpl<$Res>
    implements _$RechargeByKeyRequestCopyWith<$Res> {
  __$RechargeByKeyRequestCopyWithImpl(this._self, this._then);

  final _RechargeByKeyRequest _self;
  final $Res Function(_RechargeByKeyRequest) _then;

/// Create a copy of RechargeByKeyRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,}) {
  return _then(_RechargeByKeyRequest(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PreCreateRequest {

 int get amount;
/// Create a copy of PreCreateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreCreateRequestCopyWith<PreCreateRequest> get copyWith => _$PreCreateRequestCopyWithImpl<PreCreateRequest>(this as PreCreateRequest, _$identity);

  /// Serializes this PreCreateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PreCreateRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreCreateRequest&&(identical(other.amount, _this.amount) || other.amount == _this.amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PreCreateRequest;
  return Object.hash(runtimeType,_this.amount);
}

@override
String toString() {
  final _this = this as PreCreateRequest;
  return 'PreCreateRequest(amount: ${_this.amount})';
}


}

/// @nodoc
abstract mixin class $PreCreateRequestCopyWith<$Res>  {
  factory $PreCreateRequestCopyWith(PreCreateRequest value, $Res Function(PreCreateRequest) _then) = _$PreCreateRequestCopyWithImpl;
@useResult
$Res call({
 int amount
});




}
/// @nodoc
class _$PreCreateRequestCopyWithImpl<$Res>
    implements $PreCreateRequestCopyWith<$Res> {
  _$PreCreateRequestCopyWithImpl(this._self, this._then);

  final PreCreateRequest _self;
  final $Res Function(PreCreateRequest) _then;

/// Create a copy of PreCreateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amount = null,}) {
  return _then(PreCreateRequest(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PreCreateRequest].
extension PreCreateRequestPatterns on PreCreateRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PreCreateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PreCreateRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PreCreateRequest value)  $default,){
final _that = this;
switch (_that) {
case _PreCreateRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PreCreateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _PreCreateRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PreCreateRequest() when $default != null:
return $default(_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int amount)  $default,) {final _that = this;
switch (_that) {
case _PreCreateRequest():
return $default(_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int amount)?  $default,) {final _that = this;
switch (_that) {
case _PreCreateRequest() when $default != null:
return $default(_that.amount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PreCreateRequest implements PreCreateRequest {
  const _PreCreateRequest({required this.amount});
  factory _PreCreateRequest.fromJson(Map<String, dynamic> json) => _$PreCreateRequestFromJson(json);

@override final  int amount;

/// Create a copy of PreCreateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreCreateRequestCopyWith<_PreCreateRequest> get copyWith => __$PreCreateRequestCopyWithImpl<_PreCreateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PreCreateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreCreateRequest&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,amount);
}

@override
String toString() {
    return 'PreCreateRequest(amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$PreCreateRequestCopyWith<$Res> implements $PreCreateRequestCopyWith<$Res> {
  factory _$PreCreateRequestCopyWith(_PreCreateRequest value, $Res Function(_PreCreateRequest) _then) = __$PreCreateRequestCopyWithImpl;
@override @useResult
$Res call({
 int amount
});




}
/// @nodoc
class __$PreCreateRequestCopyWithImpl<$Res>
    implements _$PreCreateRequestCopyWith<$Res> {
  __$PreCreateRequestCopyWithImpl(this._self, this._then);

  final _PreCreateRequest _self;
  final $Res Function(_PreCreateRequest) _then;

/// Create a copy of PreCreateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? amount = null,}) {
  return _then(_PreCreateRequest(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PreCreateResponse {

 String get qrCodeBase64; String get outTradeNo;
/// Create a copy of PreCreateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreCreateResponseCopyWith<PreCreateResponse> get copyWith => _$PreCreateResponseCopyWithImpl<PreCreateResponse>(this as PreCreateResponse, _$identity);

  /// Serializes this PreCreateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PreCreateResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreCreateResponse&&(identical(other.qrCodeBase64, _this.qrCodeBase64) || other.qrCodeBase64 == _this.qrCodeBase64)&&(identical(other.outTradeNo, _this.outTradeNo) || other.outTradeNo == _this.outTradeNo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PreCreateResponse;
  return Object.hash(runtimeType,_this.qrCodeBase64,_this.outTradeNo);
}

@override
String toString() {
  final _this = this as PreCreateResponse;
  return 'PreCreateResponse(qrCodeBase64: ${_this.qrCodeBase64}, outTradeNo: ${_this.outTradeNo})';
}


}

/// @nodoc
abstract mixin class $PreCreateResponseCopyWith<$Res>  {
  factory $PreCreateResponseCopyWith(PreCreateResponse value, $Res Function(PreCreateResponse) _then) = _$PreCreateResponseCopyWithImpl;
@useResult
$Res call({
 String qrCodeBase64, String outTradeNo
});




}
/// @nodoc
class _$PreCreateResponseCopyWithImpl<$Res>
    implements $PreCreateResponseCopyWith<$Res> {
  _$PreCreateResponseCopyWithImpl(this._self, this._then);

  final PreCreateResponse _self;
  final $Res Function(PreCreateResponse) _then;

/// Create a copy of PreCreateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? qrCodeBase64 = null,Object? outTradeNo = null,}) {
  return _then(PreCreateResponse(
qrCodeBase64: null == qrCodeBase64 ? _self.qrCodeBase64 : qrCodeBase64 // ignore: cast_nullable_to_non_nullable
as String,outTradeNo: null == outTradeNo ? _self.outTradeNo : outTradeNo // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PreCreateResponse].
extension PreCreateResponsePatterns on PreCreateResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PreCreateResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PreCreateResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PreCreateResponse value)  $default,){
final _that = this;
switch (_that) {
case _PreCreateResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PreCreateResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PreCreateResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String qrCodeBase64,  String outTradeNo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PreCreateResponse() when $default != null:
return $default(_that.qrCodeBase64,_that.outTradeNo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String qrCodeBase64,  String outTradeNo)  $default,) {final _that = this;
switch (_that) {
case _PreCreateResponse():
return $default(_that.qrCodeBase64,_that.outTradeNo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String qrCodeBase64,  String outTradeNo)?  $default,) {final _that = this;
switch (_that) {
case _PreCreateResponse() when $default != null:
return $default(_that.qrCodeBase64,_that.outTradeNo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PreCreateResponse implements PreCreateResponse {
  const _PreCreateResponse({this.qrCodeBase64 = '', this.outTradeNo = ''});
  factory _PreCreateResponse.fromJson(Map<String, dynamic> json) => _$PreCreateResponseFromJson(json);

@override@JsonKey() final  String qrCodeBase64;
@override@JsonKey() final  String outTradeNo;

/// Create a copy of PreCreateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreCreateResponseCopyWith<_PreCreateResponse> get copyWith => __$PreCreateResponseCopyWithImpl<_PreCreateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PreCreateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreCreateResponse&&(identical(other.qrCodeBase64, qrCodeBase64) || other.qrCodeBase64 == qrCodeBase64)&&(identical(other.outTradeNo, outTradeNo) || other.outTradeNo == outTradeNo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,qrCodeBase64,outTradeNo);
}

@override
String toString() {
    return 'PreCreateResponse(qrCodeBase64: $qrCodeBase64, outTradeNo: $outTradeNo)';
}


}

/// @nodoc
abstract mixin class _$PreCreateResponseCopyWith<$Res> implements $PreCreateResponseCopyWith<$Res> {
  factory _$PreCreateResponseCopyWith(_PreCreateResponse value, $Res Function(_PreCreateResponse) _then) = __$PreCreateResponseCopyWithImpl;
@override @useResult
$Res call({
 String qrCodeBase64, String outTradeNo
});




}
/// @nodoc
class __$PreCreateResponseCopyWithImpl<$Res>
    implements _$PreCreateResponseCopyWith<$Res> {
  __$PreCreateResponseCopyWithImpl(this._self, this._then);

  final _PreCreateResponse _self;
  final $Res Function(_PreCreateResponse) _then;

/// Create a copy of PreCreateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? qrCodeBase64 = null,Object? outTradeNo = null,}) {
  return _then(_PreCreateResponse(
qrCodeBase64: null == qrCodeBase64 ? _self.qrCodeBase64 : qrCodeBase64 // ignore: cast_nullable_to_non_nullable
as String,outTradeNo: null == outTradeNo ? _self.outTradeNo : outTradeNo // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RechargeStatusResponse {

 String get status;
/// Create a copy of RechargeStatusResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RechargeStatusResponseCopyWith<RechargeStatusResponse> get copyWith => _$RechargeStatusResponseCopyWithImpl<RechargeStatusResponse>(this as RechargeStatusResponse, _$identity);

  /// Serializes this RechargeStatusResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RechargeStatusResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RechargeStatusResponse&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RechargeStatusResponse;
  return Object.hash(runtimeType,_this.status);
}

@override
String toString() {
  final _this = this as RechargeStatusResponse;
  return 'RechargeStatusResponse(status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $RechargeStatusResponseCopyWith<$Res>  {
  factory $RechargeStatusResponseCopyWith(RechargeStatusResponse value, $Res Function(RechargeStatusResponse) _then) = _$RechargeStatusResponseCopyWithImpl;
@useResult
$Res call({
 String status
});




}
/// @nodoc
class _$RechargeStatusResponseCopyWithImpl<$Res>
    implements $RechargeStatusResponseCopyWith<$Res> {
  _$RechargeStatusResponseCopyWithImpl(this._self, this._then);

  final RechargeStatusResponse _self;
  final $Res Function(RechargeStatusResponse) _then;

/// Create a copy of RechargeStatusResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,}) {
  return _then(RechargeStatusResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RechargeStatusResponse].
extension RechargeStatusResponsePatterns on RechargeStatusResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RechargeStatusResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RechargeStatusResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RechargeStatusResponse value)  $default,){
final _that = this;
switch (_that) {
case _RechargeStatusResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RechargeStatusResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RechargeStatusResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RechargeStatusResponse() when $default != null:
return $default(_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status)  $default,) {final _that = this;
switch (_that) {
case _RechargeStatusResponse():
return $default(_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status)?  $default,) {final _that = this;
switch (_that) {
case _RechargeStatusResponse() when $default != null:
return $default(_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RechargeStatusResponse implements RechargeStatusResponse {
  const _RechargeStatusResponse({this.status = ''});
  factory _RechargeStatusResponse.fromJson(Map<String, dynamic> json) => _$RechargeStatusResponseFromJson(json);

@override@JsonKey() final  String status;

/// Create a copy of RechargeStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RechargeStatusResponseCopyWith<_RechargeStatusResponse> get copyWith => __$RechargeStatusResponseCopyWithImpl<_RechargeStatusResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RechargeStatusResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RechargeStatusResponse&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,status);
}

@override
String toString() {
    return 'RechargeStatusResponse(status: $status)';
}


}

/// @nodoc
abstract mixin class _$RechargeStatusResponseCopyWith<$Res> implements $RechargeStatusResponseCopyWith<$Res> {
  factory _$RechargeStatusResponseCopyWith(_RechargeStatusResponse value, $Res Function(_RechargeStatusResponse) _then) = __$RechargeStatusResponseCopyWithImpl;
@override @useResult
$Res call({
 String status
});




}
/// @nodoc
class __$RechargeStatusResponseCopyWithImpl<$Res>
    implements _$RechargeStatusResponseCopyWith<$Res> {
  __$RechargeStatusResponseCopyWithImpl(this._self, this._then);

  final _RechargeStatusResponse _self;
  final $Res Function(_RechargeStatusResponse) _then;

/// Create a copy of RechargeStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,}) {
  return _then(_RechargeStatusResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RechargeLogResponse {

 List<RechargeLog> get logs;
/// Create a copy of RechargeLogResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RechargeLogResponseCopyWith<RechargeLogResponse> get copyWith => _$RechargeLogResponseCopyWithImpl<RechargeLogResponse>(this as RechargeLogResponse, _$identity);

  /// Serializes this RechargeLogResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RechargeLogResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RechargeLogResponse&&const DeepCollectionEquality().equals(other.logs, _this.logs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RechargeLogResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.logs));
}

@override
String toString() {
  final _this = this as RechargeLogResponse;
  return 'RechargeLogResponse(logs: ${_this.logs})';
}


}

/// @nodoc
abstract mixin class $RechargeLogResponseCopyWith<$Res>  {
  factory $RechargeLogResponseCopyWith(RechargeLogResponse value, $Res Function(RechargeLogResponse) _then) = _$RechargeLogResponseCopyWithImpl;
@useResult
$Res call({
 List<RechargeLog> logs
});




}
/// @nodoc
class _$RechargeLogResponseCopyWithImpl<$Res>
    implements $RechargeLogResponseCopyWith<$Res> {
  _$RechargeLogResponseCopyWithImpl(this._self, this._then);

  final RechargeLogResponse _self;
  final $Res Function(RechargeLogResponse) _then;

/// Create a copy of RechargeLogResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? logs = null,}) {
  return _then(RechargeLogResponse(
logs: null == logs ? _self.logs : logs // ignore: cast_nullable_to_non_nullable
as List<RechargeLog>,
  ));
}

}


/// Adds pattern-matching-related methods to [RechargeLogResponse].
extension RechargeLogResponsePatterns on RechargeLogResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RechargeLogResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RechargeLogResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RechargeLogResponse value)  $default,){
final _that = this;
switch (_that) {
case _RechargeLogResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RechargeLogResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RechargeLogResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RechargeLog> logs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RechargeLogResponse() when $default != null:
return $default(_that.logs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RechargeLog> logs)  $default,) {final _that = this;
switch (_that) {
case _RechargeLogResponse():
return $default(_that.logs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RechargeLog> logs)?  $default,) {final _that = this;
switch (_that) {
case _RechargeLogResponse() when $default != null:
return $default(_that.logs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RechargeLogResponse implements RechargeLogResponse {
  const _RechargeLogResponse({ List<RechargeLog> logs = const <RechargeLog>[]}): _logs = logs;
  factory _RechargeLogResponse.fromJson(Map<String, dynamic> json) => _$RechargeLogResponseFromJson(json);

 final  List<RechargeLog> _logs;
@override@JsonKey() List<RechargeLog> get logs {
  if (_logs is EqualUnmodifiableListView) return _logs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_logs);
}


/// Create a copy of RechargeLogResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RechargeLogResponseCopyWith<_RechargeLogResponse> get copyWith => __$RechargeLogResponseCopyWithImpl<_RechargeLogResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RechargeLogResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RechargeLogResponse&&const DeepCollectionEquality().equals(other.logs, _logs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_logs));
}

@override
String toString() {
    return 'RechargeLogResponse(logs: $logs)';
}


}

/// @nodoc
abstract mixin class _$RechargeLogResponseCopyWith<$Res> implements $RechargeLogResponseCopyWith<$Res> {
  factory _$RechargeLogResponseCopyWith(_RechargeLogResponse value, $Res Function(_RechargeLogResponse) _then) = __$RechargeLogResponseCopyWithImpl;
@override @useResult
$Res call({
 List<RechargeLog> logs
});




}
/// @nodoc
class __$RechargeLogResponseCopyWithImpl<$Res>
    implements _$RechargeLogResponseCopyWith<$Res> {
  __$RechargeLogResponseCopyWithImpl(this._self, this._then);

  final _RechargeLogResponse _self;
  final $Res Function(_RechargeLogResponse) _then;

/// Create a copy of RechargeLogResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? logs = null,}) {
  return _then(_RechargeLogResponse(
logs: null == logs ? _self._logs : logs // ignore: cast_nullable_to_non_nullable
as List<RechargeLog>,
  ));
}


}

// dart format on
