// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateOrderRequest {

 String get specId;
/// Create a copy of CreateOrderRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateOrderRequestCopyWith<CreateOrderRequest> get copyWith => _$CreateOrderRequestCopyWithImpl<CreateOrderRequest>(this as CreateOrderRequest, _$identity);

  /// Serializes this CreateOrderRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateOrderRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateOrderRequest&&(identical(other.specId, _this.specId) || other.specId == _this.specId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateOrderRequest;
  return Object.hash(runtimeType,_this.specId);
}

@override
String toString() {
  final _this = this as CreateOrderRequest;
  return 'CreateOrderRequest(specId: ${_this.specId})';
}


}

/// @nodoc
abstract mixin class $CreateOrderRequestCopyWith<$Res>  {
  factory $CreateOrderRequestCopyWith(CreateOrderRequest value, $Res Function(CreateOrderRequest) _then) = _$CreateOrderRequestCopyWithImpl;
@useResult
$Res call({
 String specId
});




}
/// @nodoc
class _$CreateOrderRequestCopyWithImpl<$Res>
    implements $CreateOrderRequestCopyWith<$Res> {
  _$CreateOrderRequestCopyWithImpl(this._self, this._then);

  final CreateOrderRequest _self;
  final $Res Function(CreateOrderRequest) _then;

/// Create a copy of CreateOrderRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? specId = null,}) {
  return _then(CreateOrderRequest(
specId: null == specId ? _self.specId : specId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateOrderRequest].
extension CreateOrderRequestPatterns on CreateOrderRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateOrderRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateOrderRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateOrderRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateOrderRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateOrderRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateOrderRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String specId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateOrderRequest() when $default != null:
return $default(_that.specId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String specId)  $default,) {final _that = this;
switch (_that) {
case _CreateOrderRequest():
return $default(_that.specId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String specId)?  $default,) {final _that = this;
switch (_that) {
case _CreateOrderRequest() when $default != null:
return $default(_that.specId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateOrderRequest implements CreateOrderRequest {
  const _CreateOrderRequest({required this.specId});
  factory _CreateOrderRequest.fromJson(Map<String, dynamic> json) => _$CreateOrderRequestFromJson(json);

@override final  String specId;

/// Create a copy of CreateOrderRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateOrderRequestCopyWith<_CreateOrderRequest> get copyWith => __$CreateOrderRequestCopyWithImpl<_CreateOrderRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateOrderRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateOrderRequest&&(identical(other.specId, specId) || other.specId == specId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,specId);
}

@override
String toString() {
    return 'CreateOrderRequest(specId: $specId)';
}


}

/// @nodoc
abstract mixin class _$CreateOrderRequestCopyWith<$Res> implements $CreateOrderRequestCopyWith<$Res> {
  factory _$CreateOrderRequestCopyWith(_CreateOrderRequest value, $Res Function(_CreateOrderRequest) _then) = __$CreateOrderRequestCopyWithImpl;
@override @useResult
$Res call({
 String specId
});




}
/// @nodoc
class __$CreateOrderRequestCopyWithImpl<$Res>
    implements _$CreateOrderRequestCopyWith<$Res> {
  __$CreateOrderRequestCopyWithImpl(this._self, this._then);

  final _CreateOrderRequest _self;
  final $Res Function(_CreateOrderRequest) _then;

/// Create a copy of CreateOrderRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? specId = null,}) {
  return _then(_CreateOrderRequest(
specId: null == specId ? _self.specId : specId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$OrderResponse {

 Order get order;
/// Create a copy of OrderResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderResponseCopyWith<OrderResponse> get copyWith => _$OrderResponseCopyWithImpl<OrderResponse>(this as OrderResponse, _$identity);

  /// Serializes this OrderResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OrderResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderResponse&&(identical(other.order, _this.order) || other.order == _this.order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OrderResponse;
  return Object.hash(runtimeType,_this.order);
}

@override
String toString() {
  final _this = this as OrderResponse;
  return 'OrderResponse(order: ${_this.order})';
}


}

/// @nodoc
abstract mixin class $OrderResponseCopyWith<$Res>  {
  factory $OrderResponseCopyWith(OrderResponse value, $Res Function(OrderResponse) _then) = _$OrderResponseCopyWithImpl;
@useResult
$Res call({
 Order order
});


$OrderCopyWith<$Res> get order;

}
/// @nodoc
class _$OrderResponseCopyWithImpl<$Res>
    implements $OrderResponseCopyWith<$Res> {
  _$OrderResponseCopyWithImpl(this._self, this._then);

  final OrderResponse _self;
  final $Res Function(OrderResponse) _then;

/// Create a copy of OrderResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? order = null,}) {
  return _then(OrderResponse(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Order,
  ));
}
/// Create a copy of OrderResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderCopyWith<$Res> get order {
  
  return $OrderCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderResponse].
extension OrderResponsePatterns on OrderResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderResponse value)  $default,){
final _that = this;
switch (_that) {
case _OrderResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderResponse value)?  $default,){
final _that = this;
switch (_that) {
case _OrderResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Order order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderResponse() when $default != null:
return $default(_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Order order)  $default,) {final _that = this;
switch (_that) {
case _OrderResponse():
return $default(_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Order order)?  $default,) {final _that = this;
switch (_that) {
case _OrderResponse() when $default != null:
return $default(_that.order);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderResponse implements OrderResponse {
  const _OrderResponse({required this.order});
  factory _OrderResponse.fromJson(Map<String, dynamic> json) => _$OrderResponseFromJson(json);

@override final  Order order;

/// Create a copy of OrderResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderResponseCopyWith<_OrderResponse> get copyWith => __$OrderResponseCopyWithImpl<_OrderResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderResponse&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,order);
}

@override
String toString() {
    return 'OrderResponse(order: $order)';
}


}

/// @nodoc
abstract mixin class _$OrderResponseCopyWith<$Res> implements $OrderResponseCopyWith<$Res> {
  factory _$OrderResponseCopyWith(_OrderResponse value, $Res Function(_OrderResponse) _then) = __$OrderResponseCopyWithImpl;
@override @useResult
$Res call({
 Order order
});


@override $OrderCopyWith<$Res> get order;

}
/// @nodoc
class __$OrderResponseCopyWithImpl<$Res>
    implements _$OrderResponseCopyWith<$Res> {
  __$OrderResponseCopyWithImpl(this._self, this._then);

  final _OrderResponse _self;
  final $Res Function(_OrderResponse) _then;

/// Create a copy of OrderResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? order = null,}) {
  return _then(_OrderResponse(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Order,
  ));
}

/// Create a copy of OrderResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderCopyWith<$Res> get order {
  
  return $OrderCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}


/// @nodoc
mixin _$OrderListResponse {

 List<Order> get orders;
/// Create a copy of OrderListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderListResponseCopyWith<OrderListResponse> get copyWith => _$OrderListResponseCopyWithImpl<OrderListResponse>(this as OrderListResponse, _$identity);

  /// Serializes this OrderListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OrderListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderListResponse&&const DeepCollectionEquality().equals(other.orders, _this.orders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OrderListResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.orders));
}

@override
String toString() {
  final _this = this as OrderListResponse;
  return 'OrderListResponse(orders: ${_this.orders})';
}


}

/// @nodoc
abstract mixin class $OrderListResponseCopyWith<$Res>  {
  factory $OrderListResponseCopyWith(OrderListResponse value, $Res Function(OrderListResponse) _then) = _$OrderListResponseCopyWithImpl;
@useResult
$Res call({
 List<Order> orders
});




}
/// @nodoc
class _$OrderListResponseCopyWithImpl<$Res>
    implements $OrderListResponseCopyWith<$Res> {
  _$OrderListResponseCopyWithImpl(this._self, this._then);

  final OrderListResponse _self;
  final $Res Function(OrderListResponse) _then;

/// Create a copy of OrderListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orders = null,}) {
  return _then(OrderListResponse(
orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as List<Order>,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderListResponse].
extension OrderListResponsePatterns on OrderListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderListResponse value)  $default,){
final _that = this;
switch (_that) {
case _OrderListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _OrderListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Order> orders)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderListResponse() when $default != null:
return $default(_that.orders);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Order> orders)  $default,) {final _that = this;
switch (_that) {
case _OrderListResponse():
return $default(_that.orders);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Order> orders)?  $default,) {final _that = this;
switch (_that) {
case _OrderListResponse() when $default != null:
return $default(_that.orders);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderListResponse implements OrderListResponse {
  const _OrderListResponse({ List<Order> orders = const <Order>[]}): _orders = orders;
  factory _OrderListResponse.fromJson(Map<String, dynamic> json) => _$OrderListResponseFromJson(json);

 final  List<Order> _orders;
@override@JsonKey() List<Order> get orders {
  if (_orders is EqualUnmodifiableListView) return _orders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orders);
}


/// Create a copy of OrderListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderListResponseCopyWith<_OrderListResponse> get copyWith => __$OrderListResponseCopyWithImpl<_OrderListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderListResponse&&const DeepCollectionEquality().equals(other.orders, _orders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_orders));
}

@override
String toString() {
    return 'OrderListResponse(orders: $orders)';
}


}

/// @nodoc
abstract mixin class _$OrderListResponseCopyWith<$Res> implements $OrderListResponseCopyWith<$Res> {
  factory _$OrderListResponseCopyWith(_OrderListResponse value, $Res Function(_OrderListResponse) _then) = __$OrderListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<Order> orders
});




}
/// @nodoc
class __$OrderListResponseCopyWithImpl<$Res>
    implements _$OrderListResponseCopyWith<$Res> {
  __$OrderListResponseCopyWithImpl(this._self, this._then);

  final _OrderListResponse _self;
  final $Res Function(_OrderListResponse) _then;

/// Create a copy of OrderListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orders = null,}) {
  return _then(_OrderListResponse(
orders: null == orders ? _self._orders : orders // ignore: cast_nullable_to_non_nullable
as List<Order>,
  ));
}


}


/// @nodoc
mixin _$PayOrderRequest {

/// The Pterodactyl allocation the server should bind to.
 int get allocationId;/// The label the customer chose for the server.
 String get hostName;/// Optional; when empty the balance flow is used.
 String get key;
/// Create a copy of PayOrderRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayOrderRequestCopyWith<PayOrderRequest> get copyWith => _$PayOrderRequestCopyWithImpl<PayOrderRequest>(this as PayOrderRequest, _$identity);

  /// Serializes this PayOrderRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PayOrderRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayOrderRequest&&(identical(other.allocationId, _this.allocationId) || other.allocationId == _this.allocationId)&&(identical(other.hostName, _this.hostName) || other.hostName == _this.hostName)&&(identical(other.key, _this.key) || other.key == _this.key));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PayOrderRequest;
  return Object.hash(runtimeType,_this.allocationId,_this.hostName,_this.key);
}

@override
String toString() {
  final _this = this as PayOrderRequest;
  return 'PayOrderRequest(allocationId: ${_this.allocationId}, hostName: ${_this.hostName}, key: ${_this.key})';
}


}

/// @nodoc
abstract mixin class $PayOrderRequestCopyWith<$Res>  {
  factory $PayOrderRequestCopyWith(PayOrderRequest value, $Res Function(PayOrderRequest) _then) = _$PayOrderRequestCopyWithImpl;
@useResult
$Res call({
 int allocationId, String hostName, String key
});




}
/// @nodoc
class _$PayOrderRequestCopyWithImpl<$Res>
    implements $PayOrderRequestCopyWith<$Res> {
  _$PayOrderRequestCopyWithImpl(this._self, this._then);

  final PayOrderRequest _self;
  final $Res Function(PayOrderRequest) _then;

/// Create a copy of PayOrderRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allocationId = null,Object? hostName = null,Object? key = null,}) {
  return _then(PayOrderRequest(
allocationId: null == allocationId ? _self.allocationId : allocationId // ignore: cast_nullable_to_non_nullable
as int,hostName: null == hostName ? _self.hostName : hostName // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PayOrderRequest].
extension PayOrderRequestPatterns on PayOrderRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PayOrderRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PayOrderRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PayOrderRequest value)  $default,){
final _that = this;
switch (_that) {
case _PayOrderRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PayOrderRequest value)?  $default,){
final _that = this;
switch (_that) {
case _PayOrderRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int allocationId,  String hostName,  String key)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PayOrderRequest() when $default != null:
return $default(_that.allocationId,_that.hostName,_that.key);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int allocationId,  String hostName,  String key)  $default,) {final _that = this;
switch (_that) {
case _PayOrderRequest():
return $default(_that.allocationId,_that.hostName,_that.key);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int allocationId,  String hostName,  String key)?  $default,) {final _that = this;
switch (_that) {
case _PayOrderRequest() when $default != null:
return $default(_that.allocationId,_that.hostName,_that.key);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PayOrderRequest implements PayOrderRequest {
  const _PayOrderRequest({this.allocationId = 0, required this.hostName, this.key = ''});
  factory _PayOrderRequest.fromJson(Map<String, dynamic> json) => _$PayOrderRequestFromJson(json);

/// The Pterodactyl allocation the server should bind to.
@override@JsonKey() final  int allocationId;
/// The label the customer chose for the server.
@override final  String hostName;
/// Optional; when empty the balance flow is used.
@override@JsonKey() final  String key;

/// Create a copy of PayOrderRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayOrderRequestCopyWith<_PayOrderRequest> get copyWith => __$PayOrderRequestCopyWithImpl<_PayOrderRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PayOrderRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayOrderRequest&&(identical(other.allocationId, allocationId) || other.allocationId == allocationId)&&(identical(other.hostName, hostName) || other.hostName == hostName)&&(identical(other.key, key) || other.key == key));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,allocationId,hostName,key);
}

@override
String toString() {
    return 'PayOrderRequest(allocationId: $allocationId, hostName: $hostName, key: $key)';
}


}

/// @nodoc
abstract mixin class _$PayOrderRequestCopyWith<$Res> implements $PayOrderRequestCopyWith<$Res> {
  factory _$PayOrderRequestCopyWith(_PayOrderRequest value, $Res Function(_PayOrderRequest) _then) = __$PayOrderRequestCopyWithImpl;
@override @useResult
$Res call({
 int allocationId, String hostName, String key
});




}
/// @nodoc
class __$PayOrderRequestCopyWithImpl<$Res>
    implements _$PayOrderRequestCopyWith<$Res> {
  __$PayOrderRequestCopyWithImpl(this._self, this._then);

  final _PayOrderRequest _self;
  final $Res Function(_PayOrderRequest) _then;

/// Create a copy of PayOrderRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allocationId = null,Object? hostName = null,Object? key = null,}) {
  return _then(_PayOrderRequest(
allocationId: null == allocationId ? _self.allocationId : allocationId // ignore: cast_nullable_to_non_nullable
as int,hostName: null == hostName ? _self.hostName : hostName // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ServerListResponse {

 List<WareEntity> get servers;
/// Create a copy of ServerListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerListResponseCopyWith<ServerListResponse> get copyWith => _$ServerListResponseCopyWithImpl<ServerListResponse>(this as ServerListResponse, _$identity);

  /// Serializes this ServerListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ServerListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerListResponse&&const DeepCollectionEquality().equals(other.servers, _this.servers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ServerListResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.servers));
}

@override
String toString() {
  final _this = this as ServerListResponse;
  return 'ServerListResponse(servers: ${_this.servers})';
}


}

/// @nodoc
abstract mixin class $ServerListResponseCopyWith<$Res>  {
  factory $ServerListResponseCopyWith(ServerListResponse value, $Res Function(ServerListResponse) _then) = _$ServerListResponseCopyWithImpl;
@useResult
$Res call({
 List<WareEntity> servers
});




}
/// @nodoc
class _$ServerListResponseCopyWithImpl<$Res>
    implements $ServerListResponseCopyWith<$Res> {
  _$ServerListResponseCopyWithImpl(this._self, this._then);

  final ServerListResponse _self;
  final $Res Function(ServerListResponse) _then;

/// Create a copy of ServerListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? servers = null,}) {
  return _then(ServerListResponse(
servers: null == servers ? _self.servers : servers // ignore: cast_nullable_to_non_nullable
as List<WareEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerListResponse].
extension ServerListResponsePatterns on ServerListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerListResponse value)  $default,){
final _that = this;
switch (_that) {
case _ServerListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ServerListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<WareEntity> servers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerListResponse() when $default != null:
return $default(_that.servers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<WareEntity> servers)  $default,) {final _that = this;
switch (_that) {
case _ServerListResponse():
return $default(_that.servers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<WareEntity> servers)?  $default,) {final _that = this;
switch (_that) {
case _ServerListResponse() when $default != null:
return $default(_that.servers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServerListResponse implements ServerListResponse {
  const _ServerListResponse({ List<WareEntity> servers = const <WareEntity>[]}): _servers = servers;
  factory _ServerListResponse.fromJson(Map<String, dynamic> json) => _$ServerListResponseFromJson(json);

 final  List<WareEntity> _servers;
@override@JsonKey() List<WareEntity> get servers {
  if (_servers is EqualUnmodifiableListView) return _servers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_servers);
}


/// Create a copy of ServerListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerListResponseCopyWith<_ServerListResponse> get copyWith => __$ServerListResponseCopyWithImpl<_ServerListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServerListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerListResponse&&const DeepCollectionEquality().equals(other.servers, _servers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_servers));
}

@override
String toString() {
    return 'ServerListResponse(servers: $servers)';
}


}

/// @nodoc
abstract mixin class _$ServerListResponseCopyWith<$Res> implements $ServerListResponseCopyWith<$Res> {
  factory _$ServerListResponseCopyWith(_ServerListResponse value, $Res Function(_ServerListResponse) _then) = __$ServerListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<WareEntity> servers
});




}
/// @nodoc
class __$ServerListResponseCopyWithImpl<$Res>
    implements _$ServerListResponseCopyWith<$Res> {
  __$ServerListResponseCopyWithImpl(this._self, this._then);

  final _ServerListResponse _self;
  final $Res Function(_ServerListResponse) _then;

/// Create a copy of ServerListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? servers = null,}) {
  return _then(_ServerListResponse(
servers: null == servers ? _self._servers : servers // ignore: cast_nullable_to_non_nullable
as List<WareEntity>,
  ));
}


}


/// @nodoc
mixin _$ServerDetailResponse {

 WareEntity get server;
/// Create a copy of ServerDetailResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerDetailResponseCopyWith<ServerDetailResponse> get copyWith => _$ServerDetailResponseCopyWithImpl<ServerDetailResponse>(this as ServerDetailResponse, _$identity);

  /// Serializes this ServerDetailResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ServerDetailResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerDetailResponse&&(identical(other.server, _this.server) || other.server == _this.server));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ServerDetailResponse;
  return Object.hash(runtimeType,_this.server);
}

@override
String toString() {
  final _this = this as ServerDetailResponse;
  return 'ServerDetailResponse(server: ${_this.server})';
}


}

/// @nodoc
abstract mixin class $ServerDetailResponseCopyWith<$Res>  {
  factory $ServerDetailResponseCopyWith(ServerDetailResponse value, $Res Function(ServerDetailResponse) _then) = _$ServerDetailResponseCopyWithImpl;
@useResult
$Res call({
 WareEntity server
});


$WareEntityCopyWith<$Res> get server;

}
/// @nodoc
class _$ServerDetailResponseCopyWithImpl<$Res>
    implements $ServerDetailResponseCopyWith<$Res> {
  _$ServerDetailResponseCopyWithImpl(this._self, this._then);

  final ServerDetailResponse _self;
  final $Res Function(ServerDetailResponse) _then;

/// Create a copy of ServerDetailResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? server = null,}) {
  return _then(ServerDetailResponse(
server: null == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as WareEntity,
  ));
}
/// Create a copy of ServerDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WareEntityCopyWith<$Res> get server {
  
  return $WareEntityCopyWith<$Res>(_self.server, (value) {
    return _then(_self.copyWith(server: value));
  });
}
}


/// Adds pattern-matching-related methods to [ServerDetailResponse].
extension ServerDetailResponsePatterns on ServerDetailResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerDetailResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerDetailResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerDetailResponse value)  $default,){
final _that = this;
switch (_that) {
case _ServerDetailResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerDetailResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ServerDetailResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WareEntity server)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerDetailResponse() when $default != null:
return $default(_that.server);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WareEntity server)  $default,) {final _that = this;
switch (_that) {
case _ServerDetailResponse():
return $default(_that.server);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WareEntity server)?  $default,) {final _that = this;
switch (_that) {
case _ServerDetailResponse() when $default != null:
return $default(_that.server);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServerDetailResponse implements ServerDetailResponse {
  const _ServerDetailResponse({required this.server});
  factory _ServerDetailResponse.fromJson(Map<String, dynamic> json) => _$ServerDetailResponseFromJson(json);

@override final  WareEntity server;

/// Create a copy of ServerDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerDetailResponseCopyWith<_ServerDetailResponse> get copyWith => __$ServerDetailResponseCopyWithImpl<_ServerDetailResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServerDetailResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerDetailResponse&&(identical(other.server, server) || other.server == server));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,server);
}

@override
String toString() {
    return 'ServerDetailResponse(server: $server)';
}


}

/// @nodoc
abstract mixin class _$ServerDetailResponseCopyWith<$Res> implements $ServerDetailResponseCopyWith<$Res> {
  factory _$ServerDetailResponseCopyWith(_ServerDetailResponse value, $Res Function(_ServerDetailResponse) _then) = __$ServerDetailResponseCopyWithImpl;
@override @useResult
$Res call({
 WareEntity server
});


@override $WareEntityCopyWith<$Res> get server;

}
/// @nodoc
class __$ServerDetailResponseCopyWithImpl<$Res>
    implements _$ServerDetailResponseCopyWith<$Res> {
  __$ServerDetailResponseCopyWithImpl(this._self, this._then);

  final _ServerDetailResponse _self;
  final $Res Function(_ServerDetailResponse) _then;

/// Create a copy of ServerDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? server = null,}) {
  return _then(_ServerDetailResponse(
server: null == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as WareEntity,
  ));
}

/// Create a copy of ServerDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WareEntityCopyWith<$Res> get server {
  
  return $WareEntityCopyWith<$Res>(_self.server, (value) {
    return _then(_self.copyWith(server: value));
  });
}
}


/// @nodoc
mixin _$StatusListResponse {

 List<ServerStatus> get servers;
/// Create a copy of StatusListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatusListResponseCopyWith<StatusListResponse> get copyWith => _$StatusListResponseCopyWithImpl<StatusListResponse>(this as StatusListResponse, _$identity);

  /// Serializes this StatusListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StatusListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatusListResponse&&const DeepCollectionEquality().equals(other.servers, _this.servers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StatusListResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.servers));
}

@override
String toString() {
  final _this = this as StatusListResponse;
  return 'StatusListResponse(servers: ${_this.servers})';
}


}

/// @nodoc
abstract mixin class $StatusListResponseCopyWith<$Res>  {
  factory $StatusListResponseCopyWith(StatusListResponse value, $Res Function(StatusListResponse) _then) = _$StatusListResponseCopyWithImpl;
@useResult
$Res call({
 List<ServerStatus> servers
});




}
/// @nodoc
class _$StatusListResponseCopyWithImpl<$Res>
    implements $StatusListResponseCopyWith<$Res> {
  _$StatusListResponseCopyWithImpl(this._self, this._then);

  final StatusListResponse _self;
  final $Res Function(StatusListResponse) _then;

/// Create a copy of StatusListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? servers = null,}) {
  return _then(StatusListResponse(
servers: null == servers ? _self.servers : servers // ignore: cast_nullable_to_non_nullable
as List<ServerStatus>,
  ));
}

}


/// Adds pattern-matching-related methods to [StatusListResponse].
extension StatusListResponsePatterns on StatusListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatusListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatusListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatusListResponse value)  $default,){
final _that = this;
switch (_that) {
case _StatusListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatusListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StatusListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ServerStatus> servers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatusListResponse() when $default != null:
return $default(_that.servers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ServerStatus> servers)  $default,) {final _that = this;
switch (_that) {
case _StatusListResponse():
return $default(_that.servers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ServerStatus> servers)?  $default,) {final _that = this;
switch (_that) {
case _StatusListResponse() when $default != null:
return $default(_that.servers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StatusListResponse implements StatusListResponse {
  const _StatusListResponse({ List<ServerStatus> servers = const <ServerStatus>[]}): _servers = servers;
  factory _StatusListResponse.fromJson(Map<String, dynamic> json) => _$StatusListResponseFromJson(json);

 final  List<ServerStatus> _servers;
@override@JsonKey() List<ServerStatus> get servers {
  if (_servers is EqualUnmodifiableListView) return _servers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_servers);
}


/// Create a copy of StatusListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatusListResponseCopyWith<_StatusListResponse> get copyWith => __$StatusListResponseCopyWithImpl<_StatusListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StatusListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatusListResponse&&const DeepCollectionEquality().equals(other.servers, _servers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_servers));
}

@override
String toString() {
    return 'StatusListResponse(servers: $servers)';
}


}

/// @nodoc
abstract mixin class _$StatusListResponseCopyWith<$Res> implements $StatusListResponseCopyWith<$Res> {
  factory _$StatusListResponseCopyWith(_StatusListResponse value, $Res Function(_StatusListResponse) _then) = __$StatusListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<ServerStatus> servers
});




}
/// @nodoc
class __$StatusListResponseCopyWithImpl<$Res>
    implements _$StatusListResponseCopyWith<$Res> {
  __$StatusListResponseCopyWithImpl(this._self, this._then);

  final _StatusListResponse _self;
  final $Res Function(_StatusListResponse) _then;

/// Create a copy of StatusListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? servers = null,}) {
  return _then(_StatusListResponse(
servers: null == servers ? _self._servers : servers // ignore: cast_nullable_to_non_nullable
as List<ServerStatus>,
  ));
}


}


/// @nodoc
mixin _$ServerStatus {

 String get entityId; String get externalId; String get hostName; String get validDate; int get deleteStatus; bool get suspended; String get identifier; String get panelName; bool get online; String get version; String get motd; int get playerCount; int get playerMax;/// True while the ping is still in flight, so the row can show a spinner
/// instead of claiming the server is offline.
 bool get probing;
/// Create a copy of ServerStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerStatusCopyWith<ServerStatus> get copyWith => _$ServerStatusCopyWithImpl<ServerStatus>(this as ServerStatus, _$identity);

  /// Serializes this ServerStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ServerStatus;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerStatus&&(identical(other.entityId, _this.entityId) || other.entityId == _this.entityId)&&(identical(other.externalId, _this.externalId) || other.externalId == _this.externalId)&&(identical(other.hostName, _this.hostName) || other.hostName == _this.hostName)&&(identical(other.validDate, _this.validDate) || other.validDate == _this.validDate)&&(identical(other.deleteStatus, _this.deleteStatus) || other.deleteStatus == _this.deleteStatus)&&(identical(other.suspended, _this.suspended) || other.suspended == _this.suspended)&&(identical(other.identifier, _this.identifier) || other.identifier == _this.identifier)&&(identical(other.panelName, _this.panelName) || other.panelName == _this.panelName)&&(identical(other.online, _this.online) || other.online == _this.online)&&(identical(other.version, _this.version) || other.version == _this.version)&&(identical(other.motd, _this.motd) || other.motd == _this.motd)&&(identical(other.playerCount, _this.playerCount) || other.playerCount == _this.playerCount)&&(identical(other.playerMax, _this.playerMax) || other.playerMax == _this.playerMax)&&(identical(other.probing, _this.probing) || other.probing == _this.probing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ServerStatus;
  return Object.hash(runtimeType,_this.entityId,_this.externalId,_this.hostName,_this.validDate,_this.deleteStatus,_this.suspended,_this.identifier,_this.panelName,_this.online,_this.version,_this.motd,_this.playerCount,_this.playerMax,_this.probing);
}

@override
String toString() {
  final _this = this as ServerStatus;
  return 'ServerStatus(entityId: ${_this.entityId}, externalId: ${_this.externalId}, hostName: ${_this.hostName}, validDate: ${_this.validDate}, deleteStatus: ${_this.deleteStatus}, suspended: ${_this.suspended}, identifier: ${_this.identifier}, panelName: ${_this.panelName}, online: ${_this.online}, version: ${_this.version}, motd: ${_this.motd}, playerCount: ${_this.playerCount}, playerMax: ${_this.playerMax}, probing: ${_this.probing})';
}


}

/// @nodoc
abstract mixin class $ServerStatusCopyWith<$Res>  {
  factory $ServerStatusCopyWith(ServerStatus value, $Res Function(ServerStatus) _then) = _$ServerStatusCopyWithImpl;
@useResult
$Res call({
 String entityId, String externalId, String hostName, String validDate, int deleteStatus, bool suspended, String identifier, String panelName, bool online, String version, String motd, int playerCount, int playerMax, bool probing
});




}
/// @nodoc
class _$ServerStatusCopyWithImpl<$Res>
    implements $ServerStatusCopyWith<$Res> {
  _$ServerStatusCopyWithImpl(this._self, this._then);

  final ServerStatus _self;
  final $Res Function(ServerStatus) _then;

/// Create a copy of ServerStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entityId = null,Object? externalId = null,Object? hostName = null,Object? validDate = null,Object? deleteStatus = null,Object? suspended = null,Object? identifier = null,Object? panelName = null,Object? online = null,Object? version = null,Object? motd = null,Object? playerCount = null,Object? playerMax = null,Object? probing = null,}) {
  return _then(ServerStatus(
entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,externalId: null == externalId ? _self.externalId : externalId // ignore: cast_nullable_to_non_nullable
as String,hostName: null == hostName ? _self.hostName : hostName // ignore: cast_nullable_to_non_nullable
as String,validDate: null == validDate ? _self.validDate : validDate // ignore: cast_nullable_to_non_nullable
as String,deleteStatus: null == deleteStatus ? _self.deleteStatus : deleteStatus // ignore: cast_nullable_to_non_nullable
as int,suspended: null == suspended ? _self.suspended : suspended // ignore: cast_nullable_to_non_nullable
as bool,identifier: null == identifier ? _self.identifier : identifier // ignore: cast_nullable_to_non_nullable
as String,panelName: null == panelName ? _self.panelName : panelName // ignore: cast_nullable_to_non_nullable
as String,online: null == online ? _self.online : online // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,motd: null == motd ? _self.motd : motd // ignore: cast_nullable_to_non_nullable
as String,playerCount: null == playerCount ? _self.playerCount : playerCount // ignore: cast_nullable_to_non_nullable
as int,playerMax: null == playerMax ? _self.playerMax : playerMax // ignore: cast_nullable_to_non_nullable
as int,probing: null == probing ? _self.probing : probing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerStatus].
extension ServerStatusPatterns on ServerStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerStatus value)  $default,){
final _that = this;
switch (_that) {
case _ServerStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerStatus value)?  $default,){
final _that = this;
switch (_that) {
case _ServerStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String entityId,  String externalId,  String hostName,  String validDate,  int deleteStatus,  bool suspended,  String identifier,  String panelName,  bool online,  String version,  String motd,  int playerCount,  int playerMax,  bool probing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerStatus() when $default != null:
return $default(_that.entityId,_that.externalId,_that.hostName,_that.validDate,_that.deleteStatus,_that.suspended,_that.identifier,_that.panelName,_that.online,_that.version,_that.motd,_that.playerCount,_that.playerMax,_that.probing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String entityId,  String externalId,  String hostName,  String validDate,  int deleteStatus,  bool suspended,  String identifier,  String panelName,  bool online,  String version,  String motd,  int playerCount,  int playerMax,  bool probing)  $default,) {final _that = this;
switch (_that) {
case _ServerStatus():
return $default(_that.entityId,_that.externalId,_that.hostName,_that.validDate,_that.deleteStatus,_that.suspended,_that.identifier,_that.panelName,_that.online,_that.version,_that.motd,_that.playerCount,_that.playerMax,_that.probing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String entityId,  String externalId,  String hostName,  String validDate,  int deleteStatus,  bool suspended,  String identifier,  String panelName,  bool online,  String version,  String motd,  int playerCount,  int playerMax,  bool probing)?  $default,) {final _that = this;
switch (_that) {
case _ServerStatus() when $default != null:
return $default(_that.entityId,_that.externalId,_that.hostName,_that.validDate,_that.deleteStatus,_that.suspended,_that.identifier,_that.panelName,_that.online,_that.version,_that.motd,_that.playerCount,_that.playerMax,_that.probing);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServerStatus extends ServerStatus {
  const _ServerStatus({this.entityId = '', this.externalId = '', this.hostName = '', this.validDate = '', this.deleteStatus = 0, this.suspended = false, this.identifier = '', this.panelName = '', this.online = false, this.version = '', this.motd = '', this.playerCount = 0, this.playerMax = 0, this.probing = false}): super._();
  factory _ServerStatus.fromJson(Map<String, dynamic> json) => _$ServerStatusFromJson(json);

@override@JsonKey() final  String entityId;
@override@JsonKey() final  String externalId;
@override@JsonKey() final  String hostName;
@override@JsonKey() final  String validDate;
@override@JsonKey() final  int deleteStatus;
@override@JsonKey() final  bool suspended;
@override@JsonKey() final  String identifier;
@override@JsonKey() final  String panelName;
@override@JsonKey() final  bool online;
@override@JsonKey() final  String version;
@override@JsonKey() final  String motd;
@override@JsonKey() final  int playerCount;
@override@JsonKey() final  int playerMax;
/// True while the ping is still in flight, so the row can show a spinner
/// instead of claiming the server is offline.
@override@JsonKey() final  bool probing;

/// Create a copy of ServerStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerStatusCopyWith<_ServerStatus> get copyWith => __$ServerStatusCopyWithImpl<_ServerStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServerStatusToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerStatus&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.externalId, externalId) || other.externalId == externalId)&&(identical(other.hostName, hostName) || other.hostName == hostName)&&(identical(other.validDate, validDate) || other.validDate == validDate)&&(identical(other.deleteStatus, deleteStatus) || other.deleteStatus == deleteStatus)&&(identical(other.suspended, suspended) || other.suspended == suspended)&&(identical(other.identifier, identifier) || other.identifier == identifier)&&(identical(other.panelName, panelName) || other.panelName == panelName)&&(identical(other.online, online) || other.online == online)&&(identical(other.version, version) || other.version == version)&&(identical(other.motd, motd) || other.motd == motd)&&(identical(other.playerCount, playerCount) || other.playerCount == playerCount)&&(identical(other.playerMax, playerMax) || other.playerMax == playerMax)&&(identical(other.probing, probing) || other.probing == probing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,entityId,externalId,hostName,validDate,deleteStatus,suspended,identifier,panelName,online,version,motd,playerCount,playerMax,probing);
}

@override
String toString() {
    return 'ServerStatus(entityId: $entityId, externalId: $externalId, hostName: $hostName, validDate: $validDate, deleteStatus: $deleteStatus, suspended: $suspended, identifier: $identifier, panelName: $panelName, online: $online, version: $version, motd: $motd, playerCount: $playerCount, playerMax: $playerMax, probing: $probing)';
}


}

/// @nodoc
abstract mixin class _$ServerStatusCopyWith<$Res> implements $ServerStatusCopyWith<$Res> {
  factory _$ServerStatusCopyWith(_ServerStatus value, $Res Function(_ServerStatus) _then) = __$ServerStatusCopyWithImpl;
@override @useResult
$Res call({
 String entityId, String externalId, String hostName, String validDate, int deleteStatus, bool suspended, String identifier, String panelName, bool online, String version, String motd, int playerCount, int playerMax, bool probing
});




}
/// @nodoc
class __$ServerStatusCopyWithImpl<$Res>
    implements _$ServerStatusCopyWith<$Res> {
  __$ServerStatusCopyWithImpl(this._self, this._then);

  final _ServerStatus _self;
  final $Res Function(_ServerStatus) _then;

/// Create a copy of ServerStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entityId = null,Object? externalId = null,Object? hostName = null,Object? validDate = null,Object? deleteStatus = null,Object? suspended = null,Object? identifier = null,Object? panelName = null,Object? online = null,Object? version = null,Object? motd = null,Object? playerCount = null,Object? playerMax = null,Object? probing = null,}) {
  return _then(_ServerStatus(
entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,externalId: null == externalId ? _self.externalId : externalId // ignore: cast_nullable_to_non_nullable
as String,hostName: null == hostName ? _self.hostName : hostName // ignore: cast_nullable_to_non_nullable
as String,validDate: null == validDate ? _self.validDate : validDate // ignore: cast_nullable_to_non_nullable
as String,deleteStatus: null == deleteStatus ? _self.deleteStatus : deleteStatus // ignore: cast_nullable_to_non_nullable
as int,suspended: null == suspended ? _self.suspended : suspended // ignore: cast_nullable_to_non_nullable
as bool,identifier: null == identifier ? _self.identifier : identifier // ignore: cast_nullable_to_non_nullable
as String,panelName: null == panelName ? _self.panelName : panelName // ignore: cast_nullable_to_non_nullable
as String,online: null == online ? _self.online : online // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,motd: null == motd ? _self.motd : motd // ignore: cast_nullable_to_non_nullable
as String,playerCount: null == playerCount ? _self.playerCount : playerCount // ignore: cast_nullable_to_non_nullable
as int,playerMax: null == playerMax ? _self.playerMax : playerMax // ignore: cast_nullable_to_non_nullable
as int,probing: null == probing ? _self.probing : probing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$RenewRequest {

/// The product key; the legacy URL carried it as a path segment.
 String get key;
/// Create a copy of RenewRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenewRequestCopyWith<RenewRequest> get copyWith => _$RenewRequestCopyWithImpl<RenewRequest>(this as RenewRequest, _$identity);

  /// Serializes this RenewRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RenewRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenewRequest&&(identical(other.key, _this.key) || other.key == _this.key));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RenewRequest;
  return Object.hash(runtimeType,_this.key);
}

@override
String toString() {
  final _this = this as RenewRequest;
  return 'RenewRequest(key: ${_this.key})';
}


}

/// @nodoc
abstract mixin class $RenewRequestCopyWith<$Res>  {
  factory $RenewRequestCopyWith(RenewRequest value, $Res Function(RenewRequest) _then) = _$RenewRequestCopyWithImpl;
@useResult
$Res call({
 String key
});




}
/// @nodoc
class _$RenewRequestCopyWithImpl<$Res>
    implements $RenewRequestCopyWith<$Res> {
  _$RenewRequestCopyWithImpl(this._self, this._then);

  final RenewRequest _self;
  final $Res Function(RenewRequest) _then;

/// Create a copy of RenewRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,}) {
  return _then(RenewRequest(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RenewRequest].
extension RenewRequestPatterns on RenewRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RenewRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RenewRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RenewRequest value)  $default,){
final _that = this;
switch (_that) {
case _RenewRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RenewRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RenewRequest() when $default != null:
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
case _RenewRequest() when $default != null:
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
case _RenewRequest():
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
case _RenewRequest() when $default != null:
return $default(_that.key);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RenewRequest implements RenewRequest {
  const _RenewRequest({required this.key});
  factory _RenewRequest.fromJson(Map<String, dynamic> json) => _$RenewRequestFromJson(json);

/// The product key; the legacy URL carried it as a path segment.
@override final  String key;

/// Create a copy of RenewRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RenewRequestCopyWith<_RenewRequest> get copyWith => __$RenewRequestCopyWithImpl<_RenewRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RenewRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RenewRequest&&(identical(other.key, key) || other.key == key));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key);
}

@override
String toString() {
    return 'RenewRequest(key: $key)';
}


}

/// @nodoc
abstract mixin class _$RenewRequestCopyWith<$Res> implements $RenewRequestCopyWith<$Res> {
  factory _$RenewRequestCopyWith(_RenewRequest value, $Res Function(_RenewRequest) _then) = __$RenewRequestCopyWithImpl;
@override @useResult
$Res call({
 String key
});




}
/// @nodoc
class __$RenewRequestCopyWithImpl<$Res>
    implements _$RenewRequestCopyWith<$Res> {
  __$RenewRequestCopyWithImpl(this._self, this._then);

  final _RenewRequest _self;
  final $Res Function(_RenewRequest) _then;

/// Create a copy of RenewRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,}) {
  return _then(_RenewRequest(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ReinstallRequest {

 int get eggId;
/// Create a copy of ReinstallRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReinstallRequestCopyWith<ReinstallRequest> get copyWith => _$ReinstallRequestCopyWithImpl<ReinstallRequest>(this as ReinstallRequest, _$identity);

  /// Serializes this ReinstallRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReinstallRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReinstallRequest&&(identical(other.eggId, _this.eggId) || other.eggId == _this.eggId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReinstallRequest;
  return Object.hash(runtimeType,_this.eggId);
}

@override
String toString() {
  final _this = this as ReinstallRequest;
  return 'ReinstallRequest(eggId: ${_this.eggId})';
}


}

/// @nodoc
abstract mixin class $ReinstallRequestCopyWith<$Res>  {
  factory $ReinstallRequestCopyWith(ReinstallRequest value, $Res Function(ReinstallRequest) _then) = _$ReinstallRequestCopyWithImpl;
@useResult
$Res call({
 int eggId
});




}
/// @nodoc
class _$ReinstallRequestCopyWithImpl<$Res>
    implements $ReinstallRequestCopyWith<$Res> {
  _$ReinstallRequestCopyWithImpl(this._self, this._then);

  final ReinstallRequest _self;
  final $Res Function(ReinstallRequest) _then;

/// Create a copy of ReinstallRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? eggId = null,}) {
  return _then(ReinstallRequest(
eggId: null == eggId ? _self.eggId : eggId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReinstallRequest].
extension ReinstallRequestPatterns on ReinstallRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReinstallRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReinstallRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReinstallRequest value)  $default,){
final _that = this;
switch (_that) {
case _ReinstallRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReinstallRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ReinstallRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int eggId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReinstallRequest() when $default != null:
return $default(_that.eggId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int eggId)  $default,) {final _that = this;
switch (_that) {
case _ReinstallRequest():
return $default(_that.eggId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int eggId)?  $default,) {final _that = this;
switch (_that) {
case _ReinstallRequest() when $default != null:
return $default(_that.eggId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReinstallRequest implements ReinstallRequest {
  const _ReinstallRequest({this.eggId = 0});
  factory _ReinstallRequest.fromJson(Map<String, dynamic> json) => _$ReinstallRequestFromJson(json);

@override@JsonKey() final  int eggId;

/// Create a copy of ReinstallRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReinstallRequestCopyWith<_ReinstallRequest> get copyWith => __$ReinstallRequestCopyWithImpl<_ReinstallRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReinstallRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReinstallRequest&&(identical(other.eggId, eggId) || other.eggId == eggId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,eggId);
}

@override
String toString() {
    return 'ReinstallRequest(eggId: $eggId)';
}


}

/// @nodoc
abstract mixin class _$ReinstallRequestCopyWith<$Res> implements $ReinstallRequestCopyWith<$Res> {
  factory _$ReinstallRequestCopyWith(_ReinstallRequest value, $Res Function(_ReinstallRequest) _then) = __$ReinstallRequestCopyWithImpl;
@override @useResult
$Res call({
 int eggId
});




}
/// @nodoc
class __$ReinstallRequestCopyWithImpl<$Res>
    implements _$ReinstallRequestCopyWith<$Res> {
  __$ReinstallRequestCopyWithImpl(this._self, this._then);

  final _ReinstallRequest _self;
  final $Res Function(_ReinstallRequest) _then;

/// Create a copy of ReinstallRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? eggId = null,}) {
  return _then(_ReinstallRequest(
eggId: null == eggId ? _self.eggId : eggId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Allocation {

 int get id;/// The `alias:port` label the customer picks from.
 String get address;
/// Create a copy of Allocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AllocationCopyWith<Allocation> get copyWith => _$AllocationCopyWithImpl<Allocation>(this as Allocation, _$identity);

  /// Serializes this Allocation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Allocation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Allocation&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.address, _this.address) || other.address == _this.address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Allocation;
  return Object.hash(runtimeType,_this.id,_this.address);
}

@override
String toString() {
  final _this = this as Allocation;
  return 'Allocation(id: ${_this.id}, address: ${_this.address})';
}


}

/// @nodoc
abstract mixin class $AllocationCopyWith<$Res>  {
  factory $AllocationCopyWith(Allocation value, $Res Function(Allocation) _then) = _$AllocationCopyWithImpl;
@useResult
$Res call({
 int id, String address
});




}
/// @nodoc
class _$AllocationCopyWithImpl<$Res>
    implements $AllocationCopyWith<$Res> {
  _$AllocationCopyWithImpl(this._self, this._then);

  final Allocation _self;
  final $Res Function(Allocation) _then;

/// Create a copy of Allocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? address = null,}) {
  return _then(Allocation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Allocation].
extension AllocationPatterns on Allocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Allocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Allocation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Allocation value)  $default,){
final _that = this;
switch (_that) {
case _Allocation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Allocation value)?  $default,){
final _that = this;
switch (_that) {
case _Allocation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String address)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Allocation() when $default != null:
return $default(_that.id,_that.address);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String address)  $default,) {final _that = this;
switch (_that) {
case _Allocation():
return $default(_that.id,_that.address);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String address)?  $default,) {final _that = this;
switch (_that) {
case _Allocation() when $default != null:
return $default(_that.id,_that.address);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Allocation implements Allocation {
  const _Allocation({this.id = 0, this.address = ''});
  factory _Allocation.fromJson(Map<String, dynamic> json) => _$AllocationFromJson(json);

@override@JsonKey() final  int id;
/// The `alias:port` label the customer picks from.
@override@JsonKey() final  String address;

/// Create a copy of Allocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AllocationCopyWith<_Allocation> get copyWith => __$AllocationCopyWithImpl<_Allocation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AllocationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Allocation&&(identical(other.id, id) || other.id == id)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,address);
}

@override
String toString() {
    return 'Allocation(id: $id, address: $address)';
}


}

/// @nodoc
abstract mixin class _$AllocationCopyWith<$Res> implements $AllocationCopyWith<$Res> {
  factory _$AllocationCopyWith(_Allocation value, $Res Function(_Allocation) _then) = __$AllocationCopyWithImpl;
@override @useResult
$Res call({
 int id, String address
});




}
/// @nodoc
class __$AllocationCopyWithImpl<$Res>
    implements _$AllocationCopyWith<$Res> {
  __$AllocationCopyWithImpl(this._self, this._then);

  final _Allocation _self;
  final $Res Function(_Allocation) _then;

/// Create a copy of Allocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? address = null,}) {
  return _then(_Allocation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AllocationListResponse {

 List<Allocation> get allocations;
/// Create a copy of AllocationListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AllocationListResponseCopyWith<AllocationListResponse> get copyWith => _$AllocationListResponseCopyWithImpl<AllocationListResponse>(this as AllocationListResponse, _$identity);

  /// Serializes this AllocationListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AllocationListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AllocationListResponse&&const DeepCollectionEquality().equals(other.allocations, _this.allocations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AllocationListResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.allocations));
}

@override
String toString() {
  final _this = this as AllocationListResponse;
  return 'AllocationListResponse(allocations: ${_this.allocations})';
}


}

/// @nodoc
abstract mixin class $AllocationListResponseCopyWith<$Res>  {
  factory $AllocationListResponseCopyWith(AllocationListResponse value, $Res Function(AllocationListResponse) _then) = _$AllocationListResponseCopyWithImpl;
@useResult
$Res call({
 List<Allocation> allocations
});




}
/// @nodoc
class _$AllocationListResponseCopyWithImpl<$Res>
    implements $AllocationListResponseCopyWith<$Res> {
  _$AllocationListResponseCopyWithImpl(this._self, this._then);

  final AllocationListResponse _self;
  final $Res Function(AllocationListResponse) _then;

/// Create a copy of AllocationListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allocations = null,}) {
  return _then(AllocationListResponse(
allocations: null == allocations ? _self.allocations : allocations // ignore: cast_nullable_to_non_nullable
as List<Allocation>,
  ));
}

}


/// Adds pattern-matching-related methods to [AllocationListResponse].
extension AllocationListResponsePatterns on AllocationListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AllocationListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AllocationListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AllocationListResponse value)  $default,){
final _that = this;
switch (_that) {
case _AllocationListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AllocationListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AllocationListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Allocation> allocations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AllocationListResponse() when $default != null:
return $default(_that.allocations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Allocation> allocations)  $default,) {final _that = this;
switch (_that) {
case _AllocationListResponse():
return $default(_that.allocations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Allocation> allocations)?  $default,) {final _that = this;
switch (_that) {
case _AllocationListResponse() when $default != null:
return $default(_that.allocations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AllocationListResponse implements AllocationListResponse {
  const _AllocationListResponse({ List<Allocation> allocations = const <Allocation>[]}): _allocations = allocations;
  factory _AllocationListResponse.fromJson(Map<String, dynamic> json) => _$AllocationListResponseFromJson(json);

 final  List<Allocation> _allocations;
@override@JsonKey() List<Allocation> get allocations {
  if (_allocations is EqualUnmodifiableListView) return _allocations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allocations);
}


/// Create a copy of AllocationListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AllocationListResponseCopyWith<_AllocationListResponse> get copyWith => __$AllocationListResponseCopyWithImpl<_AllocationListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AllocationListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AllocationListResponse&&const DeepCollectionEquality().equals(other.allocations, _allocations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_allocations));
}

@override
String toString() {
    return 'AllocationListResponse(allocations: $allocations)';
}


}

/// @nodoc
abstract mixin class _$AllocationListResponseCopyWith<$Res> implements $AllocationListResponseCopyWith<$Res> {
  factory _$AllocationListResponseCopyWith(_AllocationListResponse value, $Res Function(_AllocationListResponse) _then) = __$AllocationListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<Allocation> allocations
});




}
/// @nodoc
class __$AllocationListResponseCopyWithImpl<$Res>
    implements _$AllocationListResponseCopyWith<$Res> {
  __$AllocationListResponseCopyWithImpl(this._self, this._then);

  final _AllocationListResponse _self;
  final $Res Function(_AllocationListResponse) _then;

/// Create a copy of AllocationListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allocations = null,}) {
  return _then(_AllocationListResponse(
allocations: null == allocations ? _self._allocations : allocations // ignore: cast_nullable_to_non_nullable
as List<Allocation>,
  ));
}


}

// dart format on
