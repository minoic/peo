// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GalleryCard {

 String get id; String get itemName; String get itemDescription; String get imgSource; int get likes; bool get reviewPassed; String get userName;/// Formatted `yyyy-MM-dd HH:mm` by the server.
 String get createdAt;
/// Create a copy of GalleryCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GalleryCardCopyWith<GalleryCard> get copyWith => _$GalleryCardCopyWithImpl<GalleryCard>(this as GalleryCard, _$identity);

  /// Serializes this GalleryCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GalleryCard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GalleryCard&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.itemName, _this.itemName) || other.itemName == _this.itemName)&&(identical(other.itemDescription, _this.itemDescription) || other.itemDescription == _this.itemDescription)&&(identical(other.imgSource, _this.imgSource) || other.imgSource == _this.imgSource)&&(identical(other.likes, _this.likes) || other.likes == _this.likes)&&(identical(other.reviewPassed, _this.reviewPassed) || other.reviewPassed == _this.reviewPassed)&&(identical(other.userName, _this.userName) || other.userName == _this.userName)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GalleryCard;
  return Object.hash(runtimeType,_this.id,_this.itemName,_this.itemDescription,_this.imgSource,_this.likes,_this.reviewPassed,_this.userName,_this.createdAt);
}

@override
String toString() {
  final _this = this as GalleryCard;
  return 'GalleryCard(id: ${_this.id}, itemName: ${_this.itemName}, itemDescription: ${_this.itemDescription}, imgSource: ${_this.imgSource}, likes: ${_this.likes}, reviewPassed: ${_this.reviewPassed}, userName: ${_this.userName}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $GalleryCardCopyWith<$Res>  {
  factory $GalleryCardCopyWith(GalleryCard value, $Res Function(GalleryCard) _then) = _$GalleryCardCopyWithImpl;
@useResult
$Res call({
 String id, String itemName, String itemDescription, String imgSource, int likes, bool reviewPassed, String userName, String createdAt
});




}
/// @nodoc
class _$GalleryCardCopyWithImpl<$Res>
    implements $GalleryCardCopyWith<$Res> {
  _$GalleryCardCopyWithImpl(this._self, this._then);

  final GalleryCard _self;
  final $Res Function(GalleryCard) _then;

/// Create a copy of GalleryCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? itemName = null,Object? itemDescription = null,Object? imgSource = null,Object? likes = null,Object? reviewPassed = null,Object? userName = null,Object? createdAt = null,}) {
  return _then(GalleryCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,itemDescription: null == itemDescription ? _self.itemDescription : itemDescription // ignore: cast_nullable_to_non_nullable
as String,imgSource: null == imgSource ? _self.imgSource : imgSource // ignore: cast_nullable_to_non_nullable
as String,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,reviewPassed: null == reviewPassed ? _self.reviewPassed : reviewPassed // ignore: cast_nullable_to_non_nullable
as bool,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GalleryCard].
extension GalleryCardPatterns on GalleryCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GalleryCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GalleryCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GalleryCard value)  $default,){
final _that = this;
switch (_that) {
case _GalleryCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GalleryCard value)?  $default,){
final _that = this;
switch (_that) {
case _GalleryCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String itemName,  String itemDescription,  String imgSource,  int likes,  bool reviewPassed,  String userName,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GalleryCard() when $default != null:
return $default(_that.id,_that.itemName,_that.itemDescription,_that.imgSource,_that.likes,_that.reviewPassed,_that.userName,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String itemName,  String itemDescription,  String imgSource,  int likes,  bool reviewPassed,  String userName,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _GalleryCard():
return $default(_that.id,_that.itemName,_that.itemDescription,_that.imgSource,_that.likes,_that.reviewPassed,_that.userName,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String itemName,  String itemDescription,  String imgSource,  int likes,  bool reviewPassed,  String userName,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _GalleryCard() when $default != null:
return $default(_that.id,_that.itemName,_that.itemDescription,_that.imgSource,_that.likes,_that.reviewPassed,_that.userName,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GalleryCard implements GalleryCard {
  const _GalleryCard({this.id = '', this.itemName = '', this.itemDescription = '', this.imgSource = '', this.likes = 0, this.reviewPassed = false, this.userName = '', this.createdAt = ''});
  factory _GalleryCard.fromJson(Map<String, dynamic> json) => _$GalleryCardFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String itemName;
@override@JsonKey() final  String itemDescription;
@override@JsonKey() final  String imgSource;
@override@JsonKey() final  int likes;
@override@JsonKey() final  bool reviewPassed;
@override@JsonKey() final  String userName;
/// Formatted `yyyy-MM-dd HH:mm` by the server.
@override@JsonKey() final  String createdAt;

/// Create a copy of GalleryCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GalleryCardCopyWith<_GalleryCard> get copyWith => __$GalleryCardCopyWithImpl<_GalleryCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GalleryCardToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GalleryCard&&(identical(other.id, id) || other.id == id)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.itemDescription, itemDescription) || other.itemDescription == itemDescription)&&(identical(other.imgSource, imgSource) || other.imgSource == imgSource)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.reviewPassed, reviewPassed) || other.reviewPassed == reviewPassed)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,itemName,itemDescription,imgSource,likes,reviewPassed,userName,createdAt);
}

@override
String toString() {
    return 'GalleryCard(id: $id, itemName: $itemName, itemDescription: $itemDescription, imgSource: $imgSource, likes: $likes, reviewPassed: $reviewPassed, userName: $userName, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$GalleryCardCopyWith<$Res> implements $GalleryCardCopyWith<$Res> {
  factory _$GalleryCardCopyWith(_GalleryCard value, $Res Function(_GalleryCard) _then) = __$GalleryCardCopyWithImpl;
@override @useResult
$Res call({
 String id, String itemName, String itemDescription, String imgSource, int likes, bool reviewPassed, String userName, String createdAt
});




}
/// @nodoc
class __$GalleryCardCopyWithImpl<$Res>
    implements _$GalleryCardCopyWith<$Res> {
  __$GalleryCardCopyWithImpl(this._self, this._then);

  final _GalleryCard _self;
  final $Res Function(_GalleryCard) _then;

/// Create a copy of GalleryCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? itemName = null,Object? itemDescription = null,Object? imgSource = null,Object? likes = null,Object? reviewPassed = null,Object? userName = null,Object? createdAt = null,}) {
  return _then(_GalleryCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,itemDescription: null == itemDescription ? _self.itemDescription : itemDescription // ignore: cast_nullable_to_non_nullable
as String,imgSource: null == imgSource ? _self.imgSource : imgSource // ignore: cast_nullable_to_non_nullable
as String,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,reviewPassed: null == reviewPassed ? _self.reviewPassed : reviewPassed // ignore: cast_nullable_to_non_nullable
as bool,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GalleryListResponse {

 List<GalleryCard> get items;
/// Create a copy of GalleryListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GalleryListResponseCopyWith<GalleryListResponse> get copyWith => _$GalleryListResponseCopyWithImpl<GalleryListResponse>(this as GalleryListResponse, _$identity);

  /// Serializes this GalleryListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GalleryListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GalleryListResponse&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GalleryListResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as GalleryListResponse;
  return 'GalleryListResponse(items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $GalleryListResponseCopyWith<$Res>  {
  factory $GalleryListResponseCopyWith(GalleryListResponse value, $Res Function(GalleryListResponse) _then) = _$GalleryListResponseCopyWithImpl;
@useResult
$Res call({
 List<GalleryCard> items
});




}
/// @nodoc
class _$GalleryListResponseCopyWithImpl<$Res>
    implements $GalleryListResponseCopyWith<$Res> {
  _$GalleryListResponseCopyWithImpl(this._self, this._then);

  final GalleryListResponse _self;
  final $Res Function(GalleryListResponse) _then;

/// Create a copy of GalleryListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(GalleryListResponse(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<GalleryCard>,
  ));
}

}


/// Adds pattern-matching-related methods to [GalleryListResponse].
extension GalleryListResponsePatterns on GalleryListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GalleryListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GalleryListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GalleryListResponse value)  $default,){
final _that = this;
switch (_that) {
case _GalleryListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GalleryListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GalleryListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<GalleryCard> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GalleryListResponse() when $default != null:
return $default(_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<GalleryCard> items)  $default,) {final _that = this;
switch (_that) {
case _GalleryListResponse():
return $default(_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<GalleryCard> items)?  $default,) {final _that = this;
switch (_that) {
case _GalleryListResponse() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GalleryListResponse implements GalleryListResponse {
  const _GalleryListResponse({ List<GalleryCard> items = const <GalleryCard>[]}): _items = items;
  factory _GalleryListResponse.fromJson(Map<String, dynamic> json) => _$GalleryListResponseFromJson(json);

 final  List<GalleryCard> _items;
@override@JsonKey() List<GalleryCard> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of GalleryListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GalleryListResponseCopyWith<_GalleryListResponse> get copyWith => __$GalleryListResponseCopyWithImpl<_GalleryListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GalleryListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GalleryListResponse&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'GalleryListResponse(items: $items)';
}


}

/// @nodoc
abstract mixin class _$GalleryListResponseCopyWith<$Res> implements $GalleryListResponseCopyWith<$Res> {
  factory _$GalleryListResponseCopyWith(_GalleryListResponse value, $Res Function(_GalleryListResponse) _then) = __$GalleryListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<GalleryCard> items
});




}
/// @nodoc
class __$GalleryListResponseCopyWithImpl<$Res>
    implements _$GalleryListResponseCopyWith<$Res> {
  __$GalleryListResponseCopyWithImpl(this._self, this._then);

  final _GalleryListResponse _self;
  final $Res Function(_GalleryListResponse) _then;

/// Create a copy of GalleryListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_GalleryListResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<GalleryCard>,
  ));
}


}


/// @nodoc
mixin _$GallerySubmitRequest {

 String get itemName; String get itemDescription; String get imgSource;
/// Create a copy of GallerySubmitRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GallerySubmitRequestCopyWith<GallerySubmitRequest> get copyWith => _$GallerySubmitRequestCopyWithImpl<GallerySubmitRequest>(this as GallerySubmitRequest, _$identity);

  /// Serializes this GallerySubmitRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GallerySubmitRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GallerySubmitRequest&&(identical(other.itemName, _this.itemName) || other.itemName == _this.itemName)&&(identical(other.itemDescription, _this.itemDescription) || other.itemDescription == _this.itemDescription)&&(identical(other.imgSource, _this.imgSource) || other.imgSource == _this.imgSource));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GallerySubmitRequest;
  return Object.hash(runtimeType,_this.itemName,_this.itemDescription,_this.imgSource);
}

@override
String toString() {
  final _this = this as GallerySubmitRequest;
  return 'GallerySubmitRequest(itemName: ${_this.itemName}, itemDescription: ${_this.itemDescription}, imgSource: ${_this.imgSource})';
}


}

/// @nodoc
abstract mixin class $GallerySubmitRequestCopyWith<$Res>  {
  factory $GallerySubmitRequestCopyWith(GallerySubmitRequest value, $Res Function(GallerySubmitRequest) _then) = _$GallerySubmitRequestCopyWithImpl;
@useResult
$Res call({
 String itemName, String itemDescription, String imgSource
});




}
/// @nodoc
class _$GallerySubmitRequestCopyWithImpl<$Res>
    implements $GallerySubmitRequestCopyWith<$Res> {
  _$GallerySubmitRequestCopyWithImpl(this._self, this._then);

  final GallerySubmitRequest _self;
  final $Res Function(GallerySubmitRequest) _then;

/// Create a copy of GallerySubmitRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemName = null,Object? itemDescription = null,Object? imgSource = null,}) {
  return _then(GallerySubmitRequest(
itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,itemDescription: null == itemDescription ? _self.itemDescription : itemDescription // ignore: cast_nullable_to_non_nullable
as String,imgSource: null == imgSource ? _self.imgSource : imgSource // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GallerySubmitRequest].
extension GallerySubmitRequestPatterns on GallerySubmitRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GallerySubmitRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GallerySubmitRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GallerySubmitRequest value)  $default,){
final _that = this;
switch (_that) {
case _GallerySubmitRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GallerySubmitRequest value)?  $default,){
final _that = this;
switch (_that) {
case _GallerySubmitRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemName,  String itemDescription,  String imgSource)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GallerySubmitRequest() when $default != null:
return $default(_that.itemName,_that.itemDescription,_that.imgSource);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemName,  String itemDescription,  String imgSource)  $default,) {final _that = this;
switch (_that) {
case _GallerySubmitRequest():
return $default(_that.itemName,_that.itemDescription,_that.imgSource);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemName,  String itemDescription,  String imgSource)?  $default,) {final _that = this;
switch (_that) {
case _GallerySubmitRequest() when $default != null:
return $default(_that.itemName,_that.itemDescription,_that.imgSource);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GallerySubmitRequest implements GallerySubmitRequest {
  const _GallerySubmitRequest({required this.itemName, this.itemDescription = '', required this.imgSource});
  factory _GallerySubmitRequest.fromJson(Map<String, dynamic> json) => _$GallerySubmitRequestFromJson(json);

@override final  String itemName;
@override@JsonKey() final  String itemDescription;
@override final  String imgSource;

/// Create a copy of GallerySubmitRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GallerySubmitRequestCopyWith<_GallerySubmitRequest> get copyWith => __$GallerySubmitRequestCopyWithImpl<_GallerySubmitRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GallerySubmitRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GallerySubmitRequest&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.itemDescription, itemDescription) || other.itemDescription == itemDescription)&&(identical(other.imgSource, imgSource) || other.imgSource == imgSource));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,itemName,itemDescription,imgSource);
}

@override
String toString() {
    return 'GallerySubmitRequest(itemName: $itemName, itemDescription: $itemDescription, imgSource: $imgSource)';
}


}

/// @nodoc
abstract mixin class _$GallerySubmitRequestCopyWith<$Res> implements $GallerySubmitRequestCopyWith<$Res> {
  factory _$GallerySubmitRequestCopyWith(_GallerySubmitRequest value, $Res Function(_GallerySubmitRequest) _then) = __$GallerySubmitRequestCopyWithImpl;
@override @useResult
$Res call({
 String itemName, String itemDescription, String imgSource
});




}
/// @nodoc
class __$GallerySubmitRequestCopyWithImpl<$Res>
    implements _$GallerySubmitRequestCopyWith<$Res> {
  __$GallerySubmitRequestCopyWithImpl(this._self, this._then);

  final _GallerySubmitRequest _self;
  final $Res Function(_GallerySubmitRequest) _then;

/// Create a copy of GallerySubmitRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemName = null,Object? itemDescription = null,Object? imgSource = null,}) {
  return _then(_GallerySubmitRequest(
itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,itemDescription: null == itemDescription ? _self.itemDescription : itemDescription // ignore: cast_nullable_to_non_nullable
as String,imgSource: null == imgSource ? _self.imgSource : imgSource // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GalleryItemResponse {

 GalleryCard get item;
/// Create a copy of GalleryItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GalleryItemResponseCopyWith<GalleryItemResponse> get copyWith => _$GalleryItemResponseCopyWithImpl<GalleryItemResponse>(this as GalleryItemResponse, _$identity);

  /// Serializes this GalleryItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GalleryItemResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GalleryItemResponse&&(identical(other.item, _this.item) || other.item == _this.item));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GalleryItemResponse;
  return Object.hash(runtimeType,_this.item);
}

@override
String toString() {
  final _this = this as GalleryItemResponse;
  return 'GalleryItemResponse(item: ${_this.item})';
}


}

/// @nodoc
abstract mixin class $GalleryItemResponseCopyWith<$Res>  {
  factory $GalleryItemResponseCopyWith(GalleryItemResponse value, $Res Function(GalleryItemResponse) _then) = _$GalleryItemResponseCopyWithImpl;
@useResult
$Res call({
 GalleryCard item
});


$GalleryCardCopyWith<$Res> get item;

}
/// @nodoc
class _$GalleryItemResponseCopyWithImpl<$Res>
    implements $GalleryItemResponseCopyWith<$Res> {
  _$GalleryItemResponseCopyWithImpl(this._self, this._then);

  final GalleryItemResponse _self;
  final $Res Function(GalleryItemResponse) _then;

/// Create a copy of GalleryItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? item = null,}) {
  return _then(GalleryItemResponse(
item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as GalleryCard,
  ));
}
/// Create a copy of GalleryItemResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GalleryCardCopyWith<$Res> get item {
  
  return $GalleryCardCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}


/// Adds pattern-matching-related methods to [GalleryItemResponse].
extension GalleryItemResponsePatterns on GalleryItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GalleryItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GalleryItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GalleryItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _GalleryItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GalleryItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GalleryItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GalleryCard item)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GalleryItemResponse() when $default != null:
return $default(_that.item);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GalleryCard item)  $default,) {final _that = this;
switch (_that) {
case _GalleryItemResponse():
return $default(_that.item);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GalleryCard item)?  $default,) {final _that = this;
switch (_that) {
case _GalleryItemResponse() when $default != null:
return $default(_that.item);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GalleryItemResponse implements GalleryItemResponse {
  const _GalleryItemResponse({required this.item});
  factory _GalleryItemResponse.fromJson(Map<String, dynamic> json) => _$GalleryItemResponseFromJson(json);

@override final  GalleryCard item;

/// Create a copy of GalleryItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GalleryItemResponseCopyWith<_GalleryItemResponse> get copyWith => __$GalleryItemResponseCopyWithImpl<_GalleryItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GalleryItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GalleryItemResponse&&(identical(other.item, item) || other.item == item));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,item);
}

@override
String toString() {
    return 'GalleryItemResponse(item: $item)';
}


}

/// @nodoc
abstract mixin class _$GalleryItemResponseCopyWith<$Res> implements $GalleryItemResponseCopyWith<$Res> {
  factory _$GalleryItemResponseCopyWith(_GalleryItemResponse value, $Res Function(_GalleryItemResponse) _then) = __$GalleryItemResponseCopyWithImpl;
@override @useResult
$Res call({
 GalleryCard item
});


@override $GalleryCardCopyWith<$Res> get item;

}
/// @nodoc
class __$GalleryItemResponseCopyWithImpl<$Res>
    implements _$GalleryItemResponseCopyWith<$Res> {
  __$GalleryItemResponseCopyWithImpl(this._self, this._then);

  final _GalleryItemResponse _self;
  final $Res Function(_GalleryItemResponse) _then;

/// Create a copy of GalleryItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? item = null,}) {
  return _then(_GalleryItemResponse(
item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as GalleryCard,
  ));
}

/// Create a copy of GalleryItemResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GalleryCardCopyWith<$Res> get item {
  
  return $GalleryCardCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}


/// @nodoc
mixin _$LikeResponse {

 int get likes;
/// Create a copy of LikeResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LikeResponseCopyWith<LikeResponse> get copyWith => _$LikeResponseCopyWithImpl<LikeResponse>(this as LikeResponse, _$identity);

  /// Serializes this LikeResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LikeResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LikeResponse&&(identical(other.likes, _this.likes) || other.likes == _this.likes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LikeResponse;
  return Object.hash(runtimeType,_this.likes);
}

@override
String toString() {
  final _this = this as LikeResponse;
  return 'LikeResponse(likes: ${_this.likes})';
}


}

/// @nodoc
abstract mixin class $LikeResponseCopyWith<$Res>  {
  factory $LikeResponseCopyWith(LikeResponse value, $Res Function(LikeResponse) _then) = _$LikeResponseCopyWithImpl;
@useResult
$Res call({
 int likes
});




}
/// @nodoc
class _$LikeResponseCopyWithImpl<$Res>
    implements $LikeResponseCopyWith<$Res> {
  _$LikeResponseCopyWithImpl(this._self, this._then);

  final LikeResponse _self;
  final $Res Function(LikeResponse) _then;

/// Create a copy of LikeResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? likes = null,}) {
  return _then(LikeResponse(
likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LikeResponse].
extension LikeResponsePatterns on LikeResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LikeResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LikeResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LikeResponse value)  $default,){
final _that = this;
switch (_that) {
case _LikeResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LikeResponse value)?  $default,){
final _that = this;
switch (_that) {
case _LikeResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int likes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LikeResponse() when $default != null:
return $default(_that.likes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int likes)  $default,) {final _that = this;
switch (_that) {
case _LikeResponse():
return $default(_that.likes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int likes)?  $default,) {final _that = this;
switch (_that) {
case _LikeResponse() when $default != null:
return $default(_that.likes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LikeResponse implements LikeResponse {
  const _LikeResponse({this.likes = 0});
  factory _LikeResponse.fromJson(Map<String, dynamic> json) => _$LikeResponseFromJson(json);

@override@JsonKey() final  int likes;

/// Create a copy of LikeResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LikeResponseCopyWith<_LikeResponse> get copyWith => __$LikeResponseCopyWithImpl<_LikeResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LikeResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LikeResponse&&(identical(other.likes, likes) || other.likes == likes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,likes);
}

@override
String toString() {
    return 'LikeResponse(likes: $likes)';
}


}

/// @nodoc
abstract mixin class _$LikeResponseCopyWith<$Res> implements $LikeResponseCopyWith<$Res> {
  factory _$LikeResponseCopyWith(_LikeResponse value, $Res Function(_LikeResponse) _then) = __$LikeResponseCopyWithImpl;
@override @useResult
$Res call({
 int likes
});




}
/// @nodoc
class __$LikeResponseCopyWithImpl<$Res>
    implements _$LikeResponseCopyWith<$Res> {
  __$LikeResponseCopyWithImpl(this._self, this._then);

  final _LikeResponse _self;
  final $Res Function(_LikeResponse) _then;

/// Create a copy of LikeResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? likes = null,}) {
  return _then(_LikeResponse(
likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MessageItem {

 String get id; String get senderName; String get text; String get timeText; bool get haveRead; String get createdAt;
/// Create a copy of MessageItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageItemCopyWith<MessageItem> get copyWith => _$MessageItemCopyWithImpl<MessageItem>(this as MessageItem, _$identity);

  /// Serializes this MessageItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MessageItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.senderName, _this.senderName) || other.senderName == _this.senderName)&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.timeText, _this.timeText) || other.timeText == _this.timeText)&&(identical(other.haveRead, _this.haveRead) || other.haveRead == _this.haveRead)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MessageItem;
  return Object.hash(runtimeType,_this.id,_this.senderName,_this.text,_this.timeText,_this.haveRead,_this.createdAt);
}

@override
String toString() {
  final _this = this as MessageItem;
  return 'MessageItem(id: ${_this.id}, senderName: ${_this.senderName}, text: ${_this.text}, timeText: ${_this.timeText}, haveRead: ${_this.haveRead}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $MessageItemCopyWith<$Res>  {
  factory $MessageItemCopyWith(MessageItem value, $Res Function(MessageItem) _then) = _$MessageItemCopyWithImpl;
@useResult
$Res call({
 String id, String senderName, String text, String timeText, bool haveRead, String createdAt
});




}
/// @nodoc
class _$MessageItemCopyWithImpl<$Res>
    implements $MessageItemCopyWith<$Res> {
  _$MessageItemCopyWithImpl(this._self, this._then);

  final MessageItem _self;
  final $Res Function(MessageItem) _then;

/// Create a copy of MessageItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? senderName = null,Object? text = null,Object? timeText = null,Object? haveRead = null,Object? createdAt = null,}) {
  return _then(MessageItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,timeText: null == timeText ? _self.timeText : timeText // ignore: cast_nullable_to_non_nullable
as String,haveRead: null == haveRead ? _self.haveRead : haveRead // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageItem].
extension MessageItemPatterns on MessageItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageItem value)  $default,){
final _that = this;
switch (_that) {
case _MessageItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageItem value)?  $default,){
final _that = this;
switch (_that) {
case _MessageItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String senderName,  String text,  String timeText,  bool haveRead,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageItem() when $default != null:
return $default(_that.id,_that.senderName,_that.text,_that.timeText,_that.haveRead,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String senderName,  String text,  String timeText,  bool haveRead,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _MessageItem():
return $default(_that.id,_that.senderName,_that.text,_that.timeText,_that.haveRead,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String senderName,  String text,  String timeText,  bool haveRead,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MessageItem() when $default != null:
return $default(_that.id,_that.senderName,_that.text,_that.timeText,_that.haveRead,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageItem implements MessageItem {
  const _MessageItem({this.id = '', this.senderName = '', this.text = '', this.timeText = '', this.haveRead = false, this.createdAt = ''});
  factory _MessageItem.fromJson(Map<String, dynamic> json) => _$MessageItemFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String senderName;
@override@JsonKey() final  String text;
@override@JsonKey() final  String timeText;
@override@JsonKey() final  bool haveRead;
@override@JsonKey() final  String createdAt;

/// Create a copy of MessageItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageItemCopyWith<_MessageItem> get copyWith => __$MessageItemCopyWithImpl<_MessageItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageItem&&(identical(other.id, id) || other.id == id)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.text, text) || other.text == text)&&(identical(other.timeText, timeText) || other.timeText == timeText)&&(identical(other.haveRead, haveRead) || other.haveRead == haveRead)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,senderName,text,timeText,haveRead,createdAt);
}

@override
String toString() {
    return 'MessageItem(id: $id, senderName: $senderName, text: $text, timeText: $timeText, haveRead: $haveRead, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MessageItemCopyWith<$Res> implements $MessageItemCopyWith<$Res> {
  factory _$MessageItemCopyWith(_MessageItem value, $Res Function(_MessageItem) _then) = __$MessageItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String senderName, String text, String timeText, bool haveRead, String createdAt
});




}
/// @nodoc
class __$MessageItemCopyWithImpl<$Res>
    implements _$MessageItemCopyWith<$Res> {
  __$MessageItemCopyWithImpl(this._self, this._then);

  final _MessageItem _self;
  final $Res Function(_MessageItem) _then;

/// Create a copy of MessageItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? senderName = null,Object? text = null,Object? timeText = null,Object? haveRead = null,Object? createdAt = null,}) {
  return _then(_MessageItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,timeText: null == timeText ? _self.timeText : timeText // ignore: cast_nullable_to_non_nullable
as String,haveRead: null == haveRead ? _self.haveRead : haveRead // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MessageListResponse {

 List<MessageItem> get messages;
/// Create a copy of MessageListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageListResponseCopyWith<MessageListResponse> get copyWith => _$MessageListResponseCopyWithImpl<MessageListResponse>(this as MessageListResponse, _$identity);

  /// Serializes this MessageListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MessageListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageListResponse&&const DeepCollectionEquality().equals(other.messages, _this.messages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MessageListResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.messages));
}

@override
String toString() {
  final _this = this as MessageListResponse;
  return 'MessageListResponse(messages: ${_this.messages})';
}


}

/// @nodoc
abstract mixin class $MessageListResponseCopyWith<$Res>  {
  factory $MessageListResponseCopyWith(MessageListResponse value, $Res Function(MessageListResponse) _then) = _$MessageListResponseCopyWithImpl;
@useResult
$Res call({
 List<MessageItem> messages
});




}
/// @nodoc
class _$MessageListResponseCopyWithImpl<$Res>
    implements $MessageListResponseCopyWith<$Res> {
  _$MessageListResponseCopyWithImpl(this._self, this._then);

  final MessageListResponse _self;
  final $Res Function(MessageListResponse) _then;

/// Create a copy of MessageListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messages = null,}) {
  return _then(MessageListResponse(
messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<MessageItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageListResponse].
extension MessageListResponsePatterns on MessageListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageListResponse value)  $default,){
final _that = this;
switch (_that) {
case _MessageListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MessageListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MessageItem> messages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageListResponse() when $default != null:
return $default(_that.messages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MessageItem> messages)  $default,) {final _that = this;
switch (_that) {
case _MessageListResponse():
return $default(_that.messages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MessageItem> messages)?  $default,) {final _that = this;
switch (_that) {
case _MessageListResponse() when $default != null:
return $default(_that.messages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageListResponse implements MessageListResponse {
  const _MessageListResponse({ List<MessageItem> messages = const <MessageItem>[]}): _messages = messages;
  factory _MessageListResponse.fromJson(Map<String, dynamic> json) => _$MessageListResponseFromJson(json);

 final  List<MessageItem> _messages;
@override@JsonKey() List<MessageItem> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}


/// Create a copy of MessageListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageListResponseCopyWith<_MessageListResponse> get copyWith => __$MessageListResponseCopyWithImpl<_MessageListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageListResponse&&const DeepCollectionEquality().equals(other.messages, _messages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages));
}

@override
String toString() {
    return 'MessageListResponse(messages: $messages)';
}


}

/// @nodoc
abstract mixin class _$MessageListResponseCopyWith<$Res> implements $MessageListResponseCopyWith<$Res> {
  factory _$MessageListResponseCopyWith(_MessageListResponse value, $Res Function(_MessageListResponse) _then) = __$MessageListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<MessageItem> messages
});




}
/// @nodoc
class __$MessageListResponseCopyWithImpl<$Res>
    implements _$MessageListResponseCopyWith<$Res> {
  __$MessageListResponseCopyWithImpl(this._self, this._then);

  final _MessageListResponse _self;
  final $Res Function(_MessageListResponse) _then;

/// Create a copy of MessageListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messages = null,}) {
  return _then(_MessageListResponse(
messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<MessageItem>,
  ));
}


}


/// @nodoc
mixin _$UnreadResponse {

 int get unread;
/// Create a copy of UnreadResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnreadResponseCopyWith<UnreadResponse> get copyWith => _$UnreadResponseCopyWithImpl<UnreadResponse>(this as UnreadResponse, _$identity);

  /// Serializes this UnreadResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UnreadResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnreadResponse&&(identical(other.unread, _this.unread) || other.unread == _this.unread));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UnreadResponse;
  return Object.hash(runtimeType,_this.unread);
}

@override
String toString() {
  final _this = this as UnreadResponse;
  return 'UnreadResponse(unread: ${_this.unread})';
}


}

/// @nodoc
abstract mixin class $UnreadResponseCopyWith<$Res>  {
  factory $UnreadResponseCopyWith(UnreadResponse value, $Res Function(UnreadResponse) _then) = _$UnreadResponseCopyWithImpl;
@useResult
$Res call({
 int unread
});




}
/// @nodoc
class _$UnreadResponseCopyWithImpl<$Res>
    implements $UnreadResponseCopyWith<$Res> {
  _$UnreadResponseCopyWithImpl(this._self, this._then);

  final UnreadResponse _self;
  final $Res Function(UnreadResponse) _then;

/// Create a copy of UnreadResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? unread = null,}) {
  return _then(UnreadResponse(
unread: null == unread ? _self.unread : unread // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UnreadResponse].
extension UnreadResponsePatterns on UnreadResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnreadResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnreadResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnreadResponse value)  $default,){
final _that = this;
switch (_that) {
case _UnreadResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnreadResponse value)?  $default,){
final _that = this;
switch (_that) {
case _UnreadResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int unread)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnreadResponse() when $default != null:
return $default(_that.unread);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int unread)  $default,) {final _that = this;
switch (_that) {
case _UnreadResponse():
return $default(_that.unread);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int unread)?  $default,) {final _that = this;
switch (_that) {
case _UnreadResponse() when $default != null:
return $default(_that.unread);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UnreadResponse implements UnreadResponse {
  const _UnreadResponse({this.unread = 0});
  factory _UnreadResponse.fromJson(Map<String, dynamic> json) => _$UnreadResponseFromJson(json);

@override@JsonKey() final  int unread;

/// Create a copy of UnreadResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnreadResponseCopyWith<_UnreadResponse> get copyWith => __$UnreadResponseCopyWithImpl<_UnreadResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnreadResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnreadResponse&&(identical(other.unread, unread) || other.unread == unread));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,unread);
}

@override
String toString() {
    return 'UnreadResponse(unread: $unread)';
}


}

/// @nodoc
abstract mixin class _$UnreadResponseCopyWith<$Res> implements $UnreadResponseCopyWith<$Res> {
  factory _$UnreadResponseCopyWith(_UnreadResponse value, $Res Function(_UnreadResponse) _then) = __$UnreadResponseCopyWithImpl;
@override @useResult
$Res call({
 int unread
});




}
/// @nodoc
class __$UnreadResponseCopyWithImpl<$Res>
    implements _$UnreadResponseCopyWith<$Res> {
  __$UnreadResponseCopyWithImpl(this._self, this._then);

  final _UnreadResponse _self;
  final $Res Function(_UnreadResponse) _then;

/// Create a copy of UnreadResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? unread = null,}) {
  return _then(_UnreadResponse(
unread: null == unread ? _self.unread : unread // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WorkOrderItem {

 String get id; String get userId; String get userName; String get orderTitle; String get orderText; String get createdAt; bool get closed;
/// Create a copy of WorkOrderItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkOrderItemCopyWith<WorkOrderItem> get copyWith => _$WorkOrderItemCopyWithImpl<WorkOrderItem>(this as WorkOrderItem, _$identity);

  /// Serializes this WorkOrderItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkOrderItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkOrderItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.userName, _this.userName) || other.userName == _this.userName)&&(identical(other.orderTitle, _this.orderTitle) || other.orderTitle == _this.orderTitle)&&(identical(other.orderText, _this.orderText) || other.orderText == _this.orderText)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.closed, _this.closed) || other.closed == _this.closed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkOrderItem;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.userName,_this.orderTitle,_this.orderText,_this.createdAt,_this.closed);
}

@override
String toString() {
  final _this = this as WorkOrderItem;
  return 'WorkOrderItem(id: ${_this.id}, userId: ${_this.userId}, userName: ${_this.userName}, orderTitle: ${_this.orderTitle}, orderText: ${_this.orderText}, createdAt: ${_this.createdAt}, closed: ${_this.closed})';
}


}

/// @nodoc
abstract mixin class $WorkOrderItemCopyWith<$Res>  {
  factory $WorkOrderItemCopyWith(WorkOrderItem value, $Res Function(WorkOrderItem) _then) = _$WorkOrderItemCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String userName, String orderTitle, String orderText, String createdAt, bool closed
});




}
/// @nodoc
class _$WorkOrderItemCopyWithImpl<$Res>
    implements $WorkOrderItemCopyWith<$Res> {
  _$WorkOrderItemCopyWithImpl(this._self, this._then);

  final WorkOrderItem _self;
  final $Res Function(WorkOrderItem) _then;

/// Create a copy of WorkOrderItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? userName = null,Object? orderTitle = null,Object? orderText = null,Object? createdAt = null,Object? closed = null,}) {
  return _then(WorkOrderItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,orderTitle: null == orderTitle ? _self.orderTitle : orderTitle // ignore: cast_nullable_to_non_nullable
as String,orderText: null == orderText ? _self.orderText : orderText // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,closed: null == closed ? _self.closed : closed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkOrderItem].
extension WorkOrderItemPatterns on WorkOrderItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkOrderItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkOrderItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkOrderItem value)  $default,){
final _that = this;
switch (_that) {
case _WorkOrderItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkOrderItem value)?  $default,){
final _that = this;
switch (_that) {
case _WorkOrderItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String userName,  String orderTitle,  String orderText,  String createdAt,  bool closed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkOrderItem() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.orderTitle,_that.orderText,_that.createdAt,_that.closed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String userName,  String orderTitle,  String orderText,  String createdAt,  bool closed)  $default,) {final _that = this;
switch (_that) {
case _WorkOrderItem():
return $default(_that.id,_that.userId,_that.userName,_that.orderTitle,_that.orderText,_that.createdAt,_that.closed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String userName,  String orderTitle,  String orderText,  String createdAt,  bool closed)?  $default,) {final _that = this;
switch (_that) {
case _WorkOrderItem() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.orderTitle,_that.orderText,_that.createdAt,_that.closed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkOrderItem implements WorkOrderItem {
  const _WorkOrderItem({this.id = '', this.userId = '', this.userName = '', this.orderTitle = '', this.orderText = '', this.createdAt = '', this.closed = false});
  factory _WorkOrderItem.fromJson(Map<String, dynamic> json) => _$WorkOrderItemFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String userId;
@override@JsonKey() final  String userName;
@override@JsonKey() final  String orderTitle;
@override@JsonKey() final  String orderText;
@override@JsonKey() final  String createdAt;
@override@JsonKey() final  bool closed;

/// Create a copy of WorkOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkOrderItemCopyWith<_WorkOrderItem> get copyWith => __$WorkOrderItemCopyWithImpl<_WorkOrderItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkOrderItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkOrderItem&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.orderTitle, orderTitle) || other.orderTitle == orderTitle)&&(identical(other.orderText, orderText) || other.orderText == orderText)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.closed, closed) || other.closed == closed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,userName,orderTitle,orderText,createdAt,closed);
}

@override
String toString() {
    return 'WorkOrderItem(id: $id, userId: $userId, userName: $userName, orderTitle: $orderTitle, orderText: $orderText, createdAt: $createdAt, closed: $closed)';
}


}

/// @nodoc
abstract mixin class _$WorkOrderItemCopyWith<$Res> implements $WorkOrderItemCopyWith<$Res> {
  factory _$WorkOrderItemCopyWith(_WorkOrderItem value, $Res Function(_WorkOrderItem) _then) = __$WorkOrderItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String userName, String orderTitle, String orderText, String createdAt, bool closed
});




}
/// @nodoc
class __$WorkOrderItemCopyWithImpl<$Res>
    implements _$WorkOrderItemCopyWith<$Res> {
  __$WorkOrderItemCopyWithImpl(this._self, this._then);

  final _WorkOrderItem _self;
  final $Res Function(_WorkOrderItem) _then;

/// Create a copy of WorkOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? userName = null,Object? orderTitle = null,Object? orderText = null,Object? createdAt = null,Object? closed = null,}) {
  return _then(_WorkOrderItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,orderTitle: null == orderTitle ? _self.orderTitle : orderTitle // ignore: cast_nullable_to_non_nullable
as String,orderText: null == orderText ? _self.orderText : orderText // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,closed: null == closed ? _self.closed : closed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$WorkOrderListResponse {

 List<WorkOrderItem> get orders;
/// Create a copy of WorkOrderListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkOrderListResponseCopyWith<WorkOrderListResponse> get copyWith => _$WorkOrderListResponseCopyWithImpl<WorkOrderListResponse>(this as WorkOrderListResponse, _$identity);

  /// Serializes this WorkOrderListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkOrderListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkOrderListResponse&&const DeepCollectionEquality().equals(other.orders, _this.orders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkOrderListResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.orders));
}

@override
String toString() {
  final _this = this as WorkOrderListResponse;
  return 'WorkOrderListResponse(orders: ${_this.orders})';
}


}

/// @nodoc
abstract mixin class $WorkOrderListResponseCopyWith<$Res>  {
  factory $WorkOrderListResponseCopyWith(WorkOrderListResponse value, $Res Function(WorkOrderListResponse) _then) = _$WorkOrderListResponseCopyWithImpl;
@useResult
$Res call({
 List<WorkOrderItem> orders
});




}
/// @nodoc
class _$WorkOrderListResponseCopyWithImpl<$Res>
    implements $WorkOrderListResponseCopyWith<$Res> {
  _$WorkOrderListResponseCopyWithImpl(this._self, this._then);

  final WorkOrderListResponse _self;
  final $Res Function(WorkOrderListResponse) _then;

/// Create a copy of WorkOrderListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orders = null,}) {
  return _then(WorkOrderListResponse(
orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as List<WorkOrderItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkOrderListResponse].
extension WorkOrderListResponsePatterns on WorkOrderListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkOrderListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkOrderListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkOrderListResponse value)  $default,){
final _that = this;
switch (_that) {
case _WorkOrderListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkOrderListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WorkOrderListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<WorkOrderItem> orders)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkOrderListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<WorkOrderItem> orders)  $default,) {final _that = this;
switch (_that) {
case _WorkOrderListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<WorkOrderItem> orders)?  $default,) {final _that = this;
switch (_that) {
case _WorkOrderListResponse() when $default != null:
return $default(_that.orders);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkOrderListResponse implements WorkOrderListResponse {
  const _WorkOrderListResponse({ List<WorkOrderItem> orders = const <WorkOrderItem>[]}): _orders = orders;
  factory _WorkOrderListResponse.fromJson(Map<String, dynamic> json) => _$WorkOrderListResponseFromJson(json);

 final  List<WorkOrderItem> _orders;
@override@JsonKey() List<WorkOrderItem> get orders {
  if (_orders is EqualUnmodifiableListView) return _orders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orders);
}


/// Create a copy of WorkOrderListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkOrderListResponseCopyWith<_WorkOrderListResponse> get copyWith => __$WorkOrderListResponseCopyWithImpl<_WorkOrderListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkOrderListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkOrderListResponse&&const DeepCollectionEquality().equals(other.orders, _orders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_orders));
}

@override
String toString() {
    return 'WorkOrderListResponse(orders: $orders)';
}


}

/// @nodoc
abstract mixin class _$WorkOrderListResponseCopyWith<$Res> implements $WorkOrderListResponseCopyWith<$Res> {
  factory _$WorkOrderListResponseCopyWith(_WorkOrderListResponse value, $Res Function(_WorkOrderListResponse) _then) = __$WorkOrderListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<WorkOrderItem> orders
});




}
/// @nodoc
class __$WorkOrderListResponseCopyWithImpl<$Res>
    implements _$WorkOrderListResponseCopyWith<$Res> {
  __$WorkOrderListResponseCopyWithImpl(this._self, this._then);

  final _WorkOrderListResponse _self;
  final $Res Function(_WorkOrderListResponse) _then;

/// Create a copy of WorkOrderListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orders = null,}) {
  return _then(_WorkOrderListResponse(
orders: null == orders ? _self._orders : orders // ignore: cast_nullable_to_non_nullable
as List<WorkOrderItem>,
  ));
}


}


/// @nodoc
mixin _$CreateWorkOrderRequest {

 String get title; String get text;
/// Create a copy of CreateWorkOrderRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateWorkOrderRequestCopyWith<CreateWorkOrderRequest> get copyWith => _$CreateWorkOrderRequestCopyWithImpl<CreateWorkOrderRequest>(this as CreateWorkOrderRequest, _$identity);

  /// Serializes this CreateWorkOrderRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateWorkOrderRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateWorkOrderRequest&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.text, _this.text) || other.text == _this.text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateWorkOrderRequest;
  return Object.hash(runtimeType,_this.title,_this.text);
}

@override
String toString() {
  final _this = this as CreateWorkOrderRequest;
  return 'CreateWorkOrderRequest(title: ${_this.title}, text: ${_this.text})';
}


}

/// @nodoc
abstract mixin class $CreateWorkOrderRequestCopyWith<$Res>  {
  factory $CreateWorkOrderRequestCopyWith(CreateWorkOrderRequest value, $Res Function(CreateWorkOrderRequest) _then) = _$CreateWorkOrderRequestCopyWithImpl;
@useResult
$Res call({
 String title, String text
});




}
/// @nodoc
class _$CreateWorkOrderRequestCopyWithImpl<$Res>
    implements $CreateWorkOrderRequestCopyWith<$Res> {
  _$CreateWorkOrderRequestCopyWithImpl(this._self, this._then);

  final CreateWorkOrderRequest _self;
  final $Res Function(CreateWorkOrderRequest) _then;

/// Create a copy of CreateWorkOrderRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? text = null,}) {
  return _then(CreateWorkOrderRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateWorkOrderRequest].
extension CreateWorkOrderRequestPatterns on CreateWorkOrderRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateWorkOrderRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateWorkOrderRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateWorkOrderRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateWorkOrderRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateWorkOrderRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateWorkOrderRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateWorkOrderRequest() when $default != null:
return $default(_that.title,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String text)  $default,) {final _that = this;
switch (_that) {
case _CreateWorkOrderRequest():
return $default(_that.title,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String text)?  $default,) {final _that = this;
switch (_that) {
case _CreateWorkOrderRequest() when $default != null:
return $default(_that.title,_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateWorkOrderRequest implements CreateWorkOrderRequest {
  const _CreateWorkOrderRequest({required this.title, required this.text});
  factory _CreateWorkOrderRequest.fromJson(Map<String, dynamic> json) => _$CreateWorkOrderRequestFromJson(json);

@override final  String title;
@override final  String text;

/// Create a copy of CreateWorkOrderRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateWorkOrderRequestCopyWith<_CreateWorkOrderRequest> get copyWith => __$CreateWorkOrderRequestCopyWithImpl<_CreateWorkOrderRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateWorkOrderRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateWorkOrderRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,text);
}

@override
String toString() {
    return 'CreateWorkOrderRequest(title: $title, text: $text)';
}


}

/// @nodoc
abstract mixin class _$CreateWorkOrderRequestCopyWith<$Res> implements $CreateWorkOrderRequestCopyWith<$Res> {
  factory _$CreateWorkOrderRequestCopyWith(_CreateWorkOrderRequest value, $Res Function(_CreateWorkOrderRequest) _then) = __$CreateWorkOrderRequestCopyWithImpl;
@override @useResult
$Res call({
 String title, String text
});




}
/// @nodoc
class __$CreateWorkOrderRequestCopyWithImpl<$Res>
    implements _$CreateWorkOrderRequestCopyWith<$Res> {
  __$CreateWorkOrderRequestCopyWithImpl(this._self, this._then);

  final _CreateWorkOrderRequest _self;
  final $Res Function(_CreateWorkOrderRequest) _then;

/// Create a copy of CreateWorkOrderRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? text = null,}) {
  return _then(_CreateWorkOrderRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$WorkOrderResponse {

 WorkOrderItem get order;
/// Create a copy of WorkOrderResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkOrderResponseCopyWith<WorkOrderResponse> get copyWith => _$WorkOrderResponseCopyWithImpl<WorkOrderResponse>(this as WorkOrderResponse, _$identity);

  /// Serializes this WorkOrderResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkOrderResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkOrderResponse&&(identical(other.order, _this.order) || other.order == _this.order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkOrderResponse;
  return Object.hash(runtimeType,_this.order);
}

@override
String toString() {
  final _this = this as WorkOrderResponse;
  return 'WorkOrderResponse(order: ${_this.order})';
}


}

/// @nodoc
abstract mixin class $WorkOrderResponseCopyWith<$Res>  {
  factory $WorkOrderResponseCopyWith(WorkOrderResponse value, $Res Function(WorkOrderResponse) _then) = _$WorkOrderResponseCopyWithImpl;
@useResult
$Res call({
 WorkOrderItem order
});


$WorkOrderItemCopyWith<$Res> get order;

}
/// @nodoc
class _$WorkOrderResponseCopyWithImpl<$Res>
    implements $WorkOrderResponseCopyWith<$Res> {
  _$WorkOrderResponseCopyWithImpl(this._self, this._then);

  final WorkOrderResponse _self;
  final $Res Function(WorkOrderResponse) _then;

/// Create a copy of WorkOrderResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? order = null,}) {
  return _then(WorkOrderResponse(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as WorkOrderItem,
  ));
}
/// Create a copy of WorkOrderResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkOrderItemCopyWith<$Res> get order {
  
  return $WorkOrderItemCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}


/// Adds pattern-matching-related methods to [WorkOrderResponse].
extension WorkOrderResponsePatterns on WorkOrderResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkOrderResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkOrderResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkOrderResponse value)  $default,){
final _that = this;
switch (_that) {
case _WorkOrderResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkOrderResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WorkOrderResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WorkOrderItem order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkOrderResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WorkOrderItem order)  $default,) {final _that = this;
switch (_that) {
case _WorkOrderResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WorkOrderItem order)?  $default,) {final _that = this;
switch (_that) {
case _WorkOrderResponse() when $default != null:
return $default(_that.order);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkOrderResponse implements WorkOrderResponse {
  const _WorkOrderResponse({required this.order});
  factory _WorkOrderResponse.fromJson(Map<String, dynamic> json) => _$WorkOrderResponseFromJson(json);

@override final  WorkOrderItem order;

/// Create a copy of WorkOrderResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkOrderResponseCopyWith<_WorkOrderResponse> get copyWith => __$WorkOrderResponseCopyWithImpl<_WorkOrderResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkOrderResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkOrderResponse&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,order);
}

@override
String toString() {
    return 'WorkOrderResponse(order: $order)';
}


}

/// @nodoc
abstract mixin class _$WorkOrderResponseCopyWith<$Res> implements $WorkOrderResponseCopyWith<$Res> {
  factory _$WorkOrderResponseCopyWith(_WorkOrderResponse value, $Res Function(_WorkOrderResponse) _then) = __$WorkOrderResponseCopyWithImpl;
@override @useResult
$Res call({
 WorkOrderItem order
});


@override $WorkOrderItemCopyWith<$Res> get order;

}
/// @nodoc
class __$WorkOrderResponseCopyWithImpl<$Res>
    implements _$WorkOrderResponseCopyWith<$Res> {
  __$WorkOrderResponseCopyWithImpl(this._self, this._then);

  final _WorkOrderResponse _self;
  final $Res Function(_WorkOrderResponse) _then;

/// Create a copy of WorkOrderResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? order = null,}) {
  return _then(_WorkOrderResponse(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as WorkOrderItem,
  ));
}

/// Create a copy of WorkOrderResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkOrderItemCopyWith<$Res> get order {
  
  return $WorkOrderItemCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}


/// @nodoc
mixin _$MessageResponse {

 String get message;
/// Create a copy of MessageResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageResponseCopyWith<MessageResponse> get copyWith => _$MessageResponseCopyWithImpl<MessageResponse>(this as MessageResponse, _$identity);

  /// Serializes this MessageResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MessageResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageResponse&&(identical(other.message, _this.message) || other.message == _this.message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MessageResponse;
  return Object.hash(runtimeType,_this.message);
}

@override
String toString() {
  final _this = this as MessageResponse;
  return 'MessageResponse(message: ${_this.message})';
}


}

/// @nodoc
abstract mixin class $MessageResponseCopyWith<$Res>  {
  factory $MessageResponseCopyWith(MessageResponse value, $Res Function(MessageResponse) _then) = _$MessageResponseCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$MessageResponseCopyWithImpl<$Res>
    implements $MessageResponseCopyWith<$Res> {
  _$MessageResponseCopyWithImpl(this._self, this._then);

  final MessageResponse _self;
  final $Res Function(MessageResponse) _then;

/// Create a copy of MessageResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,}) {
  return _then(MessageResponse(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageResponse].
extension MessageResponsePatterns on MessageResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageResponse value)  $default,){
final _that = this;
switch (_that) {
case _MessageResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MessageResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageResponse() when $default != null:
return $default(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message)  $default,) {final _that = this;
switch (_that) {
case _MessageResponse():
return $default(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message)?  $default,) {final _that = this;
switch (_that) {
case _MessageResponse() when $default != null:
return $default(_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageResponse implements MessageResponse {
  const _MessageResponse({this.message = ''});
  factory _MessageResponse.fromJson(Map<String, dynamic> json) => _$MessageResponseFromJson(json);

@override@JsonKey() final  String message;

/// Create a copy of MessageResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageResponseCopyWith<_MessageResponse> get copyWith => __$MessageResponseCopyWithImpl<_MessageResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageResponse&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'MessageResponse(message: $message)';
}


}

/// @nodoc
abstract mixin class _$MessageResponseCopyWith<$Res> implements $MessageResponseCopyWith<$Res> {
  factory _$MessageResponseCopyWith(_MessageResponse value, $Res Function(_MessageResponse) _then) = __$MessageResponseCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class __$MessageResponseCopyWithImpl<$Res>
    implements _$MessageResponseCopyWith<$Res> {
  __$MessageResponseCopyWithImpl(this._self, this._then);

  final _MessageResponse _self;
  final $Res Function(_MessageResponse) _then;

/// Create a copy of MessageResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_MessageResponse(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
