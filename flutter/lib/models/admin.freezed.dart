// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Dashboard {

 int get specAmount; int get entityAmount; int get userAmount; int get keyAmount; int get orderAmount; int get workOrderCount; int get galleryCount; List<GalleryCard> get galleryItems; List<WorkOrderItem> get workOrders; List<DeleteConfirmItem> get deleteConfirms;
/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardCopyWith<Dashboard> get copyWith => _$DashboardCopyWithImpl<Dashboard>(this as Dashboard, _$identity);

  /// Serializes this Dashboard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Dashboard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Dashboard&&(identical(other.specAmount, _this.specAmount) || other.specAmount == _this.specAmount)&&(identical(other.entityAmount, _this.entityAmount) || other.entityAmount == _this.entityAmount)&&(identical(other.userAmount, _this.userAmount) || other.userAmount == _this.userAmount)&&(identical(other.keyAmount, _this.keyAmount) || other.keyAmount == _this.keyAmount)&&(identical(other.orderAmount, _this.orderAmount) || other.orderAmount == _this.orderAmount)&&(identical(other.workOrderCount, _this.workOrderCount) || other.workOrderCount == _this.workOrderCount)&&(identical(other.galleryCount, _this.galleryCount) || other.galleryCount == _this.galleryCount)&&const DeepCollectionEquality().equals(other.galleryItems, _this.galleryItems)&&const DeepCollectionEquality().equals(other.workOrders, _this.workOrders)&&const DeepCollectionEquality().equals(other.deleteConfirms, _this.deleteConfirms));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Dashboard;
  return Object.hash(runtimeType,_this.specAmount,_this.entityAmount,_this.userAmount,_this.keyAmount,_this.orderAmount,_this.workOrderCount,_this.galleryCount,const DeepCollectionEquality().hash(_this.galleryItems),const DeepCollectionEquality().hash(_this.workOrders),const DeepCollectionEquality().hash(_this.deleteConfirms));
}

@override
String toString() {
  final _this = this as Dashboard;
  return 'Dashboard(specAmount: ${_this.specAmount}, entityAmount: ${_this.entityAmount}, userAmount: ${_this.userAmount}, keyAmount: ${_this.keyAmount}, orderAmount: ${_this.orderAmount}, workOrderCount: ${_this.workOrderCount}, galleryCount: ${_this.galleryCount}, galleryItems: ${_this.galleryItems}, workOrders: ${_this.workOrders}, deleteConfirms: ${_this.deleteConfirms})';
}


}

/// @nodoc
abstract mixin class $DashboardCopyWith<$Res>  {
  factory $DashboardCopyWith(Dashboard value, $Res Function(Dashboard) _then) = _$DashboardCopyWithImpl;
@useResult
$Res call({
 int specAmount, int entityAmount, int userAmount, int keyAmount, int orderAmount, int workOrderCount, int galleryCount, List<GalleryCard> galleryItems, List<WorkOrderItem> workOrders, List<DeleteConfirmItem> deleteConfirms
});




}
/// @nodoc
class _$DashboardCopyWithImpl<$Res>
    implements $DashboardCopyWith<$Res> {
  _$DashboardCopyWithImpl(this._self, this._then);

  final Dashboard _self;
  final $Res Function(Dashboard) _then;

/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? specAmount = null,Object? entityAmount = null,Object? userAmount = null,Object? keyAmount = null,Object? orderAmount = null,Object? workOrderCount = null,Object? galleryCount = null,Object? galleryItems = null,Object? workOrders = null,Object? deleteConfirms = null,}) {
  return _then(Dashboard(
specAmount: null == specAmount ? _self.specAmount : specAmount // ignore: cast_nullable_to_non_nullable
as int,entityAmount: null == entityAmount ? _self.entityAmount : entityAmount // ignore: cast_nullable_to_non_nullable
as int,userAmount: null == userAmount ? _self.userAmount : userAmount // ignore: cast_nullable_to_non_nullable
as int,keyAmount: null == keyAmount ? _self.keyAmount : keyAmount // ignore: cast_nullable_to_non_nullable
as int,orderAmount: null == orderAmount ? _self.orderAmount : orderAmount // ignore: cast_nullable_to_non_nullable
as int,workOrderCount: null == workOrderCount ? _self.workOrderCount : workOrderCount // ignore: cast_nullable_to_non_nullable
as int,galleryCount: null == galleryCount ? _self.galleryCount : galleryCount // ignore: cast_nullable_to_non_nullable
as int,galleryItems: null == galleryItems ? _self.galleryItems : galleryItems // ignore: cast_nullable_to_non_nullable
as List<GalleryCard>,workOrders: null == workOrders ? _self.workOrders : workOrders // ignore: cast_nullable_to_non_nullable
as List<WorkOrderItem>,deleteConfirms: null == deleteConfirms ? _self.deleteConfirms : deleteConfirms // ignore: cast_nullable_to_non_nullable
as List<DeleteConfirmItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [Dashboard].
extension DashboardPatterns on Dashboard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Dashboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Dashboard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Dashboard value)  $default,){
final _that = this;
switch (_that) {
case _Dashboard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Dashboard value)?  $default,){
final _that = this;
switch (_that) {
case _Dashboard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int specAmount,  int entityAmount,  int userAmount,  int keyAmount,  int orderAmount,  int workOrderCount,  int galleryCount,  List<GalleryCard> galleryItems,  List<WorkOrderItem> workOrders,  List<DeleteConfirmItem> deleteConfirms)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Dashboard() when $default != null:
return $default(_that.specAmount,_that.entityAmount,_that.userAmount,_that.keyAmount,_that.orderAmount,_that.workOrderCount,_that.galleryCount,_that.galleryItems,_that.workOrders,_that.deleteConfirms);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int specAmount,  int entityAmount,  int userAmount,  int keyAmount,  int orderAmount,  int workOrderCount,  int galleryCount,  List<GalleryCard> galleryItems,  List<WorkOrderItem> workOrders,  List<DeleteConfirmItem> deleteConfirms)  $default,) {final _that = this;
switch (_that) {
case _Dashboard():
return $default(_that.specAmount,_that.entityAmount,_that.userAmount,_that.keyAmount,_that.orderAmount,_that.workOrderCount,_that.galleryCount,_that.galleryItems,_that.workOrders,_that.deleteConfirms);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int specAmount,  int entityAmount,  int userAmount,  int keyAmount,  int orderAmount,  int workOrderCount,  int galleryCount,  List<GalleryCard> galleryItems,  List<WorkOrderItem> workOrders,  List<DeleteConfirmItem> deleteConfirms)?  $default,) {final _that = this;
switch (_that) {
case _Dashboard() when $default != null:
return $default(_that.specAmount,_that.entityAmount,_that.userAmount,_that.keyAmount,_that.orderAmount,_that.workOrderCount,_that.galleryCount,_that.galleryItems,_that.workOrders,_that.deleteConfirms);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Dashboard implements Dashboard {
  const _Dashboard({this.specAmount = 0, this.entityAmount = 0, this.userAmount = 0, this.keyAmount = 0, this.orderAmount = 0, this.workOrderCount = 0, this.galleryCount = 0,  List<GalleryCard> galleryItems = const <GalleryCard>[],  List<WorkOrderItem> workOrders = const <WorkOrderItem>[],  List<DeleteConfirmItem> deleteConfirms = const <DeleteConfirmItem>[]}): _galleryItems = galleryItems,_workOrders = workOrders,_deleteConfirms = deleteConfirms;
  factory _Dashboard.fromJson(Map<String, dynamic> json) => _$DashboardFromJson(json);

@override@JsonKey() final  int specAmount;
@override@JsonKey() final  int entityAmount;
@override@JsonKey() final  int userAmount;
@override@JsonKey() final  int keyAmount;
@override@JsonKey() final  int orderAmount;
@override@JsonKey() final  int workOrderCount;
@override@JsonKey() final  int galleryCount;
 final  List<GalleryCard> _galleryItems;
@override@JsonKey() List<GalleryCard> get galleryItems {
  if (_galleryItems is EqualUnmodifiableListView) return _galleryItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_galleryItems);
}

 final  List<WorkOrderItem> _workOrders;
@override@JsonKey() List<WorkOrderItem> get workOrders {
  if (_workOrders is EqualUnmodifiableListView) return _workOrders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_workOrders);
}

 final  List<DeleteConfirmItem> _deleteConfirms;
@override@JsonKey() List<DeleteConfirmItem> get deleteConfirms {
  if (_deleteConfirms is EqualUnmodifiableListView) return _deleteConfirms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deleteConfirms);
}


/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardCopyWith<_Dashboard> get copyWith => __$DashboardCopyWithImpl<_Dashboard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Dashboard&&(identical(other.specAmount, specAmount) || other.specAmount == specAmount)&&(identical(other.entityAmount, entityAmount) || other.entityAmount == entityAmount)&&(identical(other.userAmount, userAmount) || other.userAmount == userAmount)&&(identical(other.keyAmount, keyAmount) || other.keyAmount == keyAmount)&&(identical(other.orderAmount, orderAmount) || other.orderAmount == orderAmount)&&(identical(other.workOrderCount, workOrderCount) || other.workOrderCount == workOrderCount)&&(identical(other.galleryCount, galleryCount) || other.galleryCount == galleryCount)&&const DeepCollectionEquality().equals(other.galleryItems, _galleryItems)&&const DeepCollectionEquality().equals(other.workOrders, _workOrders)&&const DeepCollectionEquality().equals(other.deleteConfirms, _deleteConfirms));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,specAmount,entityAmount,userAmount,keyAmount,orderAmount,workOrderCount,galleryCount,const DeepCollectionEquality().hash(_galleryItems),const DeepCollectionEquality().hash(_workOrders),const DeepCollectionEquality().hash(_deleteConfirms));
}

@override
String toString() {
    return 'Dashboard(specAmount: $specAmount, entityAmount: $entityAmount, userAmount: $userAmount, keyAmount: $keyAmount, orderAmount: $orderAmount, workOrderCount: $workOrderCount, galleryCount: $galleryCount, galleryItems: $galleryItems, workOrders: $workOrders, deleteConfirms: $deleteConfirms)';
}


}

/// @nodoc
abstract mixin class _$DashboardCopyWith<$Res> implements $DashboardCopyWith<$Res> {
  factory _$DashboardCopyWith(_Dashboard value, $Res Function(_Dashboard) _then) = __$DashboardCopyWithImpl;
@override @useResult
$Res call({
 int specAmount, int entityAmount, int userAmount, int keyAmount, int orderAmount, int workOrderCount, int galleryCount, List<GalleryCard> galleryItems, List<WorkOrderItem> workOrders, List<DeleteConfirmItem> deleteConfirms
});




}
/// @nodoc
class __$DashboardCopyWithImpl<$Res>
    implements _$DashboardCopyWith<$Res> {
  __$DashboardCopyWithImpl(this._self, this._then);

  final _Dashboard _self;
  final $Res Function(_Dashboard) _then;

/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? specAmount = null,Object? entityAmount = null,Object? userAmount = null,Object? keyAmount = null,Object? orderAmount = null,Object? workOrderCount = null,Object? galleryCount = null,Object? galleryItems = null,Object? workOrders = null,Object? deleteConfirms = null,}) {
  return _then(_Dashboard(
specAmount: null == specAmount ? _self.specAmount : specAmount // ignore: cast_nullable_to_non_nullable
as int,entityAmount: null == entityAmount ? _self.entityAmount : entityAmount // ignore: cast_nullable_to_non_nullable
as int,userAmount: null == userAmount ? _self.userAmount : userAmount // ignore: cast_nullable_to_non_nullable
as int,keyAmount: null == keyAmount ? _self.keyAmount : keyAmount // ignore: cast_nullable_to_non_nullable
as int,orderAmount: null == orderAmount ? _self.orderAmount : orderAmount // ignore: cast_nullable_to_non_nullable
as int,workOrderCount: null == workOrderCount ? _self.workOrderCount : workOrderCount // ignore: cast_nullable_to_non_nullable
as int,galleryCount: null == galleryCount ? _self.galleryCount : galleryCount // ignore: cast_nullable_to_non_nullable
as int,galleryItems: null == galleryItems ? _self._galleryItems : galleryItems // ignore: cast_nullable_to_non_nullable
as List<GalleryCard>,workOrders: null == workOrders ? _self._workOrders : workOrders // ignore: cast_nullable_to_non_nullable
as List<WorkOrderItem>,deleteConfirms: null == deleteConfirms ? _self._deleteConfirms : deleteConfirms // ignore: cast_nullable_to_non_nullable
as List<DeleteConfirmItem>,
  ));
}


}


/// @nodoc
mixin _$DeleteConfirmItem {

 String get entityId; String get confirmId; String get serverName; String get consoleUrl; String get identifier; String get owner;/// Formatted `yyyy-MM-dd HH:mm` by the server.
 String get expire; String get hostName;
/// Create a copy of DeleteConfirmItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteConfirmItemCopyWith<DeleteConfirmItem> get copyWith => _$DeleteConfirmItemCopyWithImpl<DeleteConfirmItem>(this as DeleteConfirmItem, _$identity);

  /// Serializes this DeleteConfirmItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeleteConfirmItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteConfirmItem&&(identical(other.entityId, _this.entityId) || other.entityId == _this.entityId)&&(identical(other.confirmId, _this.confirmId) || other.confirmId == _this.confirmId)&&(identical(other.serverName, _this.serverName) || other.serverName == _this.serverName)&&(identical(other.consoleUrl, _this.consoleUrl) || other.consoleUrl == _this.consoleUrl)&&(identical(other.identifier, _this.identifier) || other.identifier == _this.identifier)&&(identical(other.owner, _this.owner) || other.owner == _this.owner)&&(identical(other.expire, _this.expire) || other.expire == _this.expire)&&(identical(other.hostName, _this.hostName) || other.hostName == _this.hostName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeleteConfirmItem;
  return Object.hash(runtimeType,_this.entityId,_this.confirmId,_this.serverName,_this.consoleUrl,_this.identifier,_this.owner,_this.expire,_this.hostName);
}

@override
String toString() {
  final _this = this as DeleteConfirmItem;
  return 'DeleteConfirmItem(entityId: ${_this.entityId}, confirmId: ${_this.confirmId}, serverName: ${_this.serverName}, consoleUrl: ${_this.consoleUrl}, identifier: ${_this.identifier}, owner: ${_this.owner}, expire: ${_this.expire}, hostName: ${_this.hostName})';
}


}

/// @nodoc
abstract mixin class $DeleteConfirmItemCopyWith<$Res>  {
  factory $DeleteConfirmItemCopyWith(DeleteConfirmItem value, $Res Function(DeleteConfirmItem) _then) = _$DeleteConfirmItemCopyWithImpl;
@useResult
$Res call({
 String entityId, String confirmId, String serverName, String consoleUrl, String identifier, String owner, String expire, String hostName
});




}
/// @nodoc
class _$DeleteConfirmItemCopyWithImpl<$Res>
    implements $DeleteConfirmItemCopyWith<$Res> {
  _$DeleteConfirmItemCopyWithImpl(this._self, this._then);

  final DeleteConfirmItem _self;
  final $Res Function(DeleteConfirmItem) _then;

/// Create a copy of DeleteConfirmItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entityId = null,Object? confirmId = null,Object? serverName = null,Object? consoleUrl = null,Object? identifier = null,Object? owner = null,Object? expire = null,Object? hostName = null,}) {
  return _then(DeleteConfirmItem(
entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,confirmId: null == confirmId ? _self.confirmId : confirmId // ignore: cast_nullable_to_non_nullable
as String,serverName: null == serverName ? _self.serverName : serverName // ignore: cast_nullable_to_non_nullable
as String,consoleUrl: null == consoleUrl ? _self.consoleUrl : consoleUrl // ignore: cast_nullable_to_non_nullable
as String,identifier: null == identifier ? _self.identifier : identifier // ignore: cast_nullable_to_non_nullable
as String,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String,expire: null == expire ? _self.expire : expire // ignore: cast_nullable_to_non_nullable
as String,hostName: null == hostName ? _self.hostName : hostName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DeleteConfirmItem].
extension DeleteConfirmItemPatterns on DeleteConfirmItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeleteConfirmItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeleteConfirmItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeleteConfirmItem value)  $default,){
final _that = this;
switch (_that) {
case _DeleteConfirmItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeleteConfirmItem value)?  $default,){
final _that = this;
switch (_that) {
case _DeleteConfirmItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String entityId,  String confirmId,  String serverName,  String consoleUrl,  String identifier,  String owner,  String expire,  String hostName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeleteConfirmItem() when $default != null:
return $default(_that.entityId,_that.confirmId,_that.serverName,_that.consoleUrl,_that.identifier,_that.owner,_that.expire,_that.hostName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String entityId,  String confirmId,  String serverName,  String consoleUrl,  String identifier,  String owner,  String expire,  String hostName)  $default,) {final _that = this;
switch (_that) {
case _DeleteConfirmItem():
return $default(_that.entityId,_that.confirmId,_that.serverName,_that.consoleUrl,_that.identifier,_that.owner,_that.expire,_that.hostName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String entityId,  String confirmId,  String serverName,  String consoleUrl,  String identifier,  String owner,  String expire,  String hostName)?  $default,) {final _that = this;
switch (_that) {
case _DeleteConfirmItem() when $default != null:
return $default(_that.entityId,_that.confirmId,_that.serverName,_that.consoleUrl,_that.identifier,_that.owner,_that.expire,_that.hostName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeleteConfirmItem implements DeleteConfirmItem {
  const _DeleteConfirmItem({this.entityId = '', this.confirmId = '', this.serverName = '', this.consoleUrl = '', this.identifier = '', this.owner = '', this.expire = '', this.hostName = ''});
  factory _DeleteConfirmItem.fromJson(Map<String, dynamic> json) => _$DeleteConfirmItemFromJson(json);

@override@JsonKey() final  String entityId;
@override@JsonKey() final  String confirmId;
@override@JsonKey() final  String serverName;
@override@JsonKey() final  String consoleUrl;
@override@JsonKey() final  String identifier;
@override@JsonKey() final  String owner;
/// Formatted `yyyy-MM-dd HH:mm` by the server.
@override@JsonKey() final  String expire;
@override@JsonKey() final  String hostName;

/// Create a copy of DeleteConfirmItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteConfirmItemCopyWith<_DeleteConfirmItem> get copyWith => __$DeleteConfirmItemCopyWithImpl<_DeleteConfirmItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeleteConfirmItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteConfirmItem&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.confirmId, confirmId) || other.confirmId == confirmId)&&(identical(other.serverName, serverName) || other.serverName == serverName)&&(identical(other.consoleUrl, consoleUrl) || other.consoleUrl == consoleUrl)&&(identical(other.identifier, identifier) || other.identifier == identifier)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.expire, expire) || other.expire == expire)&&(identical(other.hostName, hostName) || other.hostName == hostName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,entityId,confirmId,serverName,consoleUrl,identifier,owner,expire,hostName);
}

@override
String toString() {
    return 'DeleteConfirmItem(entityId: $entityId, confirmId: $confirmId, serverName: $serverName, consoleUrl: $consoleUrl, identifier: $identifier, owner: $owner, expire: $expire, hostName: $hostName)';
}


}

/// @nodoc
abstract mixin class _$DeleteConfirmItemCopyWith<$Res> implements $DeleteConfirmItemCopyWith<$Res> {
  factory _$DeleteConfirmItemCopyWith(_DeleteConfirmItem value, $Res Function(_DeleteConfirmItem) _then) = __$DeleteConfirmItemCopyWithImpl;
@override @useResult
$Res call({
 String entityId, String confirmId, String serverName, String consoleUrl, String identifier, String owner, String expire, String hostName
});




}
/// @nodoc
class __$DeleteConfirmItemCopyWithImpl<$Res>
    implements _$DeleteConfirmItemCopyWith<$Res> {
  __$DeleteConfirmItemCopyWithImpl(this._self, this._then);

  final _DeleteConfirmItem _self;
  final $Res Function(_DeleteConfirmItem) _then;

/// Create a copy of DeleteConfirmItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entityId = null,Object? confirmId = null,Object? serverName = null,Object? consoleUrl = null,Object? identifier = null,Object? owner = null,Object? expire = null,Object? hostName = null,}) {
  return _then(_DeleteConfirmItem(
entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,confirmId: null == confirmId ? _self.confirmId : confirmId // ignore: cast_nullable_to_non_nullable
as String,serverName: null == serverName ? _self.serverName : serverName // ignore: cast_nullable_to_non_nullable
as String,consoleUrl: null == consoleUrl ? _self.consoleUrl : consoleUrl // ignore: cast_nullable_to_non_nullable
as String,identifier: null == identifier ? _self.identifier : identifier // ignore: cast_nullable_to_non_nullable
as String,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String,expire: null == expire ? _self.expire : expire // ignore: cast_nullable_to_non_nullable
as String,hostName: null == hostName ? _self.hostName : hostName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AdminUser {

 String get id; String get name; String get email; int get balance; bool get isAdmin; bool get emailConfirmed; bool get pteUserCreated;/// Nanoseconds, as stored.
 int get totalUpTime;/// Formatted `yyyy-MM-dd HH:mm` by the server.
 String get createdAt;
/// Create a copy of AdminUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminUserCopyWith<AdminUser> get copyWith => _$AdminUserCopyWithImpl<AdminUser>(this as AdminUser, _$identity);

  /// Serializes this AdminUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminUser;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminUser&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.balance, _this.balance) || other.balance == _this.balance)&&(identical(other.isAdmin, _this.isAdmin) || other.isAdmin == _this.isAdmin)&&(identical(other.emailConfirmed, _this.emailConfirmed) || other.emailConfirmed == _this.emailConfirmed)&&(identical(other.pteUserCreated, _this.pteUserCreated) || other.pteUserCreated == _this.pteUserCreated)&&(identical(other.totalUpTime, _this.totalUpTime) || other.totalUpTime == _this.totalUpTime)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminUser;
  return Object.hash(runtimeType,_this.id,_this.name,_this.email,_this.balance,_this.isAdmin,_this.emailConfirmed,_this.pteUserCreated,_this.totalUpTime,_this.createdAt);
}

@override
String toString() {
  final _this = this as AdminUser;
  return 'AdminUser(id: ${_this.id}, name: ${_this.name}, email: ${_this.email}, balance: ${_this.balance}, isAdmin: ${_this.isAdmin}, emailConfirmed: ${_this.emailConfirmed}, pteUserCreated: ${_this.pteUserCreated}, totalUpTime: ${_this.totalUpTime}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $AdminUserCopyWith<$Res>  {
  factory $AdminUserCopyWith(AdminUser value, $Res Function(AdminUser) _then) = _$AdminUserCopyWithImpl;
@useResult
$Res call({
 String id, String name, String email, int balance, bool isAdmin, bool emailConfirmed, bool pteUserCreated, int totalUpTime, String createdAt
});




}
/// @nodoc
class _$AdminUserCopyWithImpl<$Res>
    implements $AdminUserCopyWith<$Res> {
  _$AdminUserCopyWithImpl(this._self, this._then);

  final AdminUser _self;
  final $Res Function(AdminUser) _then;

/// Create a copy of AdminUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? balance = null,Object? isAdmin = null,Object? emailConfirmed = null,Object? pteUserCreated = null,Object? totalUpTime = null,Object? createdAt = null,}) {
  return _then(AdminUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,emailConfirmed: null == emailConfirmed ? _self.emailConfirmed : emailConfirmed // ignore: cast_nullable_to_non_nullable
as bool,pteUserCreated: null == pteUserCreated ? _self.pteUserCreated : pteUserCreated // ignore: cast_nullable_to_non_nullable
as bool,totalUpTime: null == totalUpTime ? _self.totalUpTime : totalUpTime // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminUser].
extension AdminUserPatterns on AdminUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminUser value)  $default,){
final _that = this;
switch (_that) {
case _AdminUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminUser value)?  $default,){
final _that = this;
switch (_that) {
case _AdminUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String email,  int balance,  bool isAdmin,  bool emailConfirmed,  bool pteUserCreated,  int totalUpTime,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminUser() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.balance,_that.isAdmin,_that.emailConfirmed,_that.pteUserCreated,_that.totalUpTime,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String email,  int balance,  bool isAdmin,  bool emailConfirmed,  bool pteUserCreated,  int totalUpTime,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _AdminUser():
return $default(_that.id,_that.name,_that.email,_that.balance,_that.isAdmin,_that.emailConfirmed,_that.pteUserCreated,_that.totalUpTime,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String email,  int balance,  bool isAdmin,  bool emailConfirmed,  bool pteUserCreated,  int totalUpTime,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AdminUser() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.balance,_that.isAdmin,_that.emailConfirmed,_that.pteUserCreated,_that.totalUpTime,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminUser extends AdminUser {
  const _AdminUser({this.id = '', this.name = '', this.email = '', this.balance = 0, this.isAdmin = false, this.emailConfirmed = false, this.pteUserCreated = false, this.totalUpTime = 0, this.createdAt = ''}): super._();
  factory _AdminUser.fromJson(Map<String, dynamic> json) => _$AdminUserFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String email;
@override@JsonKey() final  int balance;
@override@JsonKey() final  bool isAdmin;
@override@JsonKey() final  bool emailConfirmed;
@override@JsonKey() final  bool pteUserCreated;
/// Nanoseconds, as stored.
@override@JsonKey() final  int totalUpTime;
/// Formatted `yyyy-MM-dd HH:mm` by the server.
@override@JsonKey() final  String createdAt;

/// Create a copy of AdminUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminUserCopyWith<_AdminUser> get copyWith => __$AdminUserCopyWithImpl<_AdminUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminUserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminUser&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.emailConfirmed, emailConfirmed) || other.emailConfirmed == emailConfirmed)&&(identical(other.pteUserCreated, pteUserCreated) || other.pteUserCreated == pteUserCreated)&&(identical(other.totalUpTime, totalUpTime) || other.totalUpTime == totalUpTime)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,email,balance,isAdmin,emailConfirmed,pteUserCreated,totalUpTime,createdAt);
}

@override
String toString() {
    return 'AdminUser(id: $id, name: $name, email: $email, balance: $balance, isAdmin: $isAdmin, emailConfirmed: $emailConfirmed, pteUserCreated: $pteUserCreated, totalUpTime: $totalUpTime, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AdminUserCopyWith<$Res> implements $AdminUserCopyWith<$Res> {
  factory _$AdminUserCopyWith(_AdminUser value, $Res Function(_AdminUser) _then) = __$AdminUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String email, int balance, bool isAdmin, bool emailConfirmed, bool pteUserCreated, int totalUpTime, String createdAt
});




}
/// @nodoc
class __$AdminUserCopyWithImpl<$Res>
    implements _$AdminUserCopyWith<$Res> {
  __$AdminUserCopyWithImpl(this._self, this._then);

  final _AdminUser _self;
  final $Res Function(_AdminUser) _then;

/// Create a copy of AdminUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? balance = null,Object? isAdmin = null,Object? emailConfirmed = null,Object? pteUserCreated = null,Object? totalUpTime = null,Object? createdAt = null,}) {
  return _then(_AdminUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,emailConfirmed: null == emailConfirmed ? _self.emailConfirmed : emailConfirmed // ignore: cast_nullable_to_non_nullable
as bool,pteUserCreated: null == pteUserCreated ? _self.pteUserCreated : pteUserCreated // ignore: cast_nullable_to_non_nullable
as bool,totalUpTime: null == totalUpTime ? _self.totalUpTime : totalUpTime // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AdminOrder {

 String get id; String get userName; String get specName; int get specDays; int get finalPrice; String get createdAt;
/// Create a copy of AdminOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminOrderCopyWith<AdminOrder> get copyWith => _$AdminOrderCopyWithImpl<AdminOrder>(this as AdminOrder, _$identity);

  /// Serializes this AdminOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminOrder;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminOrder&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userName, _this.userName) || other.userName == _this.userName)&&(identical(other.specName, _this.specName) || other.specName == _this.specName)&&(identical(other.specDays, _this.specDays) || other.specDays == _this.specDays)&&(identical(other.finalPrice, _this.finalPrice) || other.finalPrice == _this.finalPrice)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminOrder;
  return Object.hash(runtimeType,_this.id,_this.userName,_this.specName,_this.specDays,_this.finalPrice,_this.createdAt);
}

@override
String toString() {
  final _this = this as AdminOrder;
  return 'AdminOrder(id: ${_this.id}, userName: ${_this.userName}, specName: ${_this.specName}, specDays: ${_this.specDays}, finalPrice: ${_this.finalPrice}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $AdminOrderCopyWith<$Res>  {
  factory $AdminOrderCopyWith(AdminOrder value, $Res Function(AdminOrder) _then) = _$AdminOrderCopyWithImpl;
@useResult
$Res call({
 String id, String userName, String specName, int specDays, int finalPrice, String createdAt
});




}
/// @nodoc
class _$AdminOrderCopyWithImpl<$Res>
    implements $AdminOrderCopyWith<$Res> {
  _$AdminOrderCopyWithImpl(this._self, this._then);

  final AdminOrder _self;
  final $Res Function(AdminOrder) _then;

/// Create a copy of AdminOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userName = null,Object? specName = null,Object? specDays = null,Object? finalPrice = null,Object? createdAt = null,}) {
  return _then(AdminOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,specName: null == specName ? _self.specName : specName // ignore: cast_nullable_to_non_nullable
as String,specDays: null == specDays ? _self.specDays : specDays // ignore: cast_nullable_to_non_nullable
as int,finalPrice: null == finalPrice ? _self.finalPrice : finalPrice // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminOrder].
extension AdminOrderPatterns on AdminOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminOrder value)  $default,){
final _that = this;
switch (_that) {
case _AdminOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminOrder value)?  $default,){
final _that = this;
switch (_that) {
case _AdminOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userName,  String specName,  int specDays,  int finalPrice,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminOrder() when $default != null:
return $default(_that.id,_that.userName,_that.specName,_that.specDays,_that.finalPrice,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userName,  String specName,  int specDays,  int finalPrice,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _AdminOrder():
return $default(_that.id,_that.userName,_that.specName,_that.specDays,_that.finalPrice,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userName,  String specName,  int specDays,  int finalPrice,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AdminOrder() when $default != null:
return $default(_that.id,_that.userName,_that.specName,_that.specDays,_that.finalPrice,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminOrder implements AdminOrder {
  const _AdminOrder({this.id = '', this.userName = '', this.specName = '', this.specDays = 0, this.finalPrice = 0, this.createdAt = ''});
  factory _AdminOrder.fromJson(Map<String, dynamic> json) => _$AdminOrderFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String userName;
@override@JsonKey() final  String specName;
@override@JsonKey() final  int specDays;
@override@JsonKey() final  int finalPrice;
@override@JsonKey() final  String createdAt;

/// Create a copy of AdminOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminOrderCopyWith<_AdminOrder> get copyWith => __$AdminOrderCopyWithImpl<_AdminOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminOrderToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.specName, specName) || other.specName == specName)&&(identical(other.specDays, specDays) || other.specDays == specDays)&&(identical(other.finalPrice, finalPrice) || other.finalPrice == finalPrice)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userName,specName,specDays,finalPrice,createdAt);
}

@override
String toString() {
    return 'AdminOrder(id: $id, userName: $userName, specName: $specName, specDays: $specDays, finalPrice: $finalPrice, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AdminOrderCopyWith<$Res> implements $AdminOrderCopyWith<$Res> {
  factory _$AdminOrderCopyWith(_AdminOrder value, $Res Function(_AdminOrder) _then) = __$AdminOrderCopyWithImpl;
@override @useResult
$Res call({
 String id, String userName, String specName, int specDays, int finalPrice, String createdAt
});




}
/// @nodoc
class __$AdminOrderCopyWithImpl<$Res>
    implements _$AdminOrderCopyWith<$Res> {
  __$AdminOrderCopyWithImpl(this._self, this._then);

  final _AdminOrder _self;
  final $Res Function(_AdminOrder) _then;

/// Create a copy of AdminOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userName = null,Object? specName = null,Object? specDays = null,Object? finalPrice = null,Object? createdAt = null,}) {
  return _then(_AdminOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,specName: null == specName ? _self.specName : specName // ignore: cast_nullable_to_non_nullable
as String,specDays: null == specDays ? _self.specDays : specDays // ignore: cast_nullable_to_non_nullable
as int,finalPrice: null == finalPrice ? _self.finalPrice : finalPrice // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AdminProduct {

 String get specId; String get wareName; String get wareDescription; int get pricePerMonth; int get discount; int get validDays; int get deleteDays; int get memory; int get cpu; int get disk; int get swap; int get io; int get backups; int get node; int get nest; String get tagSlug; int get egg; List<int> get allowedEggIds; String get dockerImage; bool get oomDisabled; bool get startOnCompletion;
/// Create a copy of AdminProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminProductCopyWith<AdminProduct> get copyWith => _$AdminProductCopyWithImpl<AdminProduct>(this as AdminProduct, _$identity);

  /// Serializes this AdminProduct to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminProduct;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminProduct&&(identical(other.specId, _this.specId) || other.specId == _this.specId)&&(identical(other.wareName, _this.wareName) || other.wareName == _this.wareName)&&(identical(other.wareDescription, _this.wareDescription) || other.wareDescription == _this.wareDescription)&&(identical(other.pricePerMonth, _this.pricePerMonth) || other.pricePerMonth == _this.pricePerMonth)&&(identical(other.discount, _this.discount) || other.discount == _this.discount)&&(identical(other.validDays, _this.validDays) || other.validDays == _this.validDays)&&(identical(other.deleteDays, _this.deleteDays) || other.deleteDays == _this.deleteDays)&&(identical(other.memory, _this.memory) || other.memory == _this.memory)&&(identical(other.cpu, _this.cpu) || other.cpu == _this.cpu)&&(identical(other.disk, _this.disk) || other.disk == _this.disk)&&(identical(other.swap, _this.swap) || other.swap == _this.swap)&&(identical(other.io, _this.io) || other.io == _this.io)&&(identical(other.backups, _this.backups) || other.backups == _this.backups)&&(identical(other.node, _this.node) || other.node == _this.node)&&(identical(other.nest, _this.nest) || other.nest == _this.nest)&&(identical(other.tagSlug, _this.tagSlug) || other.tagSlug == _this.tagSlug)&&(identical(other.egg, _this.egg) || other.egg == _this.egg)&&const DeepCollectionEquality().equals(other.allowedEggIds, _this.allowedEggIds)&&(identical(other.dockerImage, _this.dockerImage) || other.dockerImage == _this.dockerImage)&&(identical(other.oomDisabled, _this.oomDisabled) || other.oomDisabled == _this.oomDisabled)&&(identical(other.startOnCompletion, _this.startOnCompletion) || other.startOnCompletion == _this.startOnCompletion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminProduct;
  return Object.hashAll([runtimeType,_this.specId,_this.wareName,_this.wareDescription,_this.pricePerMonth,_this.discount,_this.validDays,_this.deleteDays,_this.memory,_this.cpu,_this.disk,_this.swap,_this.io,_this.backups,_this.node,_this.nest,_this.tagSlug,_this.egg,const DeepCollectionEquality().hash(_this.allowedEggIds),_this.dockerImage,_this.oomDisabled,_this.startOnCompletion]);
}

@override
String toString() {
  final _this = this as AdminProduct;
  return 'AdminProduct(specId: ${_this.specId}, wareName: ${_this.wareName}, wareDescription: ${_this.wareDescription}, pricePerMonth: ${_this.pricePerMonth}, discount: ${_this.discount}, validDays: ${_this.validDays}, deleteDays: ${_this.deleteDays}, memory: ${_this.memory}, cpu: ${_this.cpu}, disk: ${_this.disk}, swap: ${_this.swap}, io: ${_this.io}, backups: ${_this.backups}, node: ${_this.node}, nest: ${_this.nest}, tagSlug: ${_this.tagSlug}, egg: ${_this.egg}, allowedEggIds: ${_this.allowedEggIds}, dockerImage: ${_this.dockerImage}, oomDisabled: ${_this.oomDisabled}, startOnCompletion: ${_this.startOnCompletion})';
}


}

/// @nodoc
abstract mixin class $AdminProductCopyWith<$Res>  {
  factory $AdminProductCopyWith(AdminProduct value, $Res Function(AdminProduct) _then) = _$AdminProductCopyWithImpl;
@useResult
$Res call({
 String specId, String wareName, String wareDescription, int pricePerMonth, int discount, int validDays, int deleteDays, int memory, int cpu, int disk, int swap, int io, int backups, int node, int nest, String tagSlug, int egg, List<int> allowedEggIds, String dockerImage, bool oomDisabled, bool startOnCompletion
});




}
/// @nodoc
class _$AdminProductCopyWithImpl<$Res>
    implements $AdminProductCopyWith<$Res> {
  _$AdminProductCopyWithImpl(this._self, this._then);

  final AdminProduct _self;
  final $Res Function(AdminProduct) _then;

/// Create a copy of AdminProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? specId = null,Object? wareName = null,Object? wareDescription = null,Object? pricePerMonth = null,Object? discount = null,Object? validDays = null,Object? deleteDays = null,Object? memory = null,Object? cpu = null,Object? disk = null,Object? swap = null,Object? io = null,Object? backups = null,Object? node = null,Object? nest = null,Object? tagSlug = null,Object? egg = null,Object? allowedEggIds = null,Object? dockerImage = null,Object? oomDisabled = null,Object? startOnCompletion = null,}) {
  return _then(AdminProduct(
specId: null == specId ? _self.specId : specId // ignore: cast_nullable_to_non_nullable
as String,wareName: null == wareName ? _self.wareName : wareName // ignore: cast_nullable_to_non_nullable
as String,wareDescription: null == wareDescription ? _self.wareDescription : wareDescription // ignore: cast_nullable_to_non_nullable
as String,pricePerMonth: null == pricePerMonth ? _self.pricePerMonth : pricePerMonth // ignore: cast_nullable_to_non_nullable
as int,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as int,validDays: null == validDays ? _self.validDays : validDays // ignore: cast_nullable_to_non_nullable
as int,deleteDays: null == deleteDays ? _self.deleteDays : deleteDays // ignore: cast_nullable_to_non_nullable
as int,memory: null == memory ? _self.memory : memory // ignore: cast_nullable_to_non_nullable
as int,cpu: null == cpu ? _self.cpu : cpu // ignore: cast_nullable_to_non_nullable
as int,disk: null == disk ? _self.disk : disk // ignore: cast_nullable_to_non_nullable
as int,swap: null == swap ? _self.swap : swap // ignore: cast_nullable_to_non_nullable
as int,io: null == io ? _self.io : io // ignore: cast_nullable_to_non_nullable
as int,backups: null == backups ? _self.backups : backups // ignore: cast_nullable_to_non_nullable
as int,node: null == node ? _self.node : node // ignore: cast_nullable_to_non_nullable
as int,nest: null == nest ? _self.nest : nest // ignore: cast_nullable_to_non_nullable
as int,tagSlug: null == tagSlug ? _self.tagSlug : tagSlug // ignore: cast_nullable_to_non_nullable
as String,egg: null == egg ? _self.egg : egg // ignore: cast_nullable_to_non_nullable
as int,allowedEggIds: null == allowedEggIds ? _self.allowedEggIds : allowedEggIds // ignore: cast_nullable_to_non_nullable
as List<int>,dockerImage: null == dockerImage ? _self.dockerImage : dockerImage // ignore: cast_nullable_to_non_nullable
as String,oomDisabled: null == oomDisabled ? _self.oomDisabled : oomDisabled // ignore: cast_nullable_to_non_nullable
as bool,startOnCompletion: null == startOnCompletion ? _self.startOnCompletion : startOnCompletion // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminProduct].
extension AdminProductPatterns on AdminProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminProduct value)  $default,){
final _that = this;
switch (_that) {
case _AdminProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminProduct value)?  $default,){
final _that = this;
switch (_that) {
case _AdminProduct() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String specId,  String wareName,  String wareDescription,  int pricePerMonth,  int discount,  int validDays,  int deleteDays,  int memory,  int cpu,  int disk,  int swap,  int io,  int backups,  int node,  int nest,  String tagSlug,  int egg,  List<int> allowedEggIds,  String dockerImage,  bool oomDisabled,  bool startOnCompletion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminProduct() when $default != null:
return $default(_that.specId,_that.wareName,_that.wareDescription,_that.pricePerMonth,_that.discount,_that.validDays,_that.deleteDays,_that.memory,_that.cpu,_that.disk,_that.swap,_that.io,_that.backups,_that.node,_that.nest,_that.tagSlug,_that.egg,_that.allowedEggIds,_that.dockerImage,_that.oomDisabled,_that.startOnCompletion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String specId,  String wareName,  String wareDescription,  int pricePerMonth,  int discount,  int validDays,  int deleteDays,  int memory,  int cpu,  int disk,  int swap,  int io,  int backups,  int node,  int nest,  String tagSlug,  int egg,  List<int> allowedEggIds,  String dockerImage,  bool oomDisabled,  bool startOnCompletion)  $default,) {final _that = this;
switch (_that) {
case _AdminProduct():
return $default(_that.specId,_that.wareName,_that.wareDescription,_that.pricePerMonth,_that.discount,_that.validDays,_that.deleteDays,_that.memory,_that.cpu,_that.disk,_that.swap,_that.io,_that.backups,_that.node,_that.nest,_that.tagSlug,_that.egg,_that.allowedEggIds,_that.dockerImage,_that.oomDisabled,_that.startOnCompletion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String specId,  String wareName,  String wareDescription,  int pricePerMonth,  int discount,  int validDays,  int deleteDays,  int memory,  int cpu,  int disk,  int swap,  int io,  int backups,  int node,  int nest,  String tagSlug,  int egg,  List<int> allowedEggIds,  String dockerImage,  bool oomDisabled,  bool startOnCompletion)?  $default,) {final _that = this;
switch (_that) {
case _AdminProduct() when $default != null:
return $default(_that.specId,_that.wareName,_that.wareDescription,_that.pricePerMonth,_that.discount,_that.validDays,_that.deleteDays,_that.memory,_that.cpu,_that.disk,_that.swap,_that.io,_that.backups,_that.node,_that.nest,_that.tagSlug,_that.egg,_that.allowedEggIds,_that.dockerImage,_that.oomDisabled,_that.startOnCompletion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminProduct implements AdminProduct {
  const _AdminProduct({this.specId = '', this.wareName = '', this.wareDescription = '', this.pricePerMonth = 0, this.discount = 0, this.validDays = 0, this.deleteDays = 0, this.memory = 0, this.cpu = 0, this.disk = 0, this.swap = 0, this.io = 0, this.backups = 0, this.node = 0, this.nest = 0, this.tagSlug = '', this.egg = 0,  List<int> allowedEggIds = const <int>[], this.dockerImage = '', this.oomDisabled = false, this.startOnCompletion = false}): _allowedEggIds = allowedEggIds;
  factory _AdminProduct.fromJson(Map<String, dynamic> json) => _$AdminProductFromJson(json);

@override@JsonKey() final  String specId;
@override@JsonKey() final  String wareName;
@override@JsonKey() final  String wareDescription;
@override@JsonKey() final  int pricePerMonth;
@override@JsonKey() final  int discount;
@override@JsonKey() final  int validDays;
@override@JsonKey() final  int deleteDays;
@override@JsonKey() final  int memory;
@override@JsonKey() final  int cpu;
@override@JsonKey() final  int disk;
@override@JsonKey() final  int swap;
@override@JsonKey() final  int io;
@override@JsonKey() final  int backups;
@override@JsonKey() final  int node;
@override@JsonKey() final  int nest;
@override@JsonKey() final  String tagSlug;
@override@JsonKey() final  int egg;
 final  List<int> _allowedEggIds;
@override@JsonKey() List<int> get allowedEggIds {
  if (_allowedEggIds is EqualUnmodifiableListView) return _allowedEggIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allowedEggIds);
}

@override@JsonKey() final  String dockerImage;
@override@JsonKey() final  bool oomDisabled;
@override@JsonKey() final  bool startOnCompletion;

/// Create a copy of AdminProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminProductCopyWith<_AdminProduct> get copyWith => __$AdminProductCopyWithImpl<_AdminProduct>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminProductToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminProduct&&(identical(other.specId, specId) || other.specId == specId)&&(identical(other.wareName, wareName) || other.wareName == wareName)&&(identical(other.wareDescription, wareDescription) || other.wareDescription == wareDescription)&&(identical(other.pricePerMonth, pricePerMonth) || other.pricePerMonth == pricePerMonth)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.validDays, validDays) || other.validDays == validDays)&&(identical(other.deleteDays, deleteDays) || other.deleteDays == deleteDays)&&(identical(other.memory, memory) || other.memory == memory)&&(identical(other.cpu, cpu) || other.cpu == cpu)&&(identical(other.disk, disk) || other.disk == disk)&&(identical(other.swap, swap) || other.swap == swap)&&(identical(other.io, io) || other.io == io)&&(identical(other.backups, backups) || other.backups == backups)&&(identical(other.node, node) || other.node == node)&&(identical(other.nest, nest) || other.nest == nest)&&(identical(other.tagSlug, tagSlug) || other.tagSlug == tagSlug)&&(identical(other.egg, egg) || other.egg == egg)&&const DeepCollectionEquality().equals(other.allowedEggIds, _allowedEggIds)&&(identical(other.dockerImage, dockerImage) || other.dockerImage == dockerImage)&&(identical(other.oomDisabled, oomDisabled) || other.oomDisabled == oomDisabled)&&(identical(other.startOnCompletion, startOnCompletion) || other.startOnCompletion == startOnCompletion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,specId,wareName,wareDescription,pricePerMonth,discount,validDays,deleteDays,memory,cpu,disk,swap,io,backups,node,nest,tagSlug,egg,const DeepCollectionEquality().hash(_allowedEggIds),dockerImage,oomDisabled,startOnCompletion]);
}

@override
String toString() {
    return 'AdminProduct(specId: $specId, wareName: $wareName, wareDescription: $wareDescription, pricePerMonth: $pricePerMonth, discount: $discount, validDays: $validDays, deleteDays: $deleteDays, memory: $memory, cpu: $cpu, disk: $disk, swap: $swap, io: $io, backups: $backups, node: $node, nest: $nest, tagSlug: $tagSlug, egg: $egg, allowedEggIds: $allowedEggIds, dockerImage: $dockerImage, oomDisabled: $oomDisabled, startOnCompletion: $startOnCompletion)';
}


}

/// @nodoc
abstract mixin class _$AdminProductCopyWith<$Res> implements $AdminProductCopyWith<$Res> {
  factory _$AdminProductCopyWith(_AdminProduct value, $Res Function(_AdminProduct) _then) = __$AdminProductCopyWithImpl;
@override @useResult
$Res call({
 String specId, String wareName, String wareDescription, int pricePerMonth, int discount, int validDays, int deleteDays, int memory, int cpu, int disk, int swap, int io, int backups, int node, int nest, String tagSlug, int egg, List<int> allowedEggIds, String dockerImage, bool oomDisabled, bool startOnCompletion
});




}
/// @nodoc
class __$AdminProductCopyWithImpl<$Res>
    implements _$AdminProductCopyWith<$Res> {
  __$AdminProductCopyWithImpl(this._self, this._then);

  final _AdminProduct _self;
  final $Res Function(_AdminProduct) _then;

/// Create a copy of AdminProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? specId = null,Object? wareName = null,Object? wareDescription = null,Object? pricePerMonth = null,Object? discount = null,Object? validDays = null,Object? deleteDays = null,Object? memory = null,Object? cpu = null,Object? disk = null,Object? swap = null,Object? io = null,Object? backups = null,Object? node = null,Object? nest = null,Object? tagSlug = null,Object? egg = null,Object? allowedEggIds = null,Object? dockerImage = null,Object? oomDisabled = null,Object? startOnCompletion = null,}) {
  return _then(_AdminProduct(
specId: null == specId ? _self.specId : specId // ignore: cast_nullable_to_non_nullable
as String,wareName: null == wareName ? _self.wareName : wareName // ignore: cast_nullable_to_non_nullable
as String,wareDescription: null == wareDescription ? _self.wareDescription : wareDescription // ignore: cast_nullable_to_non_nullable
as String,pricePerMonth: null == pricePerMonth ? _self.pricePerMonth : pricePerMonth // ignore: cast_nullable_to_non_nullable
as int,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as int,validDays: null == validDays ? _self.validDays : validDays // ignore: cast_nullable_to_non_nullable
as int,deleteDays: null == deleteDays ? _self.deleteDays : deleteDays // ignore: cast_nullable_to_non_nullable
as int,memory: null == memory ? _self.memory : memory // ignore: cast_nullable_to_non_nullable
as int,cpu: null == cpu ? _self.cpu : cpu // ignore: cast_nullable_to_non_nullable
as int,disk: null == disk ? _self.disk : disk // ignore: cast_nullable_to_non_nullable
as int,swap: null == swap ? _self.swap : swap // ignore: cast_nullable_to_non_nullable
as int,io: null == io ? _self.io : io // ignore: cast_nullable_to_non_nullable
as int,backups: null == backups ? _self.backups : backups // ignore: cast_nullable_to_non_nullable
as int,node: null == node ? _self.node : node // ignore: cast_nullable_to_non_nullable
as int,nest: null == nest ? _self.nest : nest // ignore: cast_nullable_to_non_nullable
as int,tagSlug: null == tagSlug ? _self.tagSlug : tagSlug // ignore: cast_nullable_to_non_nullable
as String,egg: null == egg ? _self.egg : egg // ignore: cast_nullable_to_non_nullable
as int,allowedEggIds: null == allowedEggIds ? _self._allowedEggIds : allowedEggIds // ignore: cast_nullable_to_non_nullable
as List<int>,dockerImage: null == dockerImage ? _self.dockerImage : dockerImage // ignore: cast_nullable_to_non_nullable
as String,oomDisabled: null == oomDisabled ? _self.oomDisabled : oomDisabled // ignore: cast_nullable_to_non_nullable
as bool,startOnCompletion: null == startOnCompletion ? _self.startOnCompletion : startOnCompletion // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ProductInput {

 String get wareName; String get wareDescription; int get cpu; int get disk; int get memory; int get swap; int get io; int get backups; int get nodeId; int get nestId; String get tagSlug; int get eggId; List<int> get allowedEggIds; String get image; int get deleteTime; int get price; int get discount0; int get discount1; int get discount2;/// Used by the single-cycle update path only; creation derives the
/// per-cycle discounts from discount0/1/2.
 int get discount;
/// Create a copy of ProductInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductInputCopyWith<ProductInput> get copyWith => _$ProductInputCopyWithImpl<ProductInput>(this as ProductInput, _$identity);

  /// Serializes this ProductInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProductInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductInput&&(identical(other.wareName, _this.wareName) || other.wareName == _this.wareName)&&(identical(other.wareDescription, _this.wareDescription) || other.wareDescription == _this.wareDescription)&&(identical(other.cpu, _this.cpu) || other.cpu == _this.cpu)&&(identical(other.disk, _this.disk) || other.disk == _this.disk)&&(identical(other.memory, _this.memory) || other.memory == _this.memory)&&(identical(other.swap, _this.swap) || other.swap == _this.swap)&&(identical(other.io, _this.io) || other.io == _this.io)&&(identical(other.backups, _this.backups) || other.backups == _this.backups)&&(identical(other.nodeId, _this.nodeId) || other.nodeId == _this.nodeId)&&(identical(other.nestId, _this.nestId) || other.nestId == _this.nestId)&&(identical(other.tagSlug, _this.tagSlug) || other.tagSlug == _this.tagSlug)&&(identical(other.eggId, _this.eggId) || other.eggId == _this.eggId)&&const DeepCollectionEquality().equals(other.allowedEggIds, _this.allowedEggIds)&&(identical(other.image, _this.image) || other.image == _this.image)&&(identical(other.deleteTime, _this.deleteTime) || other.deleteTime == _this.deleteTime)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.discount0, _this.discount0) || other.discount0 == _this.discount0)&&(identical(other.discount1, _this.discount1) || other.discount1 == _this.discount1)&&(identical(other.discount2, _this.discount2) || other.discount2 == _this.discount2)&&(identical(other.discount, _this.discount) || other.discount == _this.discount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProductInput;
  return Object.hashAll([runtimeType,_this.wareName,_this.wareDescription,_this.cpu,_this.disk,_this.memory,_this.swap,_this.io,_this.backups,_this.nodeId,_this.nestId,_this.tagSlug,_this.eggId,const DeepCollectionEquality().hash(_this.allowedEggIds),_this.image,_this.deleteTime,_this.price,_this.discount0,_this.discount1,_this.discount2,_this.discount]);
}

@override
String toString() {
  final _this = this as ProductInput;
  return 'ProductInput(wareName: ${_this.wareName}, wareDescription: ${_this.wareDescription}, cpu: ${_this.cpu}, disk: ${_this.disk}, memory: ${_this.memory}, swap: ${_this.swap}, io: ${_this.io}, backups: ${_this.backups}, nodeId: ${_this.nodeId}, nestId: ${_this.nestId}, tagSlug: ${_this.tagSlug}, eggId: ${_this.eggId}, allowedEggIds: ${_this.allowedEggIds}, image: ${_this.image}, deleteTime: ${_this.deleteTime}, price: ${_this.price}, discount0: ${_this.discount0}, discount1: ${_this.discount1}, discount2: ${_this.discount2}, discount: ${_this.discount})';
}


}

/// @nodoc
abstract mixin class $ProductInputCopyWith<$Res>  {
  factory $ProductInputCopyWith(ProductInput value, $Res Function(ProductInput) _then) = _$ProductInputCopyWithImpl;
@useResult
$Res call({
 String wareName, String wareDescription, int cpu, int disk, int memory, int swap, int io, int backups, int nodeId, int nestId, String tagSlug, int eggId, List<int> allowedEggIds, String image, int deleteTime, int price, int discount0, int discount1, int discount2, int discount
});




}
/// @nodoc
class _$ProductInputCopyWithImpl<$Res>
    implements $ProductInputCopyWith<$Res> {
  _$ProductInputCopyWithImpl(this._self, this._then);

  final ProductInput _self;
  final $Res Function(ProductInput) _then;

/// Create a copy of ProductInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wareName = null,Object? wareDescription = null,Object? cpu = null,Object? disk = null,Object? memory = null,Object? swap = null,Object? io = null,Object? backups = null,Object? nodeId = null,Object? nestId = null,Object? tagSlug = null,Object? eggId = null,Object? allowedEggIds = null,Object? image = null,Object? deleteTime = null,Object? price = null,Object? discount0 = null,Object? discount1 = null,Object? discount2 = null,Object? discount = null,}) {
  return _then(ProductInput(
wareName: null == wareName ? _self.wareName : wareName // ignore: cast_nullable_to_non_nullable
as String,wareDescription: null == wareDescription ? _self.wareDescription : wareDescription // ignore: cast_nullable_to_non_nullable
as String,cpu: null == cpu ? _self.cpu : cpu // ignore: cast_nullable_to_non_nullable
as int,disk: null == disk ? _self.disk : disk // ignore: cast_nullable_to_non_nullable
as int,memory: null == memory ? _self.memory : memory // ignore: cast_nullable_to_non_nullable
as int,swap: null == swap ? _self.swap : swap // ignore: cast_nullable_to_non_nullable
as int,io: null == io ? _self.io : io // ignore: cast_nullable_to_non_nullable
as int,backups: null == backups ? _self.backups : backups // ignore: cast_nullable_to_non_nullable
as int,nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as int,nestId: null == nestId ? _self.nestId : nestId // ignore: cast_nullable_to_non_nullable
as int,tagSlug: null == tagSlug ? _self.tagSlug : tagSlug // ignore: cast_nullable_to_non_nullable
as String,eggId: null == eggId ? _self.eggId : eggId // ignore: cast_nullable_to_non_nullable
as int,allowedEggIds: null == allowedEggIds ? _self.allowedEggIds : allowedEggIds // ignore: cast_nullable_to_non_nullable
as List<int>,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,deleteTime: null == deleteTime ? _self.deleteTime : deleteTime // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,discount0: null == discount0 ? _self.discount0 : discount0 // ignore: cast_nullable_to_non_nullable
as int,discount1: null == discount1 ? _self.discount1 : discount1 // ignore: cast_nullable_to_non_nullable
as int,discount2: null == discount2 ? _self.discount2 : discount2 // ignore: cast_nullable_to_non_nullable
as int,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductInput].
extension ProductInputPatterns on ProductInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductInput value)  $default,){
final _that = this;
switch (_that) {
case _ProductInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductInput value)?  $default,){
final _that = this;
switch (_that) {
case _ProductInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String wareName,  String wareDescription,  int cpu,  int disk,  int memory,  int swap,  int io,  int backups,  int nodeId,  int nestId,  String tagSlug,  int eggId,  List<int> allowedEggIds,  String image,  int deleteTime,  int price,  int discount0,  int discount1,  int discount2,  int discount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductInput() when $default != null:
return $default(_that.wareName,_that.wareDescription,_that.cpu,_that.disk,_that.memory,_that.swap,_that.io,_that.backups,_that.nodeId,_that.nestId,_that.tagSlug,_that.eggId,_that.allowedEggIds,_that.image,_that.deleteTime,_that.price,_that.discount0,_that.discount1,_that.discount2,_that.discount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String wareName,  String wareDescription,  int cpu,  int disk,  int memory,  int swap,  int io,  int backups,  int nodeId,  int nestId,  String tagSlug,  int eggId,  List<int> allowedEggIds,  String image,  int deleteTime,  int price,  int discount0,  int discount1,  int discount2,  int discount)  $default,) {final _that = this;
switch (_that) {
case _ProductInput():
return $default(_that.wareName,_that.wareDescription,_that.cpu,_that.disk,_that.memory,_that.swap,_that.io,_that.backups,_that.nodeId,_that.nestId,_that.tagSlug,_that.eggId,_that.allowedEggIds,_that.image,_that.deleteTime,_that.price,_that.discount0,_that.discount1,_that.discount2,_that.discount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String wareName,  String wareDescription,  int cpu,  int disk,  int memory,  int swap,  int io,  int backups,  int nodeId,  int nestId,  String tagSlug,  int eggId,  List<int> allowedEggIds,  String image,  int deleteTime,  int price,  int discount0,  int discount1,  int discount2,  int discount)?  $default,) {final _that = this;
switch (_that) {
case _ProductInput() when $default != null:
return $default(_that.wareName,_that.wareDescription,_that.cpu,_that.disk,_that.memory,_that.swap,_that.io,_that.backups,_that.nodeId,_that.nestId,_that.tagSlug,_that.eggId,_that.allowedEggIds,_that.image,_that.deleteTime,_that.price,_that.discount0,_that.discount1,_that.discount2,_that.discount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductInput implements ProductInput {
  const _ProductInput({this.wareName = '', this.wareDescription = '', this.cpu = 0, this.disk = 0, this.memory = 0, this.swap = 0, this.io = 0, this.backups = 0, this.nodeId = 0, this.nestId = 0, this.tagSlug = '', this.eggId = 0,  List<int> allowedEggIds = const <int>[], this.image = '', this.deleteTime = 0, this.price = 0, this.discount0 = 0, this.discount1 = 0, this.discount2 = 0, this.discount = 0}): _allowedEggIds = allowedEggIds;
  factory _ProductInput.fromJson(Map<String, dynamic> json) => _$ProductInputFromJson(json);

@override@JsonKey() final  String wareName;
@override@JsonKey() final  String wareDescription;
@override@JsonKey() final  int cpu;
@override@JsonKey() final  int disk;
@override@JsonKey() final  int memory;
@override@JsonKey() final  int swap;
@override@JsonKey() final  int io;
@override@JsonKey() final  int backups;
@override@JsonKey() final  int nodeId;
@override@JsonKey() final  int nestId;
@override@JsonKey() final  String tagSlug;
@override@JsonKey() final  int eggId;
 final  List<int> _allowedEggIds;
@override@JsonKey() List<int> get allowedEggIds {
  if (_allowedEggIds is EqualUnmodifiableListView) return _allowedEggIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allowedEggIds);
}

@override@JsonKey() final  String image;
@override@JsonKey() final  int deleteTime;
@override@JsonKey() final  int price;
@override@JsonKey() final  int discount0;
@override@JsonKey() final  int discount1;
@override@JsonKey() final  int discount2;
/// Used by the single-cycle update path only; creation derives the
/// per-cycle discounts from discount0/1/2.
@override@JsonKey() final  int discount;

/// Create a copy of ProductInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductInputCopyWith<_ProductInput> get copyWith => __$ProductInputCopyWithImpl<_ProductInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductInputToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductInput&&(identical(other.wareName, wareName) || other.wareName == wareName)&&(identical(other.wareDescription, wareDescription) || other.wareDescription == wareDescription)&&(identical(other.cpu, cpu) || other.cpu == cpu)&&(identical(other.disk, disk) || other.disk == disk)&&(identical(other.memory, memory) || other.memory == memory)&&(identical(other.swap, swap) || other.swap == swap)&&(identical(other.io, io) || other.io == io)&&(identical(other.backups, backups) || other.backups == backups)&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.nestId, nestId) || other.nestId == nestId)&&(identical(other.tagSlug, tagSlug) || other.tagSlug == tagSlug)&&(identical(other.eggId, eggId) || other.eggId == eggId)&&const DeepCollectionEquality().equals(other.allowedEggIds, _allowedEggIds)&&(identical(other.image, image) || other.image == image)&&(identical(other.deleteTime, deleteTime) || other.deleteTime == deleteTime)&&(identical(other.price, price) || other.price == price)&&(identical(other.discount0, discount0) || other.discount0 == discount0)&&(identical(other.discount1, discount1) || other.discount1 == discount1)&&(identical(other.discount2, discount2) || other.discount2 == discount2)&&(identical(other.discount, discount) || other.discount == discount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,wareName,wareDescription,cpu,disk,memory,swap,io,backups,nodeId,nestId,tagSlug,eggId,const DeepCollectionEquality().hash(_allowedEggIds),image,deleteTime,price,discount0,discount1,discount2,discount]);
}

@override
String toString() {
    return 'ProductInput(wareName: $wareName, wareDescription: $wareDescription, cpu: $cpu, disk: $disk, memory: $memory, swap: $swap, io: $io, backups: $backups, nodeId: $nodeId, nestId: $nestId, tagSlug: $tagSlug, eggId: $eggId, allowedEggIds: $allowedEggIds, image: $image, deleteTime: $deleteTime, price: $price, discount0: $discount0, discount1: $discount1, discount2: $discount2, discount: $discount)';
}


}

/// @nodoc
abstract mixin class _$ProductInputCopyWith<$Res> implements $ProductInputCopyWith<$Res> {
  factory _$ProductInputCopyWith(_ProductInput value, $Res Function(_ProductInput) _then) = __$ProductInputCopyWithImpl;
@override @useResult
$Res call({
 String wareName, String wareDescription, int cpu, int disk, int memory, int swap, int io, int backups, int nodeId, int nestId, String tagSlug, int eggId, List<int> allowedEggIds, String image, int deleteTime, int price, int discount0, int discount1, int discount2, int discount
});




}
/// @nodoc
class __$ProductInputCopyWithImpl<$Res>
    implements _$ProductInputCopyWith<$Res> {
  __$ProductInputCopyWithImpl(this._self, this._then);

  final _ProductInput _self;
  final $Res Function(_ProductInput) _then;

/// Create a copy of ProductInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wareName = null,Object? wareDescription = null,Object? cpu = null,Object? disk = null,Object? memory = null,Object? swap = null,Object? io = null,Object? backups = null,Object? nodeId = null,Object? nestId = null,Object? tagSlug = null,Object? eggId = null,Object? allowedEggIds = null,Object? image = null,Object? deleteTime = null,Object? price = null,Object? discount0 = null,Object? discount1 = null,Object? discount2 = null,Object? discount = null,}) {
  return _then(_ProductInput(
wareName: null == wareName ? _self.wareName : wareName // ignore: cast_nullable_to_non_nullable
as String,wareDescription: null == wareDescription ? _self.wareDescription : wareDescription // ignore: cast_nullable_to_non_nullable
as String,cpu: null == cpu ? _self.cpu : cpu // ignore: cast_nullable_to_non_nullable
as int,disk: null == disk ? _self.disk : disk // ignore: cast_nullable_to_non_nullable
as int,memory: null == memory ? _self.memory : memory // ignore: cast_nullable_to_non_nullable
as int,swap: null == swap ? _self.swap : swap // ignore: cast_nullable_to_non_nullable
as int,io: null == io ? _self.io : io // ignore: cast_nullable_to_non_nullable
as int,backups: null == backups ? _self.backups : backups // ignore: cast_nullable_to_non_nullable
as int,nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as int,nestId: null == nestId ? _self.nestId : nestId // ignore: cast_nullable_to_non_nullable
as int,tagSlug: null == tagSlug ? _self.tagSlug : tagSlug // ignore: cast_nullable_to_non_nullable
as String,eggId: null == eggId ? _self.eggId : eggId // ignore: cast_nullable_to_non_nullable
as int,allowedEggIds: null == allowedEggIds ? _self._allowedEggIds : allowedEggIds // ignore: cast_nullable_to_non_nullable
as List<int>,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,deleteTime: null == deleteTime ? _self.deleteTime : deleteTime // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,discount0: null == discount0 ? _self.discount0 : discount0 // ignore: cast_nullable_to_non_nullable
as int,discount1: null == discount1 ? _self.discount1 : discount1 // ignore: cast_nullable_to_non_nullable
as int,discount2: null == discount2 ? _self.discount2 : discount2 // ignore: cast_nullable_to_non_nullable
as int,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PanelTag {

 int get id; String get name; String get slug; int? get legacyNestId;
/// Create a copy of PanelTag
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PanelTagCopyWith<PanelTag> get copyWith => _$PanelTagCopyWithImpl<PanelTag>(this as PanelTag, _$identity);

  /// Serializes this PanelTag to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PanelTag;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PanelTag&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.legacyNestId, _this.legacyNestId) || other.legacyNestId == _this.legacyNestId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PanelTag;
  return Object.hash(runtimeType,_this.id,_this.name,_this.slug,_this.legacyNestId);
}

@override
String toString() {
  final _this = this as PanelTag;
  return 'PanelTag(id: ${_this.id}, name: ${_this.name}, slug: ${_this.slug}, legacyNestId: ${_this.legacyNestId})';
}


}

/// @nodoc
abstract mixin class $PanelTagCopyWith<$Res>  {
  factory $PanelTagCopyWith(PanelTag value, $Res Function(PanelTag) _then) = _$PanelTagCopyWithImpl;
@useResult
$Res call({
 int id, String name, String slug, int? legacyNestId
});




}
/// @nodoc
class _$PanelTagCopyWithImpl<$Res>
    implements $PanelTagCopyWith<$Res> {
  _$PanelTagCopyWithImpl(this._self, this._then);

  final PanelTag _self;
  final $Res Function(PanelTag) _then;

/// Create a copy of PanelTag
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? legacyNestId = freezed,}) {
  return _then(PanelTag(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,legacyNestId: freezed == legacyNestId ? _self.legacyNestId : legacyNestId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PanelTag].
extension PanelTagPatterns on PanelTag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PanelTag value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PanelTag() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PanelTag value)  $default,){
final _that = this;
switch (_that) {
case _PanelTag():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PanelTag value)?  $default,){
final _that = this;
switch (_that) {
case _PanelTag() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String slug,  int? legacyNestId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PanelTag() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.legacyNestId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String slug,  int? legacyNestId)  $default,) {final _that = this;
switch (_that) {
case _PanelTag():
return $default(_that.id,_that.name,_that.slug,_that.legacyNestId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String slug,  int? legacyNestId)?  $default,) {final _that = this;
switch (_that) {
case _PanelTag() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.legacyNestId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PanelTag implements PanelTag {
  const _PanelTag({this.id = 0, this.name = '', this.slug = '', this.legacyNestId});
  factory _PanelTag.fromJson(Map<String, dynamic> json) => _$PanelTagFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String slug;
@override final  int? legacyNestId;

/// Create a copy of PanelTag
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PanelTagCopyWith<_PanelTag> get copyWith => __$PanelTagCopyWithImpl<_PanelTag>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PanelTagToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PanelTag&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.legacyNestId, legacyNestId) || other.legacyNestId == legacyNestId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,slug,legacyNestId);
}

@override
String toString() {
    return 'PanelTag(id: $id, name: $name, slug: $slug, legacyNestId: $legacyNestId)';
}


}

/// @nodoc
abstract mixin class _$PanelTagCopyWith<$Res> implements $PanelTagCopyWith<$Res> {
  factory _$PanelTagCopyWith(_PanelTag value, $Res Function(_PanelTag) _then) = __$PanelTagCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String slug, int? legacyNestId
});




}
/// @nodoc
class __$PanelTagCopyWithImpl<$Res>
    implements _$PanelTagCopyWith<$Res> {
  __$PanelTagCopyWithImpl(this._self, this._then);

  final _PanelTag _self;
  final $Res Function(_PanelTag) _then;

/// Create a copy of PanelTag
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? legacyNestId = freezed,}) {
  return _then(_PanelTag(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,legacyNestId: freezed == legacyNestId ? _self.legacyNestId : legacyNestId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$PanelTagListResponse {

 List<PanelTag> get items;
/// Create a copy of PanelTagListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PanelTagListResponseCopyWith<PanelTagListResponse> get copyWith => _$PanelTagListResponseCopyWithImpl<PanelTagListResponse>(this as PanelTagListResponse, _$identity);

  /// Serializes this PanelTagListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PanelTagListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PanelTagListResponse&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PanelTagListResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as PanelTagListResponse;
  return 'PanelTagListResponse(items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $PanelTagListResponseCopyWith<$Res>  {
  factory $PanelTagListResponseCopyWith(PanelTagListResponse value, $Res Function(PanelTagListResponse) _then) = _$PanelTagListResponseCopyWithImpl;
@useResult
$Res call({
 List<PanelTag> items
});




}
/// @nodoc
class _$PanelTagListResponseCopyWithImpl<$Res>
    implements $PanelTagListResponseCopyWith<$Res> {
  _$PanelTagListResponseCopyWithImpl(this._self, this._then);

  final PanelTagListResponse _self;
  final $Res Function(PanelTagListResponse) _then;

/// Create a copy of PanelTagListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(PanelTagListResponse(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<PanelTag>,
  ));
}

}


/// Adds pattern-matching-related methods to [PanelTagListResponse].
extension PanelTagListResponsePatterns on PanelTagListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PanelTagListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PanelTagListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PanelTagListResponse value)  $default,){
final _that = this;
switch (_that) {
case _PanelTagListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PanelTagListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PanelTagListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PanelTag> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PanelTagListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PanelTag> items)  $default,) {final _that = this;
switch (_that) {
case _PanelTagListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PanelTag> items)?  $default,) {final _that = this;
switch (_that) {
case _PanelTagListResponse() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PanelTagListResponse implements PanelTagListResponse {
  const _PanelTagListResponse({ List<PanelTag> items = const <PanelTag>[]}): _items = items;
  factory _PanelTagListResponse.fromJson(Map<String, dynamic> json) => _$PanelTagListResponseFromJson(json);

 final  List<PanelTag> _items;
@override@JsonKey() List<PanelTag> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of PanelTagListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PanelTagListResponseCopyWith<_PanelTagListResponse> get copyWith => __$PanelTagListResponseCopyWithImpl<_PanelTagListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PanelTagListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PanelTagListResponse&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'PanelTagListResponse(items: $items)';
}


}

/// @nodoc
abstract mixin class _$PanelTagListResponseCopyWith<$Res> implements $PanelTagListResponseCopyWith<$Res> {
  factory _$PanelTagListResponseCopyWith(_PanelTagListResponse value, $Res Function(_PanelTagListResponse) _then) = __$PanelTagListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<PanelTag> items
});




}
/// @nodoc
class __$PanelTagListResponseCopyWithImpl<$Res>
    implements _$PanelTagListResponseCopyWith<$Res> {
  __$PanelTagListResponseCopyWithImpl(this._self, this._then);

  final _PanelTagListResponse _self;
  final $Res Function(_PanelTagListResponse) _then;

/// Create a copy of PanelTagListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_PanelTagListResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PanelTag>,
  ));
}


}


/// @nodoc
mixin _$UpdateProductRequest {

 ProductInput get product;
/// Create a copy of UpdateProductRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProductRequestCopyWith<UpdateProductRequest> get copyWith => _$UpdateProductRequestCopyWithImpl<UpdateProductRequest>(this as UpdateProductRequest, _$identity);

  /// Serializes this UpdateProductRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateProductRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProductRequest&&(identical(other.product, _this.product) || other.product == _this.product));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateProductRequest;
  return Object.hash(runtimeType,_this.product);
}

@override
String toString() {
  final _this = this as UpdateProductRequest;
  return 'UpdateProductRequest(product: ${_this.product})';
}


}

/// @nodoc
abstract mixin class $UpdateProductRequestCopyWith<$Res>  {
  factory $UpdateProductRequestCopyWith(UpdateProductRequest value, $Res Function(UpdateProductRequest) _then) = _$UpdateProductRequestCopyWithImpl;
@useResult
$Res call({
 ProductInput product
});


$ProductInputCopyWith<$Res> get product;

}
/// @nodoc
class _$UpdateProductRequestCopyWithImpl<$Res>
    implements $UpdateProductRequestCopyWith<$Res> {
  _$UpdateProductRequestCopyWithImpl(this._self, this._then);

  final UpdateProductRequest _self;
  final $Res Function(UpdateProductRequest) _then;

/// Create a copy of UpdateProductRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? product = null,}) {
  return _then(UpdateProductRequest(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductInput,
  ));
}
/// Create a copy of UpdateProductRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductInputCopyWith<$Res> get product {
  
  return $ProductInputCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// Adds pattern-matching-related methods to [UpdateProductRequest].
extension UpdateProductRequestPatterns on UpdateProductRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateProductRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateProductRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateProductRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateProductRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateProductRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateProductRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProductInput product)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateProductRequest() when $default != null:
return $default(_that.product);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProductInput product)  $default,) {final _that = this;
switch (_that) {
case _UpdateProductRequest():
return $default(_that.product);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProductInput product)?  $default,) {final _that = this;
switch (_that) {
case _UpdateProductRequest() when $default != null:
return $default(_that.product);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateProductRequest implements UpdateProductRequest {
  const _UpdateProductRequest({required this.product});
  factory _UpdateProductRequest.fromJson(Map<String, dynamic> json) => _$UpdateProductRequestFromJson(json);

@override final  ProductInput product;

/// Create a copy of UpdateProductRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateProductRequestCopyWith<_UpdateProductRequest> get copyWith => __$UpdateProductRequestCopyWithImpl<_UpdateProductRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateProductRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateProductRequest&&(identical(other.product, product) || other.product == product));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,product);
}

@override
String toString() {
    return 'UpdateProductRequest(product: $product)';
}


}

/// @nodoc
abstract mixin class _$UpdateProductRequestCopyWith<$Res> implements $UpdateProductRequestCopyWith<$Res> {
  factory _$UpdateProductRequestCopyWith(_UpdateProductRequest value, $Res Function(_UpdateProductRequest) _then) = __$UpdateProductRequestCopyWithImpl;
@override @useResult
$Res call({
 ProductInput product
});


@override $ProductInputCopyWith<$Res> get product;

}
/// @nodoc
class __$UpdateProductRequestCopyWithImpl<$Res>
    implements _$UpdateProductRequestCopyWith<$Res> {
  __$UpdateProductRequestCopyWithImpl(this._self, this._then);

  final _UpdateProductRequest _self;
  final $Res Function(_UpdateProductRequest) _then;

/// Create a copy of UpdateProductRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? product = null,}) {
  return _then(_UpdateProductRequest(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductInput,
  ));
}

/// Create a copy of UpdateProductRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductInputCopyWith<$Res> get product {
  
  return $ProductInputCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// @nodoc
mixin _$FormField {

/// snake_case, mirroring the legacy HTML form (`ware_name`, `node_id`, ...).
 String get name; String get label; String get description; String get type; bool get required;/// `int`, `String` or `null` depending on [type].
@JsonKey(name: 'default') Object? get defaultValue;
/// Create a copy of FormField
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormFieldCopyWith<FormField> get copyWith => _$FormFieldCopyWithImpl<FormField>(this as FormField, _$identity);

  /// Serializes this FormField to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FormField;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormField&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.required, _this.required) || other.required == _this.required)&&const DeepCollectionEquality().equals(other.defaultValue, _this.defaultValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FormField;
  return Object.hash(runtimeType,_this.name,_this.label,_this.description,_this.type,_this.required,const DeepCollectionEquality().hash(_this.defaultValue));
}

@override
String toString() {
  final _this = this as FormField;
  return 'FormField(name: ${_this.name}, label: ${_this.label}, description: ${_this.description}, type: ${_this.type}, required: ${_this.required}, defaultValue: ${_this.defaultValue})';
}


}

/// @nodoc
abstract mixin class $FormFieldCopyWith<$Res>  {
  factory $FormFieldCopyWith(FormField value, $Res Function(FormField) _then) = _$FormFieldCopyWithImpl;
@useResult
$Res call({
 String name, String label, String description, String type, bool required,@JsonKey(name: 'default') Object? defaultValue
});




}
/// @nodoc
class _$FormFieldCopyWithImpl<$Res>
    implements $FormFieldCopyWith<$Res> {
  _$FormFieldCopyWithImpl(this._self, this._then);

  final FormField _self;
  final $Res Function(FormField) _then;

/// Create a copy of FormField
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? label = null,Object? description = null,Object? type = null,Object? required = null,Object? defaultValue = freezed,}) {
  return _then(FormField(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue ,
  ));
}

}


/// Adds pattern-matching-related methods to [FormField].
extension FormFieldPatterns on FormField {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormField value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormField() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormField value)  $default,){
final _that = this;
switch (_that) {
case _FormField():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormField value)?  $default,){
final _that = this;
switch (_that) {
case _FormField() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String label,  String description,  String type,  bool required, @JsonKey(name: 'default')  Object? defaultValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormField() when $default != null:
return $default(_that.name,_that.label,_that.description,_that.type,_that.required,_that.defaultValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String label,  String description,  String type,  bool required, @JsonKey(name: 'default')  Object? defaultValue)  $default,) {final _that = this;
switch (_that) {
case _FormField():
return $default(_that.name,_that.label,_that.description,_that.type,_that.required,_that.defaultValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String label,  String description,  String type,  bool required, @JsonKey(name: 'default')  Object? defaultValue)?  $default,) {final _that = this;
switch (_that) {
case _FormField() when $default != null:
return $default(_that.name,_that.label,_that.description,_that.type,_that.required,_that.defaultValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormField implements FormField {
  const _FormField({this.name = '', this.label = '', this.description = '', this.type = '', this.required = false, @JsonKey(name: 'default') this.defaultValue});
  factory _FormField.fromJson(Map<String, dynamic> json) => _$FormFieldFromJson(json);

/// snake_case, mirroring the legacy HTML form (`ware_name`, `node_id`, ...).
@override@JsonKey() final  String name;
@override@JsonKey() final  String label;
@override@JsonKey() final  String description;
@override@JsonKey() final  String type;
@override@JsonKey() final  bool required;
/// `int`, `String` or `null` depending on [type].
@override@JsonKey(name: 'default') final  Object? defaultValue;

/// Create a copy of FormField
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormFieldCopyWith<_FormField> get copyWith => __$FormFieldCopyWithImpl<_FormField>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormFieldToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormField&&(identical(other.name, name) || other.name == name)&&(identical(other.label, label) || other.label == label)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.required, required) || other.required == required)&&const DeepCollectionEquality().equals(other.defaultValue, defaultValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,label,description,type,required,const DeepCollectionEquality().hash(defaultValue));
}

@override
String toString() {
    return 'FormField(name: $name, label: $label, description: $description, type: $type, required: $required, defaultValue: $defaultValue)';
}


}

/// @nodoc
abstract mixin class _$FormFieldCopyWith<$Res> implements $FormFieldCopyWith<$Res> {
  factory _$FormFieldCopyWith(_FormField value, $Res Function(_FormField) _then) = __$FormFieldCopyWithImpl;
@override @useResult
$Res call({
 String name, String label, String description, String type, bool required,@JsonKey(name: 'default') Object? defaultValue
});




}
/// @nodoc
class __$FormFieldCopyWithImpl<$Res>
    implements _$FormFieldCopyWith<$Res> {
  __$FormFieldCopyWithImpl(this._self, this._then);

  final _FormField _self;
  final $Res Function(_FormField) _then;

/// Create a copy of FormField
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? label = null,Object? description = null,Object? type = null,Object? required = null,Object? defaultValue = freezed,}) {
  return _then(_FormField(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue ,
  ));
}


}


/// @nodoc
mixin _$KeyTarget {

/// `all`, `balance:all`, `spec:<hex>` or `balance:<amount>`.
 String get target; String get name; String get description;/// The product's lifetime in days. Zero means a balance code; -1 means the
/// target stands for every product at once.
 int get validity;
/// Create a copy of KeyTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KeyTargetCopyWith<KeyTarget> get copyWith => _$KeyTargetCopyWithImpl<KeyTarget>(this as KeyTarget, _$identity);

  /// Serializes this KeyTarget to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as KeyTarget;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KeyTarget&&(identical(other.target, _this.target) || other.target == _this.target)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.validity, _this.validity) || other.validity == _this.validity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as KeyTarget;
  return Object.hash(runtimeType,_this.target,_this.name,_this.description,_this.validity);
}

@override
String toString() {
  final _this = this as KeyTarget;
  return 'KeyTarget(target: ${_this.target}, name: ${_this.name}, description: ${_this.description}, validity: ${_this.validity})';
}


}

/// @nodoc
abstract mixin class $KeyTargetCopyWith<$Res>  {
  factory $KeyTargetCopyWith(KeyTarget value, $Res Function(KeyTarget) _then) = _$KeyTargetCopyWithImpl;
@useResult
$Res call({
 String target, String name, String description, int validity
});




}
/// @nodoc
class _$KeyTargetCopyWithImpl<$Res>
    implements $KeyTargetCopyWith<$Res> {
  _$KeyTargetCopyWithImpl(this._self, this._then);

  final KeyTarget _self;
  final $Res Function(KeyTarget) _then;

/// Create a copy of KeyTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? target = null,Object? name = null,Object? description = null,Object? validity = null,}) {
  return _then(KeyTarget(
target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,validity: null == validity ? _self.validity : validity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [KeyTarget].
extension KeyTargetPatterns on KeyTarget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KeyTarget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KeyTarget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KeyTarget value)  $default,){
final _that = this;
switch (_that) {
case _KeyTarget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KeyTarget value)?  $default,){
final _that = this;
switch (_that) {
case _KeyTarget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String target,  String name,  String description,  int validity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KeyTarget() when $default != null:
return $default(_that.target,_that.name,_that.description,_that.validity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String target,  String name,  String description,  int validity)  $default,) {final _that = this;
switch (_that) {
case _KeyTarget():
return $default(_that.target,_that.name,_that.description,_that.validity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String target,  String name,  String description,  int validity)?  $default,) {final _that = this;
switch (_that) {
case _KeyTarget() when $default != null:
return $default(_that.target,_that.name,_that.description,_that.validity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KeyTarget implements KeyTarget {
  const _KeyTarget({this.target = '', this.name = '', this.description = '', this.validity = 0});
  factory _KeyTarget.fromJson(Map<String, dynamic> json) => _$KeyTargetFromJson(json);

/// `all`, `balance:all`, `spec:<hex>` or `balance:<amount>`.
@override@JsonKey() final  String target;
@override@JsonKey() final  String name;
@override@JsonKey() final  String description;
/// The product's lifetime in days. Zero means a balance code; -1 means the
/// target stands for every product at once.
@override@JsonKey() final  int validity;

/// Create a copy of KeyTarget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KeyTargetCopyWith<_KeyTarget> get copyWith => __$KeyTargetCopyWithImpl<_KeyTarget>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KeyTargetToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KeyTarget&&(identical(other.target, target) || other.target == target)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.validity, validity) || other.validity == validity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,target,name,description,validity);
}

@override
String toString() {
    return 'KeyTarget(target: $target, name: $name, description: $description, validity: $validity)';
}


}

/// @nodoc
abstract mixin class _$KeyTargetCopyWith<$Res> implements $KeyTargetCopyWith<$Res> {
  factory _$KeyTargetCopyWith(_KeyTarget value, $Res Function(_KeyTarget) _then) = __$KeyTargetCopyWithImpl;
@override @useResult
$Res call({
 String target, String name, String description, int validity
});




}
/// @nodoc
class __$KeyTargetCopyWithImpl<$Res>
    implements _$KeyTargetCopyWith<$Res> {
  __$KeyTargetCopyWithImpl(this._self, this._then);

  final _KeyTarget _self;
  final $Res Function(_KeyTarget) _then;

/// Create a copy of KeyTarget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? target = null,Object? name = null,Object? description = null,Object? validity = null,}) {
  return _then(_KeyTarget(
target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,validity: null == validity ? _self.validity : validity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$GenerateKeysRequest {

 String get target; int get amount; int get validityDays;
/// Create a copy of GenerateKeysRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerateKeysRequestCopyWith<GenerateKeysRequest> get copyWith => _$GenerateKeysRequestCopyWithImpl<GenerateKeysRequest>(this as GenerateKeysRequest, _$identity);

  /// Serializes this GenerateKeysRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GenerateKeysRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerateKeysRequest&&(identical(other.target, _this.target) || other.target == _this.target)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.validityDays, _this.validityDays) || other.validityDays == _this.validityDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GenerateKeysRequest;
  return Object.hash(runtimeType,_this.target,_this.amount,_this.validityDays);
}

@override
String toString() {
  final _this = this as GenerateKeysRequest;
  return 'GenerateKeysRequest(target: ${_this.target}, amount: ${_this.amount}, validityDays: ${_this.validityDays})';
}


}

/// @nodoc
abstract mixin class $GenerateKeysRequestCopyWith<$Res>  {
  factory $GenerateKeysRequestCopyWith(GenerateKeysRequest value, $Res Function(GenerateKeysRequest) _then) = _$GenerateKeysRequestCopyWithImpl;
@useResult
$Res call({
 String target, int amount, int validityDays
});




}
/// @nodoc
class _$GenerateKeysRequestCopyWithImpl<$Res>
    implements $GenerateKeysRequestCopyWith<$Res> {
  _$GenerateKeysRequestCopyWithImpl(this._self, this._then);

  final GenerateKeysRequest _self;
  final $Res Function(GenerateKeysRequest) _then;

/// Create a copy of GenerateKeysRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? target = null,Object? amount = null,Object? validityDays = null,}) {
  return _then(GenerateKeysRequest(
target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,validityDays: null == validityDays ? _self.validityDays : validityDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GenerateKeysRequest].
extension GenerateKeysRequestPatterns on GenerateKeysRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenerateKeysRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenerateKeysRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenerateKeysRequest value)  $default,){
final _that = this;
switch (_that) {
case _GenerateKeysRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenerateKeysRequest value)?  $default,){
final _that = this;
switch (_that) {
case _GenerateKeysRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String target,  int amount,  int validityDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenerateKeysRequest() when $default != null:
return $default(_that.target,_that.amount,_that.validityDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String target,  int amount,  int validityDays)  $default,) {final _that = this;
switch (_that) {
case _GenerateKeysRequest():
return $default(_that.target,_that.amount,_that.validityDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String target,  int amount,  int validityDays)?  $default,) {final _that = this;
switch (_that) {
case _GenerateKeysRequest() when $default != null:
return $default(_that.target,_that.amount,_that.validityDays);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GenerateKeysRequest implements GenerateKeysRequest {
  const _GenerateKeysRequest({required this.target, this.amount = 0, this.validityDays = 0});
  factory _GenerateKeysRequest.fromJson(Map<String, dynamic> json) => _$GenerateKeysRequestFromJson(json);

@override final  String target;
@override@JsonKey() final  int amount;
@override@JsonKey() final  int validityDays;

/// Create a copy of GenerateKeysRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenerateKeysRequestCopyWith<_GenerateKeysRequest> get copyWith => __$GenerateKeysRequestCopyWithImpl<_GenerateKeysRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenerateKeysRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenerateKeysRequest&&(identical(other.target, target) || other.target == target)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.validityDays, validityDays) || other.validityDays == validityDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,target,amount,validityDays);
}

@override
String toString() {
    return 'GenerateKeysRequest(target: $target, amount: $amount, validityDays: $validityDays)';
}


}

/// @nodoc
abstract mixin class _$GenerateKeysRequestCopyWith<$Res> implements $GenerateKeysRequestCopyWith<$Res> {
  factory _$GenerateKeysRequestCopyWith(_GenerateKeysRequest value, $Res Function(_GenerateKeysRequest) _then) = __$GenerateKeysRequestCopyWithImpl;
@override @useResult
$Res call({
 String target, int amount, int validityDays
});




}
/// @nodoc
class __$GenerateKeysRequestCopyWithImpl<$Res>
    implements _$GenerateKeysRequestCopyWith<$Res> {
  __$GenerateKeysRequestCopyWithImpl(this._self, this._then);

  final _GenerateKeysRequest _self;
  final $Res Function(_GenerateKeysRequest) _then;

/// Create a copy of GenerateKeysRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? target = null,Object? amount = null,Object? validityDays = null,}) {
  return _then(_GenerateKeysRequest(
target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,validityDays: null == validityDays ? _self.validityDays : validityDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SettingField {

 String get key; String get label; String get description;/// One of `text`, `number`, `bool`.
 String get type;/// Always a string regardless of [type]; the server parses it.
 String get value; bool get secret; bool get configured;
/// Create a copy of SettingField
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingFieldCopyWith<SettingField> get copyWith => _$SettingFieldCopyWithImpl<SettingField>(this as SettingField, _$identity);

  /// Serializes this SettingField to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SettingField;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingField&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.value, _this.value) || other.value == _this.value)&&(identical(other.secret, _this.secret) || other.secret == _this.secret)&&(identical(other.configured, _this.configured) || other.configured == _this.configured));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SettingField;
  return Object.hash(runtimeType,_this.key,_this.label,_this.description,_this.type,_this.value,_this.secret,_this.configured);
}

@override
String toString() {
  final _this = this as SettingField;
  return 'SettingField(key: ${_this.key}, label: ${_this.label}, description: ${_this.description}, type: ${_this.type}, value: ${_this.value}, secret: ${_this.secret}, configured: ${_this.configured})';
}


}

/// @nodoc
abstract mixin class $SettingFieldCopyWith<$Res>  {
  factory $SettingFieldCopyWith(SettingField value, $Res Function(SettingField) _then) = _$SettingFieldCopyWithImpl;
@useResult
$Res call({
 String key, String label, String description, String type, String value, bool secret, bool configured
});




}
/// @nodoc
class _$SettingFieldCopyWithImpl<$Res>
    implements $SettingFieldCopyWith<$Res> {
  _$SettingFieldCopyWithImpl(this._self, this._then);

  final SettingField _self;
  final $Res Function(SettingField) _then;

/// Create a copy of SettingField
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? label = null,Object? description = null,Object? type = null,Object? value = null,Object? secret = null,Object? configured = null,}) {
  return _then(SettingField(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,secret: null == secret ? _self.secret : secret // ignore: cast_nullable_to_non_nullable
as bool,configured: null == configured ? _self.configured : configured // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingField].
extension SettingFieldPatterns on SettingField {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingField value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingField() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingField value)  $default,){
final _that = this;
switch (_that) {
case _SettingField():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingField value)?  $default,){
final _that = this;
switch (_that) {
case _SettingField() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String label,  String description,  String type,  String value,  bool secret,  bool configured)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingField() when $default != null:
return $default(_that.key,_that.label,_that.description,_that.type,_that.value,_that.secret,_that.configured);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String label,  String description,  String type,  String value,  bool secret,  bool configured)  $default,) {final _that = this;
switch (_that) {
case _SettingField():
return $default(_that.key,_that.label,_that.description,_that.type,_that.value,_that.secret,_that.configured);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String label,  String description,  String type,  String value,  bool secret,  bool configured)?  $default,) {final _that = this;
switch (_that) {
case _SettingField() when $default != null:
return $default(_that.key,_that.label,_that.description,_that.type,_that.value,_that.secret,_that.configured);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SettingField implements SettingField {
  const _SettingField({this.key = '', this.label = '', this.description = '', this.type = 'text', this.value = '', this.secret = false, this.configured = false});
  factory _SettingField.fromJson(Map<String, dynamic> json) => _$SettingFieldFromJson(json);

@override@JsonKey() final  String key;
@override@JsonKey() final  String label;
@override@JsonKey() final  String description;
/// One of `text`, `number`, `bool`.
@override@JsonKey() final  String type;
/// Always a string regardless of [type]; the server parses it.
@override@JsonKey() final  String value;
@override@JsonKey() final  bool secret;
@override@JsonKey() final  bool configured;

/// Create a copy of SettingField
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingFieldCopyWith<_SettingField> get copyWith => __$SettingFieldCopyWithImpl<_SettingField>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettingFieldToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingField&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value)&&(identical(other.secret, secret) || other.secret == secret)&&(identical(other.configured, configured) || other.configured == configured));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,label,description,type,value,secret,configured);
}

@override
String toString() {
    return 'SettingField(key: $key, label: $label, description: $description, type: $type, value: $value, secret: $secret, configured: $configured)';
}


}

/// @nodoc
abstract mixin class _$SettingFieldCopyWith<$Res> implements $SettingFieldCopyWith<$Res> {
  factory _$SettingFieldCopyWith(_SettingField value, $Res Function(_SettingField) _then) = __$SettingFieldCopyWithImpl;
@override @useResult
$Res call({
 String key, String label, String description, String type, String value, bool secret, bool configured
});




}
/// @nodoc
class __$SettingFieldCopyWithImpl<$Res>
    implements _$SettingFieldCopyWith<$Res> {
  __$SettingFieldCopyWithImpl(this._self, this._then);

  final _SettingField _self;
  final $Res Function(_SettingField) _then;

/// Create a copy of SettingField
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? label = null,Object? description = null,Object? type = null,Object? value = null,Object? secret = null,Object? configured = null,}) {
  return _then(_SettingField(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,secret: null == secret ? _self.secret : secret // ignore: cast_nullable_to_non_nullable
as bool,configured: null == configured ? _self.configured : configured // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ComponentStatus {

 bool get ok; String get message;
/// Create a copy of ComponentStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComponentStatusCopyWith<ComponentStatus> get copyWith => _$ComponentStatusCopyWithImpl<ComponentStatus>(this as ComponentStatus, _$identity);

  /// Serializes this ComponentStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ComponentStatus;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComponentStatus&&(identical(other.ok, _this.ok) || other.ok == _this.ok)&&(identical(other.message, _this.message) || other.message == _this.message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ComponentStatus;
  return Object.hash(runtimeType,_this.ok,_this.message);
}

@override
String toString() {
  final _this = this as ComponentStatus;
  return 'ComponentStatus(ok: ${_this.ok}, message: ${_this.message})';
}


}

/// @nodoc
abstract mixin class $ComponentStatusCopyWith<$Res>  {
  factory $ComponentStatusCopyWith(ComponentStatus value, $Res Function(ComponentStatus) _then) = _$ComponentStatusCopyWithImpl;
@useResult
$Res call({
 bool ok, String message
});




}
/// @nodoc
class _$ComponentStatusCopyWithImpl<$Res>
    implements $ComponentStatusCopyWith<$Res> {
  _$ComponentStatusCopyWithImpl(this._self, this._then);

  final ComponentStatus _self;
  final $Res Function(ComponentStatus) _then;

/// Create a copy of ComponentStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? message = null,}) {
  return _then(ComponentStatus(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ComponentStatus].
extension ComponentStatusPatterns on ComponentStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComponentStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComponentStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComponentStatus value)  $default,){
final _that = this;
switch (_that) {
case _ComponentStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComponentStatus value)?  $default,){
final _that = this;
switch (_that) {
case _ComponentStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComponentStatus() when $default != null:
return $default(_that.ok,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  String message)  $default,) {final _that = this;
switch (_that) {
case _ComponentStatus():
return $default(_that.ok,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  String message)?  $default,) {final _that = this;
switch (_that) {
case _ComponentStatus() when $default != null:
return $default(_that.ok,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ComponentStatus implements ComponentStatus {
  const _ComponentStatus({this.ok = false, this.message = ''});
  factory _ComponentStatus.fromJson(Map<String, dynamic> json) => _$ComponentStatusFromJson(json);

@override@JsonKey() final  bool ok;
@override@JsonKey() final  String message;

/// Create a copy of ComponentStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComponentStatusCopyWith<_ComponentStatus> get copyWith => __$ComponentStatusCopyWithImpl<_ComponentStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComponentStatusToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComponentStatus&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ok,message);
}

@override
String toString() {
    return 'ComponentStatus(ok: $ok, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ComponentStatusCopyWith<$Res> implements $ComponentStatusCopyWith<$Res> {
  factory _$ComponentStatusCopyWith(_ComponentStatus value, $Res Function(_ComponentStatus) _then) = __$ComponentStatusCopyWithImpl;
@override @useResult
$Res call({
 bool ok, String message
});




}
/// @nodoc
class __$ComponentStatusCopyWithImpl<$Res>
    implements _$ComponentStatusCopyWith<$Res> {
  __$ComponentStatusCopyWithImpl(this._self, this._then);

  final _ComponentStatus _self;
  final $Res Function(_ComponentStatus) _then;

/// Create a copy of ComponentStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? message = null,}) {
  return _then(_ComponentStatus(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Health {

 ComponentStatus get mongo; ComponentStatus get redis; ComponentStatus get pterodactyl; String get version; String get buildTime; String get goVersion;
/// Create a copy of Health
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthCopyWith<Health> get copyWith => _$HealthCopyWithImpl<Health>(this as Health, _$identity);

  /// Serializes this Health to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Health;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Health&&(identical(other.mongo, _this.mongo) || other.mongo == _this.mongo)&&(identical(other.redis, _this.redis) || other.redis == _this.redis)&&(identical(other.pterodactyl, _this.pterodactyl) || other.pterodactyl == _this.pterodactyl)&&(identical(other.version, _this.version) || other.version == _this.version)&&(identical(other.buildTime, _this.buildTime) || other.buildTime == _this.buildTime)&&(identical(other.goVersion, _this.goVersion) || other.goVersion == _this.goVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Health;
  return Object.hash(runtimeType,_this.mongo,_this.redis,_this.pterodactyl,_this.version,_this.buildTime,_this.goVersion);
}

@override
String toString() {
  final _this = this as Health;
  return 'Health(mongo: ${_this.mongo}, redis: ${_this.redis}, pterodactyl: ${_this.pterodactyl}, version: ${_this.version}, buildTime: ${_this.buildTime}, goVersion: ${_this.goVersion})';
}


}

/// @nodoc
abstract mixin class $HealthCopyWith<$Res>  {
  factory $HealthCopyWith(Health value, $Res Function(Health) _then) = _$HealthCopyWithImpl;
@useResult
$Res call({
 ComponentStatus mongo, ComponentStatus redis, ComponentStatus pterodactyl, String version, String buildTime, String goVersion
});


$ComponentStatusCopyWith<$Res> get mongo;$ComponentStatusCopyWith<$Res> get redis;$ComponentStatusCopyWith<$Res> get pterodactyl;

}
/// @nodoc
class _$HealthCopyWithImpl<$Res>
    implements $HealthCopyWith<$Res> {
  _$HealthCopyWithImpl(this._self, this._then);

  final Health _self;
  final $Res Function(Health) _then;

/// Create a copy of Health
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mongo = null,Object? redis = null,Object? pterodactyl = null,Object? version = null,Object? buildTime = null,Object? goVersion = null,}) {
  return _then(Health(
mongo: null == mongo ? _self.mongo : mongo // ignore: cast_nullable_to_non_nullable
as ComponentStatus,redis: null == redis ? _self.redis : redis // ignore: cast_nullable_to_non_nullable
as ComponentStatus,pterodactyl: null == pterodactyl ? _self.pterodactyl : pterodactyl // ignore: cast_nullable_to_non_nullable
as ComponentStatus,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,buildTime: null == buildTime ? _self.buildTime : buildTime // ignore: cast_nullable_to_non_nullable
as String,goVersion: null == goVersion ? _self.goVersion : goVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of Health
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComponentStatusCopyWith<$Res> get mongo {
  
  return $ComponentStatusCopyWith<$Res>(_self.mongo, (value) {
    return _then(_self.copyWith(mongo: value));
  });
}/// Create a copy of Health
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComponentStatusCopyWith<$Res> get redis {
  
  return $ComponentStatusCopyWith<$Res>(_self.redis, (value) {
    return _then(_self.copyWith(redis: value));
  });
}/// Create a copy of Health
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComponentStatusCopyWith<$Res> get pterodactyl {
  
  return $ComponentStatusCopyWith<$Res>(_self.pterodactyl, (value) {
    return _then(_self.copyWith(pterodactyl: value));
  });
}
}


/// Adds pattern-matching-related methods to [Health].
extension HealthPatterns on Health {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Health value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Health() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Health value)  $default,){
final _that = this;
switch (_that) {
case _Health():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Health value)?  $default,){
final _that = this;
switch (_that) {
case _Health() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ComponentStatus mongo,  ComponentStatus redis,  ComponentStatus pterodactyl,  String version,  String buildTime,  String goVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Health() when $default != null:
return $default(_that.mongo,_that.redis,_that.pterodactyl,_that.version,_that.buildTime,_that.goVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ComponentStatus mongo,  ComponentStatus redis,  ComponentStatus pterodactyl,  String version,  String buildTime,  String goVersion)  $default,) {final _that = this;
switch (_that) {
case _Health():
return $default(_that.mongo,_that.redis,_that.pterodactyl,_that.version,_that.buildTime,_that.goVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ComponentStatus mongo,  ComponentStatus redis,  ComponentStatus pterodactyl,  String version,  String buildTime,  String goVersion)?  $default,) {final _that = this;
switch (_that) {
case _Health() when $default != null:
return $default(_that.mongo,_that.redis,_that.pterodactyl,_that.version,_that.buildTime,_that.goVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Health implements Health {
  const _Health({this.mongo = const ComponentStatus(), this.redis = const ComponentStatus(), this.pterodactyl = const ComponentStatus(), this.version = '', this.buildTime = '', this.goVersion = ''});
  factory _Health.fromJson(Map<String, dynamic> json) => _$HealthFromJson(json);

@override@JsonKey() final  ComponentStatus mongo;
@override@JsonKey() final  ComponentStatus redis;
@override@JsonKey() final  ComponentStatus pterodactyl;
@override@JsonKey() final  String version;
@override@JsonKey() final  String buildTime;
@override@JsonKey() final  String goVersion;

/// Create a copy of Health
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthCopyWith<_Health> get copyWith => __$HealthCopyWithImpl<_Health>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Health&&(identical(other.mongo, mongo) || other.mongo == mongo)&&(identical(other.redis, redis) || other.redis == redis)&&(identical(other.pterodactyl, pterodactyl) || other.pterodactyl == pterodactyl)&&(identical(other.version, version) || other.version == version)&&(identical(other.buildTime, buildTime) || other.buildTime == buildTime)&&(identical(other.goVersion, goVersion) || other.goVersion == goVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,mongo,redis,pterodactyl,version,buildTime,goVersion);
}

@override
String toString() {
    return 'Health(mongo: $mongo, redis: $redis, pterodactyl: $pterodactyl, version: $version, buildTime: $buildTime, goVersion: $goVersion)';
}


}

/// @nodoc
abstract mixin class _$HealthCopyWith<$Res> implements $HealthCopyWith<$Res> {
  factory _$HealthCopyWith(_Health value, $Res Function(_Health) _then) = __$HealthCopyWithImpl;
@override @useResult
$Res call({
 ComponentStatus mongo, ComponentStatus redis, ComponentStatus pterodactyl, String version, String buildTime, String goVersion
});


@override $ComponentStatusCopyWith<$Res> get mongo;@override $ComponentStatusCopyWith<$Res> get redis;@override $ComponentStatusCopyWith<$Res> get pterodactyl;

}
/// @nodoc
class __$HealthCopyWithImpl<$Res>
    implements _$HealthCopyWith<$Res> {
  __$HealthCopyWithImpl(this._self, this._then);

  final _Health _self;
  final $Res Function(_Health) _then;

/// Create a copy of Health
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mongo = null,Object? redis = null,Object? pterodactyl = null,Object? version = null,Object? buildTime = null,Object? goVersion = null,}) {
  return _then(_Health(
mongo: null == mongo ? _self.mongo : mongo // ignore: cast_nullable_to_non_nullable
as ComponentStatus,redis: null == redis ? _self.redis : redis // ignore: cast_nullable_to_non_nullable
as ComponentStatus,pterodactyl: null == pterodactyl ? _self.pterodactyl : pterodactyl // ignore: cast_nullable_to_non_nullable
as ComponentStatus,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,buildTime: null == buildTime ? _self.buildTime : buildTime // ignore: cast_nullable_to_non_nullable
as String,goVersion: null == goVersion ? _self.goVersion : goVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of Health
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComponentStatusCopyWith<$Res> get mongo {
  
  return $ComponentStatusCopyWith<$Res>(_self.mongo, (value) {
    return _then(_self.copyWith(mongo: value));
  });
}/// Create a copy of Health
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComponentStatusCopyWith<$Res> get redis {
  
  return $ComponentStatusCopyWith<$Res>(_self.redis, (value) {
    return _then(_self.copyWith(redis: value));
  });
}/// Create a copy of Health
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComponentStatusCopyWith<$Res> get pterodactyl {
  
  return $ComponentStatusCopyWith<$Res>(_self.pterodactyl, (value) {
    return _then(_self.copyWith(pterodactyl: value));
  });
}
}


/// @nodoc
mixin _$HealthResponse {

 Health get health;
/// Create a copy of HealthResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthResponseCopyWith<HealthResponse> get copyWith => _$HealthResponseCopyWithImpl<HealthResponse>(this as HealthResponse, _$identity);

  /// Serializes this HealthResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HealthResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthResponse&&(identical(other.health, _this.health) || other.health == _this.health));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HealthResponse;
  return Object.hash(runtimeType,_this.health);
}

@override
String toString() {
  final _this = this as HealthResponse;
  return 'HealthResponse(health: ${_this.health})';
}


}

/// @nodoc
abstract mixin class $HealthResponseCopyWith<$Res>  {
  factory $HealthResponseCopyWith(HealthResponse value, $Res Function(HealthResponse) _then) = _$HealthResponseCopyWithImpl;
@useResult
$Res call({
 Health health
});


$HealthCopyWith<$Res> get health;

}
/// @nodoc
class _$HealthResponseCopyWithImpl<$Res>
    implements $HealthResponseCopyWith<$Res> {
  _$HealthResponseCopyWithImpl(this._self, this._then);

  final HealthResponse _self;
  final $Res Function(HealthResponse) _then;

/// Create a copy of HealthResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? health = null,}) {
  return _then(HealthResponse(
health: null == health ? _self.health : health // ignore: cast_nullable_to_non_nullable
as Health,
  ));
}
/// Create a copy of HealthResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HealthCopyWith<$Res> get health {
  
  return $HealthCopyWith<$Res>(_self.health, (value) {
    return _then(_self.copyWith(health: value));
  });
}
}


/// Adds pattern-matching-related methods to [HealthResponse].
extension HealthResponsePatterns on HealthResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthResponse value)  $default,){
final _that = this;
switch (_that) {
case _HealthResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthResponse value)?  $default,){
final _that = this;
switch (_that) {
case _HealthResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Health health)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthResponse() when $default != null:
return $default(_that.health);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Health health)  $default,) {final _that = this;
switch (_that) {
case _HealthResponse():
return $default(_that.health);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Health health)?  $default,) {final _that = this;
switch (_that) {
case _HealthResponse() when $default != null:
return $default(_that.health);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthResponse implements HealthResponse {
  const _HealthResponse({required this.health});
  factory _HealthResponse.fromJson(Map<String, dynamic> json) => _$HealthResponseFromJson(json);

@override final  Health health;

/// Create a copy of HealthResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthResponseCopyWith<_HealthResponse> get copyWith => __$HealthResponseCopyWithImpl<_HealthResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthResponse&&(identical(other.health, health) || other.health == health));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,health);
}

@override
String toString() {
    return 'HealthResponse(health: $health)';
}


}

/// @nodoc
abstract mixin class _$HealthResponseCopyWith<$Res> implements $HealthResponseCopyWith<$Res> {
  factory _$HealthResponseCopyWith(_HealthResponse value, $Res Function(_HealthResponse) _then) = __$HealthResponseCopyWithImpl;
@override @useResult
$Res call({
 Health health
});


@override $HealthCopyWith<$Res> get health;

}
/// @nodoc
class __$HealthResponseCopyWithImpl<$Res>
    implements _$HealthResponseCopyWith<$Res> {
  __$HealthResponseCopyWithImpl(this._self, this._then);

  final _HealthResponse _self;
  final $Res Function(_HealthResponse) _then;

/// Create a copy of HealthResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? health = null,}) {
  return _then(_HealthResponse(
health: null == health ? _self.health : health // ignore: cast_nullable_to_non_nullable
as Health,
  ));
}

/// Create a copy of HealthResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HealthCopyWith<$Res> get health {
  
  return $HealthCopyWith<$Res>(_self.health, (value) {
    return _then(_self.copyWith(health: value));
  });
}
}


/// @nodoc
mixin _$AdminSettingsResponse {

 List<SettingField> get fields;
/// Create a copy of AdminSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminSettingsResponseCopyWith<AdminSettingsResponse> get copyWith => _$AdminSettingsResponseCopyWithImpl<AdminSettingsResponse>(this as AdminSettingsResponse, _$identity);

  /// Serializes this AdminSettingsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminSettingsResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminSettingsResponse&&const DeepCollectionEquality().equals(other.fields, _this.fields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminSettingsResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.fields));
}

@override
String toString() {
  final _this = this as AdminSettingsResponse;
  return 'AdminSettingsResponse(fields: ${_this.fields})';
}


}

/// @nodoc
abstract mixin class $AdminSettingsResponseCopyWith<$Res>  {
  factory $AdminSettingsResponseCopyWith(AdminSettingsResponse value, $Res Function(AdminSettingsResponse) _then) = _$AdminSettingsResponseCopyWithImpl;
@useResult
$Res call({
 List<SettingField> fields
});




}
/// @nodoc
class _$AdminSettingsResponseCopyWithImpl<$Res>
    implements $AdminSettingsResponseCopyWith<$Res> {
  _$AdminSettingsResponseCopyWithImpl(this._self, this._then);

  final AdminSettingsResponse _self;
  final $Res Function(AdminSettingsResponse) _then;

/// Create a copy of AdminSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fields = null,}) {
  return _then(AdminSettingsResponse(
fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as List<SettingField>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminSettingsResponse].
extension AdminSettingsResponsePatterns on AdminSettingsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminSettingsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminSettingsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminSettingsResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminSettingsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminSettingsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminSettingsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SettingField> fields)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminSettingsResponse() when $default != null:
return $default(_that.fields);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SettingField> fields)  $default,) {final _that = this;
switch (_that) {
case _AdminSettingsResponse():
return $default(_that.fields);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SettingField> fields)?  $default,) {final _that = this;
switch (_that) {
case _AdminSettingsResponse() when $default != null:
return $default(_that.fields);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminSettingsResponse implements AdminSettingsResponse {
  const _AdminSettingsResponse({ List<SettingField> fields = const <SettingField>[]}): _fields = fields;
  factory _AdminSettingsResponse.fromJson(Map<String, dynamic> json) => _$AdminSettingsResponseFromJson(json);

 final  List<SettingField> _fields;
@override@JsonKey() List<SettingField> get fields {
  if (_fields is EqualUnmodifiableListView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fields);
}


/// Create a copy of AdminSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminSettingsResponseCopyWith<_AdminSettingsResponse> get copyWith => __$AdminSettingsResponseCopyWithImpl<_AdminSettingsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminSettingsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminSettingsResponse&&const DeepCollectionEquality().equals(other.fields, _fields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_fields));
}

@override
String toString() {
    return 'AdminSettingsResponse(fields: $fields)';
}


}

/// @nodoc
abstract mixin class _$AdminSettingsResponseCopyWith<$Res> implements $AdminSettingsResponseCopyWith<$Res> {
  factory _$AdminSettingsResponseCopyWith(_AdminSettingsResponse value, $Res Function(_AdminSettingsResponse) _then) = __$AdminSettingsResponseCopyWithImpl;
@override @useResult
$Res call({
 List<SettingField> fields
});




}
/// @nodoc
class __$AdminSettingsResponseCopyWithImpl<$Res>
    implements _$AdminSettingsResponseCopyWith<$Res> {
  __$AdminSettingsResponseCopyWithImpl(this._self, this._then);

  final _AdminSettingsResponse _self;
  final $Res Function(_AdminSettingsResponse) _then;

/// Create a copy of AdminSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fields = null,}) {
  return _then(_AdminSettingsResponse(
fields: null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as List<SettingField>,
  ));
}


}


/// @nodoc
mixin _$SaveSettingsRequest {

 Map<String, String> get values;
/// Create a copy of SaveSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaveSettingsRequestCopyWith<SaveSettingsRequest> get copyWith => _$SaveSettingsRequestCopyWithImpl<SaveSettingsRequest>(this as SaveSettingsRequest, _$identity);

  /// Serializes this SaveSettingsRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SaveSettingsRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveSettingsRequest&&const DeepCollectionEquality().equals(other.values, _this.values));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SaveSettingsRequest;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.values));
}

@override
String toString() {
  final _this = this as SaveSettingsRequest;
  return 'SaveSettingsRequest(values: ${_this.values})';
}


}

/// @nodoc
abstract mixin class $SaveSettingsRequestCopyWith<$Res>  {
  factory $SaveSettingsRequestCopyWith(SaveSettingsRequest value, $Res Function(SaveSettingsRequest) _then) = _$SaveSettingsRequestCopyWithImpl;
@useResult
$Res call({
 Map<String, String> values
});




}
/// @nodoc
class _$SaveSettingsRequestCopyWithImpl<$Res>
    implements $SaveSettingsRequestCopyWith<$Res> {
  _$SaveSettingsRequestCopyWithImpl(this._self, this._then);

  final SaveSettingsRequest _self;
  final $Res Function(SaveSettingsRequest) _then;

/// Create a copy of SaveSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? values = null,}) {
  return _then(SaveSettingsRequest(
values: null == values ? _self.values : values // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SaveSettingsRequest].
extension SaveSettingsRequestPatterns on SaveSettingsRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaveSettingsRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaveSettingsRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaveSettingsRequest value)  $default,){
final _that = this;
switch (_that) {
case _SaveSettingsRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaveSettingsRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SaveSettingsRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, String> values)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaveSettingsRequest() when $default != null:
return $default(_that.values);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, String> values)  $default,) {final _that = this;
switch (_that) {
case _SaveSettingsRequest():
return $default(_that.values);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, String> values)?  $default,) {final _that = this;
switch (_that) {
case _SaveSettingsRequest() when $default != null:
return $default(_that.values);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaveSettingsRequest implements SaveSettingsRequest {
  const _SaveSettingsRequest({ Map<String, String> values = const <String, String>{}}): _values = values;
  factory _SaveSettingsRequest.fromJson(Map<String, dynamic> json) => _$SaveSettingsRequestFromJson(json);

 final  Map<String, String> _values;
@override@JsonKey() Map<String, String> get values {
  if (_values is EqualUnmodifiableMapView) return _values;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_values);
}


/// Create a copy of SaveSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveSettingsRequestCopyWith<_SaveSettingsRequest> get copyWith => __$SaveSettingsRequestCopyWithImpl<_SaveSettingsRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaveSettingsRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveSettingsRequest&&const DeepCollectionEquality().equals(other.values, _values));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_values));
}

@override
String toString() {
    return 'SaveSettingsRequest(values: $values)';
}


}

/// @nodoc
abstract mixin class _$SaveSettingsRequestCopyWith<$Res> implements $SaveSettingsRequestCopyWith<$Res> {
  factory _$SaveSettingsRequestCopyWith(_SaveSettingsRequest value, $Res Function(_SaveSettingsRequest) _then) = __$SaveSettingsRequestCopyWithImpl;
@override @useResult
$Res call({
 Map<String, String> values
});




}
/// @nodoc
class __$SaveSettingsRequestCopyWithImpl<$Res>
    implements _$SaveSettingsRequestCopyWith<$Res> {
  __$SaveSettingsRequestCopyWithImpl(this._self, this._then);

  final _SaveSettingsRequest _self;
  final $Res Function(_SaveSettingsRequest) _then;

/// Create a copy of SaveSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? values = null,}) {
  return _then(_SaveSettingsRequest(
values: null == values ? _self._values : values // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}


/// @nodoc
mixin _$AdminDashboardResponse {

 Dashboard get dashboard;
/// Create a copy of AdminDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminDashboardResponseCopyWith<AdminDashboardResponse> get copyWith => _$AdminDashboardResponseCopyWithImpl<AdminDashboardResponse>(this as AdminDashboardResponse, _$identity);

  /// Serializes this AdminDashboardResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminDashboardResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminDashboardResponse&&(identical(other.dashboard, _this.dashboard) || other.dashboard == _this.dashboard));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminDashboardResponse;
  return Object.hash(runtimeType,_this.dashboard);
}

@override
String toString() {
  final _this = this as AdminDashboardResponse;
  return 'AdminDashboardResponse(dashboard: ${_this.dashboard})';
}


}

/// @nodoc
abstract mixin class $AdminDashboardResponseCopyWith<$Res>  {
  factory $AdminDashboardResponseCopyWith(AdminDashboardResponse value, $Res Function(AdminDashboardResponse) _then) = _$AdminDashboardResponseCopyWithImpl;
@useResult
$Res call({
 Dashboard dashboard
});


$DashboardCopyWith<$Res> get dashboard;

}
/// @nodoc
class _$AdminDashboardResponseCopyWithImpl<$Res>
    implements $AdminDashboardResponseCopyWith<$Res> {
  _$AdminDashboardResponseCopyWithImpl(this._self, this._then);

  final AdminDashboardResponse _self;
  final $Res Function(AdminDashboardResponse) _then;

/// Create a copy of AdminDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dashboard = null,}) {
  return _then(AdminDashboardResponse(
dashboard: null == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as Dashboard,
  ));
}
/// Create a copy of AdminDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardCopyWith<$Res> get dashboard {
  
  return $DashboardCopyWith<$Res>(_self.dashboard, (value) {
    return _then(_self.copyWith(dashboard: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminDashboardResponse].
extension AdminDashboardResponsePatterns on AdminDashboardResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminDashboardResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminDashboardResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminDashboardResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminDashboardResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminDashboardResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminDashboardResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Dashboard dashboard)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminDashboardResponse() when $default != null:
return $default(_that.dashboard);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Dashboard dashboard)  $default,) {final _that = this;
switch (_that) {
case _AdminDashboardResponse():
return $default(_that.dashboard);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Dashboard dashboard)?  $default,) {final _that = this;
switch (_that) {
case _AdminDashboardResponse() when $default != null:
return $default(_that.dashboard);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminDashboardResponse implements AdminDashboardResponse {
  const _AdminDashboardResponse({required this.dashboard});
  factory _AdminDashboardResponse.fromJson(Map<String, dynamic> json) => _$AdminDashboardResponseFromJson(json);

@override final  Dashboard dashboard;

/// Create a copy of AdminDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminDashboardResponseCopyWith<_AdminDashboardResponse> get copyWith => __$AdminDashboardResponseCopyWithImpl<_AdminDashboardResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminDashboardResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminDashboardResponse&&(identical(other.dashboard, dashboard) || other.dashboard == dashboard));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,dashboard);
}

@override
String toString() {
    return 'AdminDashboardResponse(dashboard: $dashboard)';
}


}

/// @nodoc
abstract mixin class _$AdminDashboardResponseCopyWith<$Res> implements $AdminDashboardResponseCopyWith<$Res> {
  factory _$AdminDashboardResponseCopyWith(_AdminDashboardResponse value, $Res Function(_AdminDashboardResponse) _then) = __$AdminDashboardResponseCopyWithImpl;
@override @useResult
$Res call({
 Dashboard dashboard
});


@override $DashboardCopyWith<$Res> get dashboard;

}
/// @nodoc
class __$AdminDashboardResponseCopyWithImpl<$Res>
    implements _$AdminDashboardResponseCopyWith<$Res> {
  __$AdminDashboardResponseCopyWithImpl(this._self, this._then);

  final _AdminDashboardResponse _self;
  final $Res Function(_AdminDashboardResponse) _then;

/// Create a copy of AdminDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dashboard = null,}) {
  return _then(_AdminDashboardResponse(
dashboard: null == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as Dashboard,
  ));
}

/// Create a copy of AdminDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardCopyWith<$Res> get dashboard {
  
  return $DashboardCopyWith<$Res>(_self.dashboard, (value) {
    return _then(_self.copyWith(dashboard: value));
  });
}
}


/// @nodoc
mixin _$AdminUserListResponse {

 List<AdminUser> get users;
/// Create a copy of AdminUserListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminUserListResponseCopyWith<AdminUserListResponse> get copyWith => _$AdminUserListResponseCopyWithImpl<AdminUserListResponse>(this as AdminUserListResponse, _$identity);

  /// Serializes this AdminUserListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminUserListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminUserListResponse&&const DeepCollectionEquality().equals(other.users, _this.users));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminUserListResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.users));
}

@override
String toString() {
  final _this = this as AdminUserListResponse;
  return 'AdminUserListResponse(users: ${_this.users})';
}


}

/// @nodoc
abstract mixin class $AdminUserListResponseCopyWith<$Res>  {
  factory $AdminUserListResponseCopyWith(AdminUserListResponse value, $Res Function(AdminUserListResponse) _then) = _$AdminUserListResponseCopyWithImpl;
@useResult
$Res call({
 List<AdminUser> users
});




}
/// @nodoc
class _$AdminUserListResponseCopyWithImpl<$Res>
    implements $AdminUserListResponseCopyWith<$Res> {
  _$AdminUserListResponseCopyWithImpl(this._self, this._then);

  final AdminUserListResponse _self;
  final $Res Function(AdminUserListResponse) _then;

/// Create a copy of AdminUserListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? users = null,}) {
  return _then(AdminUserListResponse(
users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<AdminUser>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminUserListResponse].
extension AdminUserListResponsePatterns on AdminUserListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminUserListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminUserListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminUserListResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminUserListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminUserListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminUserListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AdminUser> users)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminUserListResponse() when $default != null:
return $default(_that.users);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AdminUser> users)  $default,) {final _that = this;
switch (_that) {
case _AdminUserListResponse():
return $default(_that.users);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AdminUser> users)?  $default,) {final _that = this;
switch (_that) {
case _AdminUserListResponse() when $default != null:
return $default(_that.users);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminUserListResponse implements AdminUserListResponse {
  const _AdminUserListResponse({ List<AdminUser> users = const <AdminUser>[]}): _users = users;
  factory _AdminUserListResponse.fromJson(Map<String, dynamic> json) => _$AdminUserListResponseFromJson(json);

 final  List<AdminUser> _users;
@override@JsonKey() List<AdminUser> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}


/// Create a copy of AdminUserListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminUserListResponseCopyWith<_AdminUserListResponse> get copyWith => __$AdminUserListResponseCopyWithImpl<_AdminUserListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminUserListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminUserListResponse&&const DeepCollectionEquality().equals(other.users, _users));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_users));
}

@override
String toString() {
    return 'AdminUserListResponse(users: $users)';
}


}

/// @nodoc
abstract mixin class _$AdminUserListResponseCopyWith<$Res> implements $AdminUserListResponseCopyWith<$Res> {
  factory _$AdminUserListResponseCopyWith(_AdminUserListResponse value, $Res Function(_AdminUserListResponse) _then) = __$AdminUserListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<AdminUser> users
});




}
/// @nodoc
class __$AdminUserListResponseCopyWithImpl<$Res>
    implements _$AdminUserListResponseCopyWith<$Res> {
  __$AdminUserListResponseCopyWithImpl(this._self, this._then);

  final _AdminUserListResponse _self;
  final $Res Function(_AdminUserListResponse) _then;

/// Create a copy of AdminUserListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? users = null,}) {
  return _then(_AdminUserListResponse(
users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<AdminUser>,
  ));
}


}


/// @nodoc
mixin _$AdminOrderListResponse {

 List<AdminOrder> get orders;
/// Create a copy of AdminOrderListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminOrderListResponseCopyWith<AdminOrderListResponse> get copyWith => _$AdminOrderListResponseCopyWithImpl<AdminOrderListResponse>(this as AdminOrderListResponse, _$identity);

  /// Serializes this AdminOrderListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminOrderListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminOrderListResponse&&const DeepCollectionEquality().equals(other.orders, _this.orders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminOrderListResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.orders));
}

@override
String toString() {
  final _this = this as AdminOrderListResponse;
  return 'AdminOrderListResponse(orders: ${_this.orders})';
}


}

/// @nodoc
abstract mixin class $AdminOrderListResponseCopyWith<$Res>  {
  factory $AdminOrderListResponseCopyWith(AdminOrderListResponse value, $Res Function(AdminOrderListResponse) _then) = _$AdminOrderListResponseCopyWithImpl;
@useResult
$Res call({
 List<AdminOrder> orders
});




}
/// @nodoc
class _$AdminOrderListResponseCopyWithImpl<$Res>
    implements $AdminOrderListResponseCopyWith<$Res> {
  _$AdminOrderListResponseCopyWithImpl(this._self, this._then);

  final AdminOrderListResponse _self;
  final $Res Function(AdminOrderListResponse) _then;

/// Create a copy of AdminOrderListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orders = null,}) {
  return _then(AdminOrderListResponse(
orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as List<AdminOrder>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminOrderListResponse].
extension AdminOrderListResponsePatterns on AdminOrderListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminOrderListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminOrderListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminOrderListResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminOrderListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminOrderListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminOrderListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AdminOrder> orders)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminOrderListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AdminOrder> orders)  $default,) {final _that = this;
switch (_that) {
case _AdminOrderListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AdminOrder> orders)?  $default,) {final _that = this;
switch (_that) {
case _AdminOrderListResponse() when $default != null:
return $default(_that.orders);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminOrderListResponse implements AdminOrderListResponse {
  const _AdminOrderListResponse({ List<AdminOrder> orders = const <AdminOrder>[]}): _orders = orders;
  factory _AdminOrderListResponse.fromJson(Map<String, dynamic> json) => _$AdminOrderListResponseFromJson(json);

 final  List<AdminOrder> _orders;
@override@JsonKey() List<AdminOrder> get orders {
  if (_orders is EqualUnmodifiableListView) return _orders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orders);
}


/// Create a copy of AdminOrderListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminOrderListResponseCopyWith<_AdminOrderListResponse> get copyWith => __$AdminOrderListResponseCopyWithImpl<_AdminOrderListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminOrderListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminOrderListResponse&&const DeepCollectionEquality().equals(other.orders, _orders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_orders));
}

@override
String toString() {
    return 'AdminOrderListResponse(orders: $orders)';
}


}

/// @nodoc
abstract mixin class _$AdminOrderListResponseCopyWith<$Res> implements $AdminOrderListResponseCopyWith<$Res> {
  factory _$AdminOrderListResponseCopyWith(_AdminOrderListResponse value, $Res Function(_AdminOrderListResponse) _then) = __$AdminOrderListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<AdminOrder> orders
});




}
/// @nodoc
class __$AdminOrderListResponseCopyWithImpl<$Res>
    implements _$AdminOrderListResponseCopyWith<$Res> {
  __$AdminOrderListResponseCopyWithImpl(this._self, this._then);

  final _AdminOrderListResponse _self;
  final $Res Function(_AdminOrderListResponse) _then;

/// Create a copy of AdminOrderListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orders = null,}) {
  return _then(_AdminOrderListResponse(
orders: null == orders ? _self._orders : orders // ignore: cast_nullable_to_non_nullable
as List<AdminOrder>,
  ));
}


}


/// @nodoc
mixin _$AdminProductListResponse {

 List<AdminProduct> get products;
/// Create a copy of AdminProductListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminProductListResponseCopyWith<AdminProductListResponse> get copyWith => _$AdminProductListResponseCopyWithImpl<AdminProductListResponse>(this as AdminProductListResponse, _$identity);

  /// Serializes this AdminProductListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminProductListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminProductListResponse&&const DeepCollectionEquality().equals(other.products, _this.products));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminProductListResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.products));
}

@override
String toString() {
  final _this = this as AdminProductListResponse;
  return 'AdminProductListResponse(products: ${_this.products})';
}


}

/// @nodoc
abstract mixin class $AdminProductListResponseCopyWith<$Res>  {
  factory $AdminProductListResponseCopyWith(AdminProductListResponse value, $Res Function(AdminProductListResponse) _then) = _$AdminProductListResponseCopyWithImpl;
@useResult
$Res call({
 List<AdminProduct> products
});




}
/// @nodoc
class _$AdminProductListResponseCopyWithImpl<$Res>
    implements $AdminProductListResponseCopyWith<$Res> {
  _$AdminProductListResponseCopyWithImpl(this._self, this._then);

  final AdminProductListResponse _self;
  final $Res Function(AdminProductListResponse) _then;

/// Create a copy of AdminProductListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? products = null,}) {
  return _then(AdminProductListResponse(
products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<AdminProduct>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminProductListResponse].
extension AdminProductListResponsePatterns on AdminProductListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminProductListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminProductListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminProductListResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminProductListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminProductListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminProductListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AdminProduct> products)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminProductListResponse() when $default != null:
return $default(_that.products);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AdminProduct> products)  $default,) {final _that = this;
switch (_that) {
case _AdminProductListResponse():
return $default(_that.products);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AdminProduct> products)?  $default,) {final _that = this;
switch (_that) {
case _AdminProductListResponse() when $default != null:
return $default(_that.products);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminProductListResponse implements AdminProductListResponse {
  const _AdminProductListResponse({ List<AdminProduct> products = const <AdminProduct>[]}): _products = products;
  factory _AdminProductListResponse.fromJson(Map<String, dynamic> json) => _$AdminProductListResponseFromJson(json);

 final  List<AdminProduct> _products;
@override@JsonKey() List<AdminProduct> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}


/// Create a copy of AdminProductListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminProductListResponseCopyWith<_AdminProductListResponse> get copyWith => __$AdminProductListResponseCopyWithImpl<_AdminProductListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminProductListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminProductListResponse&&const DeepCollectionEquality().equals(other.products, _products));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_products));
}

@override
String toString() {
    return 'AdminProductListResponse(products: $products)';
}


}

/// @nodoc
abstract mixin class _$AdminProductListResponseCopyWith<$Res> implements $AdminProductListResponseCopyWith<$Res> {
  factory _$AdminProductListResponseCopyWith(_AdminProductListResponse value, $Res Function(_AdminProductListResponse) _then) = __$AdminProductListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<AdminProduct> products
});




}
/// @nodoc
class __$AdminProductListResponseCopyWithImpl<$Res>
    implements _$AdminProductListResponseCopyWith<$Res> {
  __$AdminProductListResponseCopyWithImpl(this._self, this._then);

  final _AdminProductListResponse _self;
  final $Res Function(_AdminProductListResponse) _then;

/// Create a copy of AdminProductListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? products = null,}) {
  return _then(_AdminProductListResponse(
products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<AdminProduct>,
  ));
}


}


/// @nodoc
mixin _$AdminProductFormResponse {

 List<FormField> get fields;
/// Create a copy of AdminProductFormResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminProductFormResponseCopyWith<AdminProductFormResponse> get copyWith => _$AdminProductFormResponseCopyWithImpl<AdminProductFormResponse>(this as AdminProductFormResponse, _$identity);

  /// Serializes this AdminProductFormResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminProductFormResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminProductFormResponse&&const DeepCollectionEquality().equals(other.fields, _this.fields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminProductFormResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.fields));
}

@override
String toString() {
  final _this = this as AdminProductFormResponse;
  return 'AdminProductFormResponse(fields: ${_this.fields})';
}


}

/// @nodoc
abstract mixin class $AdminProductFormResponseCopyWith<$Res>  {
  factory $AdminProductFormResponseCopyWith(AdminProductFormResponse value, $Res Function(AdminProductFormResponse) _then) = _$AdminProductFormResponseCopyWithImpl;
@useResult
$Res call({
 List<FormField> fields
});




}
/// @nodoc
class _$AdminProductFormResponseCopyWithImpl<$Res>
    implements $AdminProductFormResponseCopyWith<$Res> {
  _$AdminProductFormResponseCopyWithImpl(this._self, this._then);

  final AdminProductFormResponse _self;
  final $Res Function(AdminProductFormResponse) _then;

/// Create a copy of AdminProductFormResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fields = null,}) {
  return _then(AdminProductFormResponse(
fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as List<FormField>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminProductFormResponse].
extension AdminProductFormResponsePatterns on AdminProductFormResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminProductFormResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminProductFormResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminProductFormResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminProductFormResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminProductFormResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminProductFormResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<FormField> fields)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminProductFormResponse() when $default != null:
return $default(_that.fields);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<FormField> fields)  $default,) {final _that = this;
switch (_that) {
case _AdminProductFormResponse():
return $default(_that.fields);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<FormField> fields)?  $default,) {final _that = this;
switch (_that) {
case _AdminProductFormResponse() when $default != null:
return $default(_that.fields);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminProductFormResponse implements AdminProductFormResponse {
  const _AdminProductFormResponse({ List<FormField> fields = const <FormField>[]}): _fields = fields;
  factory _AdminProductFormResponse.fromJson(Map<String, dynamic> json) => _$AdminProductFormResponseFromJson(json);

 final  List<FormField> _fields;
@override@JsonKey() List<FormField> get fields {
  if (_fields is EqualUnmodifiableListView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fields);
}


/// Create a copy of AdminProductFormResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminProductFormResponseCopyWith<_AdminProductFormResponse> get copyWith => __$AdminProductFormResponseCopyWithImpl<_AdminProductFormResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminProductFormResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminProductFormResponse&&const DeepCollectionEquality().equals(other.fields, _fields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_fields));
}

@override
String toString() {
    return 'AdminProductFormResponse(fields: $fields)';
}


}

/// @nodoc
abstract mixin class _$AdminProductFormResponseCopyWith<$Res> implements $AdminProductFormResponseCopyWith<$Res> {
  factory _$AdminProductFormResponseCopyWith(_AdminProductFormResponse value, $Res Function(_AdminProductFormResponse) _then) = __$AdminProductFormResponseCopyWithImpl;
@override @useResult
$Res call({
 List<FormField> fields
});




}
/// @nodoc
class __$AdminProductFormResponseCopyWithImpl<$Res>
    implements _$AdminProductFormResponseCopyWith<$Res> {
  __$AdminProductFormResponseCopyWithImpl(this._self, this._then);

  final _AdminProductFormResponse _self;
  final $Res Function(_AdminProductFormResponse) _then;

/// Create a copy of AdminProductFormResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fields = null,}) {
  return _then(_AdminProductFormResponse(
fields: null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as List<FormField>,
  ));
}


}


/// @nodoc
mixin _$AdminWorkOrderListResponse {

 List<WorkOrderItem> get orders;
/// Create a copy of AdminWorkOrderListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminWorkOrderListResponseCopyWith<AdminWorkOrderListResponse> get copyWith => _$AdminWorkOrderListResponseCopyWithImpl<AdminWorkOrderListResponse>(this as AdminWorkOrderListResponse, _$identity);

  /// Serializes this AdminWorkOrderListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminWorkOrderListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminWorkOrderListResponse&&const DeepCollectionEquality().equals(other.orders, _this.orders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminWorkOrderListResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.orders));
}

@override
String toString() {
  final _this = this as AdminWorkOrderListResponse;
  return 'AdminWorkOrderListResponse(orders: ${_this.orders})';
}


}

/// @nodoc
abstract mixin class $AdminWorkOrderListResponseCopyWith<$Res>  {
  factory $AdminWorkOrderListResponseCopyWith(AdminWorkOrderListResponse value, $Res Function(AdminWorkOrderListResponse) _then) = _$AdminWorkOrderListResponseCopyWithImpl;
@useResult
$Res call({
 List<WorkOrderItem> orders
});




}
/// @nodoc
class _$AdminWorkOrderListResponseCopyWithImpl<$Res>
    implements $AdminWorkOrderListResponseCopyWith<$Res> {
  _$AdminWorkOrderListResponseCopyWithImpl(this._self, this._then);

  final AdminWorkOrderListResponse _self;
  final $Res Function(AdminWorkOrderListResponse) _then;

/// Create a copy of AdminWorkOrderListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orders = null,}) {
  return _then(AdminWorkOrderListResponse(
orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as List<WorkOrderItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminWorkOrderListResponse].
extension AdminWorkOrderListResponsePatterns on AdminWorkOrderListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminWorkOrderListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminWorkOrderListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminWorkOrderListResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminWorkOrderListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminWorkOrderListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminWorkOrderListResponse() when $default != null:
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
case _AdminWorkOrderListResponse() when $default != null:
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
case _AdminWorkOrderListResponse():
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
case _AdminWorkOrderListResponse() when $default != null:
return $default(_that.orders);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminWorkOrderListResponse implements AdminWorkOrderListResponse {
  const _AdminWorkOrderListResponse({ List<WorkOrderItem> orders = const <WorkOrderItem>[]}): _orders = orders;
  factory _AdminWorkOrderListResponse.fromJson(Map<String, dynamic> json) => _$AdminWorkOrderListResponseFromJson(json);

 final  List<WorkOrderItem> _orders;
@override@JsonKey() List<WorkOrderItem> get orders {
  if (_orders is EqualUnmodifiableListView) return _orders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orders);
}


/// Create a copy of AdminWorkOrderListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminWorkOrderListResponseCopyWith<_AdminWorkOrderListResponse> get copyWith => __$AdminWorkOrderListResponseCopyWithImpl<_AdminWorkOrderListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminWorkOrderListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminWorkOrderListResponse&&const DeepCollectionEquality().equals(other.orders, _orders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_orders));
}

@override
String toString() {
    return 'AdminWorkOrderListResponse(orders: $orders)';
}


}

/// @nodoc
abstract mixin class _$AdminWorkOrderListResponseCopyWith<$Res> implements $AdminWorkOrderListResponseCopyWith<$Res> {
  factory _$AdminWorkOrderListResponseCopyWith(_AdminWorkOrderListResponse value, $Res Function(_AdminWorkOrderListResponse) _then) = __$AdminWorkOrderListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<WorkOrderItem> orders
});




}
/// @nodoc
class __$AdminWorkOrderListResponseCopyWithImpl<$Res>
    implements _$AdminWorkOrderListResponseCopyWith<$Res> {
  __$AdminWorkOrderListResponseCopyWithImpl(this._self, this._then);

  final _AdminWorkOrderListResponse _self;
  final $Res Function(_AdminWorkOrderListResponse) _then;

/// Create a copy of AdminWorkOrderListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orders = null,}) {
  return _then(_AdminWorkOrderListResponse(
orders: null == orders ? _self._orders : orders // ignore: cast_nullable_to_non_nullable
as List<WorkOrderItem>,
  ));
}


}


/// @nodoc
mixin _$AdminDeleteConfirmListResponse {

 List<DeleteConfirmItem> get confirms;
/// Create a copy of AdminDeleteConfirmListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminDeleteConfirmListResponseCopyWith<AdminDeleteConfirmListResponse> get copyWith => _$AdminDeleteConfirmListResponseCopyWithImpl<AdminDeleteConfirmListResponse>(this as AdminDeleteConfirmListResponse, _$identity);

  /// Serializes this AdminDeleteConfirmListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminDeleteConfirmListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminDeleteConfirmListResponse&&const DeepCollectionEquality().equals(other.confirms, _this.confirms));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminDeleteConfirmListResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.confirms));
}

@override
String toString() {
  final _this = this as AdminDeleteConfirmListResponse;
  return 'AdminDeleteConfirmListResponse(confirms: ${_this.confirms})';
}


}

/// @nodoc
abstract mixin class $AdminDeleteConfirmListResponseCopyWith<$Res>  {
  factory $AdminDeleteConfirmListResponseCopyWith(AdminDeleteConfirmListResponse value, $Res Function(AdminDeleteConfirmListResponse) _then) = _$AdminDeleteConfirmListResponseCopyWithImpl;
@useResult
$Res call({
 List<DeleteConfirmItem> confirms
});




}
/// @nodoc
class _$AdminDeleteConfirmListResponseCopyWithImpl<$Res>
    implements $AdminDeleteConfirmListResponseCopyWith<$Res> {
  _$AdminDeleteConfirmListResponseCopyWithImpl(this._self, this._then);

  final AdminDeleteConfirmListResponse _self;
  final $Res Function(AdminDeleteConfirmListResponse) _then;

/// Create a copy of AdminDeleteConfirmListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? confirms = null,}) {
  return _then(AdminDeleteConfirmListResponse(
confirms: null == confirms ? _self.confirms : confirms // ignore: cast_nullable_to_non_nullable
as List<DeleteConfirmItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminDeleteConfirmListResponse].
extension AdminDeleteConfirmListResponsePatterns on AdminDeleteConfirmListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminDeleteConfirmListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminDeleteConfirmListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminDeleteConfirmListResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminDeleteConfirmListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminDeleteConfirmListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminDeleteConfirmListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DeleteConfirmItem> confirms)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminDeleteConfirmListResponse() when $default != null:
return $default(_that.confirms);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DeleteConfirmItem> confirms)  $default,) {final _that = this;
switch (_that) {
case _AdminDeleteConfirmListResponse():
return $default(_that.confirms);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DeleteConfirmItem> confirms)?  $default,) {final _that = this;
switch (_that) {
case _AdminDeleteConfirmListResponse() when $default != null:
return $default(_that.confirms);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminDeleteConfirmListResponse implements AdminDeleteConfirmListResponse {
  const _AdminDeleteConfirmListResponse({ List<DeleteConfirmItem> confirms = const <DeleteConfirmItem>[]}): _confirms = confirms;
  factory _AdminDeleteConfirmListResponse.fromJson(Map<String, dynamic> json) => _$AdminDeleteConfirmListResponseFromJson(json);

 final  List<DeleteConfirmItem> _confirms;
@override@JsonKey() List<DeleteConfirmItem> get confirms {
  if (_confirms is EqualUnmodifiableListView) return _confirms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_confirms);
}


/// Create a copy of AdminDeleteConfirmListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminDeleteConfirmListResponseCopyWith<_AdminDeleteConfirmListResponse> get copyWith => __$AdminDeleteConfirmListResponseCopyWithImpl<_AdminDeleteConfirmListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminDeleteConfirmListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminDeleteConfirmListResponse&&const DeepCollectionEquality().equals(other.confirms, _confirms));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_confirms));
}

@override
String toString() {
    return 'AdminDeleteConfirmListResponse(confirms: $confirms)';
}


}

/// @nodoc
abstract mixin class _$AdminDeleteConfirmListResponseCopyWith<$Res> implements $AdminDeleteConfirmListResponseCopyWith<$Res> {
  factory _$AdminDeleteConfirmListResponseCopyWith(_AdminDeleteConfirmListResponse value, $Res Function(_AdminDeleteConfirmListResponse) _then) = __$AdminDeleteConfirmListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<DeleteConfirmItem> confirms
});




}
/// @nodoc
class __$AdminDeleteConfirmListResponseCopyWithImpl<$Res>
    implements _$AdminDeleteConfirmListResponseCopyWith<$Res> {
  __$AdminDeleteConfirmListResponseCopyWithImpl(this._self, this._then);

  final _AdminDeleteConfirmListResponse _self;
  final $Res Function(_AdminDeleteConfirmListResponse) _then;

/// Create a copy of AdminDeleteConfirmListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? confirms = null,}) {
  return _then(_AdminDeleteConfirmListResponse(
confirms: null == confirms ? _self._confirms : confirms // ignore: cast_nullable_to_non_nullable
as List<DeleteConfirmItem>,
  ));
}


}


/// @nodoc
mixin _$CreateProductResponse {

 List<String> get specIds;
/// Create a copy of CreateProductResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateProductResponseCopyWith<CreateProductResponse> get copyWith => _$CreateProductResponseCopyWithImpl<CreateProductResponse>(this as CreateProductResponse, _$identity);

  /// Serializes this CreateProductResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateProductResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateProductResponse&&const DeepCollectionEquality().equals(other.specIds, _this.specIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateProductResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.specIds));
}

@override
String toString() {
  final _this = this as CreateProductResponse;
  return 'CreateProductResponse(specIds: ${_this.specIds})';
}


}

/// @nodoc
abstract mixin class $CreateProductResponseCopyWith<$Res>  {
  factory $CreateProductResponseCopyWith(CreateProductResponse value, $Res Function(CreateProductResponse) _then) = _$CreateProductResponseCopyWithImpl;
@useResult
$Res call({
 List<String> specIds
});




}
/// @nodoc
class _$CreateProductResponseCopyWithImpl<$Res>
    implements $CreateProductResponseCopyWith<$Res> {
  _$CreateProductResponseCopyWithImpl(this._self, this._then);

  final CreateProductResponse _self;
  final $Res Function(CreateProductResponse) _then;

/// Create a copy of CreateProductResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? specIds = null,}) {
  return _then(CreateProductResponse(
specIds: null == specIds ? _self.specIds : specIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateProductResponse].
extension CreateProductResponsePatterns on CreateProductResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateProductResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateProductResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateProductResponse value)  $default,){
final _that = this;
switch (_that) {
case _CreateProductResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateProductResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CreateProductResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> specIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateProductResponse() when $default != null:
return $default(_that.specIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> specIds)  $default,) {final _that = this;
switch (_that) {
case _CreateProductResponse():
return $default(_that.specIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> specIds)?  $default,) {final _that = this;
switch (_that) {
case _CreateProductResponse() when $default != null:
return $default(_that.specIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateProductResponse implements CreateProductResponse {
  const _CreateProductResponse({ List<String> specIds = const <String>[]}): _specIds = specIds;
  factory _CreateProductResponse.fromJson(Map<String, dynamic> json) => _$CreateProductResponseFromJson(json);

 final  List<String> _specIds;
@override@JsonKey() List<String> get specIds {
  if (_specIds is EqualUnmodifiableListView) return _specIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_specIds);
}


/// Create a copy of CreateProductResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateProductResponseCopyWith<_CreateProductResponse> get copyWith => __$CreateProductResponseCopyWithImpl<_CreateProductResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateProductResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateProductResponse&&const DeepCollectionEquality().equals(other.specIds, _specIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_specIds));
}

@override
String toString() {
    return 'CreateProductResponse(specIds: $specIds)';
}


}

/// @nodoc
abstract mixin class _$CreateProductResponseCopyWith<$Res> implements $CreateProductResponseCopyWith<$Res> {
  factory _$CreateProductResponseCopyWith(_CreateProductResponse value, $Res Function(_CreateProductResponse) _then) = __$CreateProductResponseCopyWithImpl;
@override @useResult
$Res call({
 List<String> specIds
});




}
/// @nodoc
class __$CreateProductResponseCopyWithImpl<$Res>
    implements _$CreateProductResponseCopyWith<$Res> {
  __$CreateProductResponseCopyWithImpl(this._self, this._then);

  final _CreateProductResponse _self;
  final $Res Function(_CreateProductResponse) _then;

/// Create a copy of CreateProductResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? specIds = null,}) {
  return _then(_CreateProductResponse(
specIds: null == specIds ? _self._specIds : specIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$DeleteConfirmRequest {

/// `true` removes the server; `false` cancels the deletion.
 bool get approve;
/// Create a copy of DeleteConfirmRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteConfirmRequestCopyWith<DeleteConfirmRequest> get copyWith => _$DeleteConfirmRequestCopyWithImpl<DeleteConfirmRequest>(this as DeleteConfirmRequest, _$identity);

  /// Serializes this DeleteConfirmRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeleteConfirmRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteConfirmRequest&&(identical(other.approve, _this.approve) || other.approve == _this.approve));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeleteConfirmRequest;
  return Object.hash(runtimeType,_this.approve);
}

@override
String toString() {
  final _this = this as DeleteConfirmRequest;
  return 'DeleteConfirmRequest(approve: ${_this.approve})';
}


}

/// @nodoc
abstract mixin class $DeleteConfirmRequestCopyWith<$Res>  {
  factory $DeleteConfirmRequestCopyWith(DeleteConfirmRequest value, $Res Function(DeleteConfirmRequest) _then) = _$DeleteConfirmRequestCopyWithImpl;
@useResult
$Res call({
 bool approve
});




}
/// @nodoc
class _$DeleteConfirmRequestCopyWithImpl<$Res>
    implements $DeleteConfirmRequestCopyWith<$Res> {
  _$DeleteConfirmRequestCopyWithImpl(this._self, this._then);

  final DeleteConfirmRequest _self;
  final $Res Function(DeleteConfirmRequest) _then;

/// Create a copy of DeleteConfirmRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? approve = null,}) {
  return _then(DeleteConfirmRequest(
approve: null == approve ? _self.approve : approve // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DeleteConfirmRequest].
extension DeleteConfirmRequestPatterns on DeleteConfirmRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeleteConfirmRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeleteConfirmRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeleteConfirmRequest value)  $default,){
final _that = this;
switch (_that) {
case _DeleteConfirmRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeleteConfirmRequest value)?  $default,){
final _that = this;
switch (_that) {
case _DeleteConfirmRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool approve)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeleteConfirmRequest() when $default != null:
return $default(_that.approve);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool approve)  $default,) {final _that = this;
switch (_that) {
case _DeleteConfirmRequest():
return $default(_that.approve);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool approve)?  $default,) {final _that = this;
switch (_that) {
case _DeleteConfirmRequest() when $default != null:
return $default(_that.approve);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeleteConfirmRequest implements DeleteConfirmRequest {
  const _DeleteConfirmRequest({this.approve = false});
  factory _DeleteConfirmRequest.fromJson(Map<String, dynamic> json) => _$DeleteConfirmRequestFromJson(json);

/// `true` removes the server; `false` cancels the deletion.
@override@JsonKey() final  bool approve;

/// Create a copy of DeleteConfirmRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteConfirmRequestCopyWith<_DeleteConfirmRequest> get copyWith => __$DeleteConfirmRequestCopyWithImpl<_DeleteConfirmRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeleteConfirmRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteConfirmRequest&&(identical(other.approve, approve) || other.approve == approve));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,approve);
}

@override
String toString() {
    return 'DeleteConfirmRequest(approve: $approve)';
}


}

/// @nodoc
abstract mixin class _$DeleteConfirmRequestCopyWith<$Res> implements $DeleteConfirmRequestCopyWith<$Res> {
  factory _$DeleteConfirmRequestCopyWith(_DeleteConfirmRequest value, $Res Function(_DeleteConfirmRequest) _then) = __$DeleteConfirmRequestCopyWithImpl;
@override @useResult
$Res call({
 bool approve
});




}
/// @nodoc
class __$DeleteConfirmRequestCopyWithImpl<$Res>
    implements _$DeleteConfirmRequestCopyWith<$Res> {
  __$DeleteConfirmRequestCopyWithImpl(this._self, this._then);

  final _DeleteConfirmRequest _self;
  final $Res Function(_DeleteConfirmRequest) _then;

/// Create a copy of DeleteConfirmRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? approve = null,}) {
  return _then(_DeleteConfirmRequest(
approve: null == approve ? _self.approve : approve // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$KeyTargetListResponse {

 List<KeyTarget> get targets;
/// Create a copy of KeyTargetListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KeyTargetListResponseCopyWith<KeyTargetListResponse> get copyWith => _$KeyTargetListResponseCopyWithImpl<KeyTargetListResponse>(this as KeyTargetListResponse, _$identity);

  /// Serializes this KeyTargetListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as KeyTargetListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KeyTargetListResponse&&const DeepCollectionEquality().equals(other.targets, _this.targets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as KeyTargetListResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.targets));
}

@override
String toString() {
  final _this = this as KeyTargetListResponse;
  return 'KeyTargetListResponse(targets: ${_this.targets})';
}


}

/// @nodoc
abstract mixin class $KeyTargetListResponseCopyWith<$Res>  {
  factory $KeyTargetListResponseCopyWith(KeyTargetListResponse value, $Res Function(KeyTargetListResponse) _then) = _$KeyTargetListResponseCopyWithImpl;
@useResult
$Res call({
 List<KeyTarget> targets
});




}
/// @nodoc
class _$KeyTargetListResponseCopyWithImpl<$Res>
    implements $KeyTargetListResponseCopyWith<$Res> {
  _$KeyTargetListResponseCopyWithImpl(this._self, this._then);

  final KeyTargetListResponse _self;
  final $Res Function(KeyTargetListResponse) _then;

/// Create a copy of KeyTargetListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? targets = null,}) {
  return _then(KeyTargetListResponse(
targets: null == targets ? _self.targets : targets // ignore: cast_nullable_to_non_nullable
as List<KeyTarget>,
  ));
}

}


/// Adds pattern-matching-related methods to [KeyTargetListResponse].
extension KeyTargetListResponsePatterns on KeyTargetListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KeyTargetListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KeyTargetListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KeyTargetListResponse value)  $default,){
final _that = this;
switch (_that) {
case _KeyTargetListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KeyTargetListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _KeyTargetListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<KeyTarget> targets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KeyTargetListResponse() when $default != null:
return $default(_that.targets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<KeyTarget> targets)  $default,) {final _that = this;
switch (_that) {
case _KeyTargetListResponse():
return $default(_that.targets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<KeyTarget> targets)?  $default,) {final _that = this;
switch (_that) {
case _KeyTargetListResponse() when $default != null:
return $default(_that.targets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KeyTargetListResponse implements KeyTargetListResponse {
  const _KeyTargetListResponse({ List<KeyTarget> targets = const <KeyTarget>[]}): _targets = targets;
  factory _KeyTargetListResponse.fromJson(Map<String, dynamic> json) => _$KeyTargetListResponseFromJson(json);

 final  List<KeyTarget> _targets;
@override@JsonKey() List<KeyTarget> get targets {
  if (_targets is EqualUnmodifiableListView) return _targets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_targets);
}


/// Create a copy of KeyTargetListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KeyTargetListResponseCopyWith<_KeyTargetListResponse> get copyWith => __$KeyTargetListResponseCopyWithImpl<_KeyTargetListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KeyTargetListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KeyTargetListResponse&&const DeepCollectionEquality().equals(other.targets, _targets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_targets));
}

@override
String toString() {
    return 'KeyTargetListResponse(targets: $targets)';
}


}

/// @nodoc
abstract mixin class _$KeyTargetListResponseCopyWith<$Res> implements $KeyTargetListResponseCopyWith<$Res> {
  factory _$KeyTargetListResponseCopyWith(_KeyTargetListResponse value, $Res Function(_KeyTargetListResponse) _then) = __$KeyTargetListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<KeyTarget> targets
});




}
/// @nodoc
class __$KeyTargetListResponseCopyWithImpl<$Res>
    implements _$KeyTargetListResponseCopyWith<$Res> {
  __$KeyTargetListResponseCopyWithImpl(this._self, this._then);

  final _KeyTargetListResponse _self;
  final $Res Function(_KeyTargetListResponse) _then;

/// Create a copy of KeyTargetListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? targets = null,}) {
  return _then(_KeyTargetListResponse(
targets: null == targets ? _self._targets : targets // ignore: cast_nullable_to_non_nullable
as List<KeyTarget>,
  ));
}


}


/// @nodoc
mixin _$CloseWorkOrderRequest {

 String get closeInfo;
/// Create a copy of CloseWorkOrderRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CloseWorkOrderRequestCopyWith<CloseWorkOrderRequest> get copyWith => _$CloseWorkOrderRequestCopyWithImpl<CloseWorkOrderRequest>(this as CloseWorkOrderRequest, _$identity);

  /// Serializes this CloseWorkOrderRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CloseWorkOrderRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CloseWorkOrderRequest&&(identical(other.closeInfo, _this.closeInfo) || other.closeInfo == _this.closeInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CloseWorkOrderRequest;
  return Object.hash(runtimeType,_this.closeInfo);
}

@override
String toString() {
  final _this = this as CloseWorkOrderRequest;
  return 'CloseWorkOrderRequest(closeInfo: ${_this.closeInfo})';
}


}

/// @nodoc
abstract mixin class $CloseWorkOrderRequestCopyWith<$Res>  {
  factory $CloseWorkOrderRequestCopyWith(CloseWorkOrderRequest value, $Res Function(CloseWorkOrderRequest) _then) = _$CloseWorkOrderRequestCopyWithImpl;
@useResult
$Res call({
 String closeInfo
});




}
/// @nodoc
class _$CloseWorkOrderRequestCopyWithImpl<$Res>
    implements $CloseWorkOrderRequestCopyWith<$Res> {
  _$CloseWorkOrderRequestCopyWithImpl(this._self, this._then);

  final CloseWorkOrderRequest _self;
  final $Res Function(CloseWorkOrderRequest) _then;

/// Create a copy of CloseWorkOrderRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? closeInfo = null,}) {
  return _then(CloseWorkOrderRequest(
closeInfo: null == closeInfo ? _self.closeInfo : closeInfo // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CloseWorkOrderRequest].
extension CloseWorkOrderRequestPatterns on CloseWorkOrderRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CloseWorkOrderRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CloseWorkOrderRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CloseWorkOrderRequest value)  $default,){
final _that = this;
switch (_that) {
case _CloseWorkOrderRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CloseWorkOrderRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CloseWorkOrderRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String closeInfo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CloseWorkOrderRequest() when $default != null:
return $default(_that.closeInfo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String closeInfo)  $default,) {final _that = this;
switch (_that) {
case _CloseWorkOrderRequest():
return $default(_that.closeInfo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String closeInfo)?  $default,) {final _that = this;
switch (_that) {
case _CloseWorkOrderRequest() when $default != null:
return $default(_that.closeInfo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CloseWorkOrderRequest implements CloseWorkOrderRequest {
  const _CloseWorkOrderRequest({this.closeInfo = ''});
  factory _CloseWorkOrderRequest.fromJson(Map<String, dynamic> json) => _$CloseWorkOrderRequestFromJson(json);

@override@JsonKey() final  String closeInfo;

/// Create a copy of CloseWorkOrderRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CloseWorkOrderRequestCopyWith<_CloseWorkOrderRequest> get copyWith => __$CloseWorkOrderRequestCopyWithImpl<_CloseWorkOrderRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CloseWorkOrderRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CloseWorkOrderRequest&&(identical(other.closeInfo, closeInfo) || other.closeInfo == closeInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,closeInfo);
}

@override
String toString() {
    return 'CloseWorkOrderRequest(closeInfo: $closeInfo)';
}


}

/// @nodoc
abstract mixin class _$CloseWorkOrderRequestCopyWith<$Res> implements $CloseWorkOrderRequestCopyWith<$Res> {
  factory _$CloseWorkOrderRequestCopyWith(_CloseWorkOrderRequest value, $Res Function(_CloseWorkOrderRequest) _then) = __$CloseWorkOrderRequestCopyWithImpl;
@override @useResult
$Res call({
 String closeInfo
});




}
/// @nodoc
class __$CloseWorkOrderRequestCopyWithImpl<$Res>
    implements _$CloseWorkOrderRequestCopyWith<$Res> {
  __$CloseWorkOrderRequestCopyWithImpl(this._self, this._then);

  final _CloseWorkOrderRequest _self;
  final $Res Function(_CloseWorkOrderRequest) _then;

/// Create a copy of CloseWorkOrderRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? closeInfo = null,}) {
  return _then(_CloseWorkOrderRequest(
closeInfo: null == closeInfo ? _self.closeInfo : closeInfo // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$HealthzResponse {

 bool get ok; bool get mongo; bool get redis; bool get pterodactyl;@JsonKey(name: 'mongo_error') String? get mongoError;@JsonKey(name: 'redis_error') String? get redisError;@JsonKey(name: 'pterodactyl_error') String? get pterodactylError;
/// Create a copy of HealthzResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthzResponseCopyWith<HealthzResponse> get copyWith => _$HealthzResponseCopyWithImpl<HealthzResponse>(this as HealthzResponse, _$identity);

  /// Serializes this HealthzResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HealthzResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthzResponse&&(identical(other.ok, _this.ok) || other.ok == _this.ok)&&(identical(other.mongo, _this.mongo) || other.mongo == _this.mongo)&&(identical(other.redis, _this.redis) || other.redis == _this.redis)&&(identical(other.pterodactyl, _this.pterodactyl) || other.pterodactyl == _this.pterodactyl)&&(identical(other.mongoError, _this.mongoError) || other.mongoError == _this.mongoError)&&(identical(other.redisError, _this.redisError) || other.redisError == _this.redisError)&&(identical(other.pterodactylError, _this.pterodactylError) || other.pterodactylError == _this.pterodactylError));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HealthzResponse;
  return Object.hash(runtimeType,_this.ok,_this.mongo,_this.redis,_this.pterodactyl,_this.mongoError,_this.redisError,_this.pterodactylError);
}

@override
String toString() {
  final _this = this as HealthzResponse;
  return 'HealthzResponse(ok: ${_this.ok}, mongo: ${_this.mongo}, redis: ${_this.redis}, pterodactyl: ${_this.pterodactyl}, mongoError: ${_this.mongoError}, redisError: ${_this.redisError}, pterodactylError: ${_this.pterodactylError})';
}


}

/// @nodoc
abstract mixin class $HealthzResponseCopyWith<$Res>  {
  factory $HealthzResponseCopyWith(HealthzResponse value, $Res Function(HealthzResponse) _then) = _$HealthzResponseCopyWithImpl;
@useResult
$Res call({
 bool ok, bool mongo, bool redis, bool pterodactyl,@JsonKey(name: 'mongo_error') String? mongoError,@JsonKey(name: 'redis_error') String? redisError,@JsonKey(name: 'pterodactyl_error') String? pterodactylError
});




}
/// @nodoc
class _$HealthzResponseCopyWithImpl<$Res>
    implements $HealthzResponseCopyWith<$Res> {
  _$HealthzResponseCopyWithImpl(this._self, this._then);

  final HealthzResponse _self;
  final $Res Function(HealthzResponse) _then;

/// Create a copy of HealthzResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? mongo = null,Object? redis = null,Object? pterodactyl = null,Object? mongoError = freezed,Object? redisError = freezed,Object? pterodactylError = freezed,}) {
  return _then(HealthzResponse(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,mongo: null == mongo ? _self.mongo : mongo // ignore: cast_nullable_to_non_nullable
as bool,redis: null == redis ? _self.redis : redis // ignore: cast_nullable_to_non_nullable
as bool,pterodactyl: null == pterodactyl ? _self.pterodactyl : pterodactyl // ignore: cast_nullable_to_non_nullable
as bool,mongoError: freezed == mongoError ? _self.mongoError : mongoError // ignore: cast_nullable_to_non_nullable
as String?,redisError: freezed == redisError ? _self.redisError : redisError // ignore: cast_nullable_to_non_nullable
as String?,pterodactylError: freezed == pterodactylError ? _self.pterodactylError : pterodactylError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthzResponse].
extension HealthzResponsePatterns on HealthzResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthzResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthzResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthzResponse value)  $default,){
final _that = this;
switch (_that) {
case _HealthzResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthzResponse value)?  $default,){
final _that = this;
switch (_that) {
case _HealthzResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  bool mongo,  bool redis,  bool pterodactyl, @JsonKey(name: 'mongo_error')  String? mongoError, @JsonKey(name: 'redis_error')  String? redisError, @JsonKey(name: 'pterodactyl_error')  String? pterodactylError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthzResponse() when $default != null:
return $default(_that.ok,_that.mongo,_that.redis,_that.pterodactyl,_that.mongoError,_that.redisError,_that.pterodactylError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  bool mongo,  bool redis,  bool pterodactyl, @JsonKey(name: 'mongo_error')  String? mongoError, @JsonKey(name: 'redis_error')  String? redisError, @JsonKey(name: 'pterodactyl_error')  String? pterodactylError)  $default,) {final _that = this;
switch (_that) {
case _HealthzResponse():
return $default(_that.ok,_that.mongo,_that.redis,_that.pterodactyl,_that.mongoError,_that.redisError,_that.pterodactylError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  bool mongo,  bool redis,  bool pterodactyl, @JsonKey(name: 'mongo_error')  String? mongoError, @JsonKey(name: 'redis_error')  String? redisError, @JsonKey(name: 'pterodactyl_error')  String? pterodactylError)?  $default,) {final _that = this;
switch (_that) {
case _HealthzResponse() when $default != null:
return $default(_that.ok,_that.mongo,_that.redis,_that.pterodactyl,_that.mongoError,_that.redisError,_that.pterodactylError);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthzResponse implements HealthzResponse {
  const _HealthzResponse({this.ok = false, this.mongo = false, this.redis = false, this.pterodactyl = false, @JsonKey(name: 'mongo_error') this.mongoError, @JsonKey(name: 'redis_error') this.redisError, @JsonKey(name: 'pterodactyl_error') this.pterodactylError});
  factory _HealthzResponse.fromJson(Map<String, dynamic> json) => _$HealthzResponseFromJson(json);

@override@JsonKey() final  bool ok;
@override@JsonKey() final  bool mongo;
@override@JsonKey() final  bool redis;
@override@JsonKey() final  bool pterodactyl;
@override@JsonKey(name: 'mongo_error') final  String? mongoError;
@override@JsonKey(name: 'redis_error') final  String? redisError;
@override@JsonKey(name: 'pterodactyl_error') final  String? pterodactylError;

/// Create a copy of HealthzResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthzResponseCopyWith<_HealthzResponse> get copyWith => __$HealthzResponseCopyWithImpl<_HealthzResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthzResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthzResponse&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.mongo, mongo) || other.mongo == mongo)&&(identical(other.redis, redis) || other.redis == redis)&&(identical(other.pterodactyl, pterodactyl) || other.pterodactyl == pterodactyl)&&(identical(other.mongoError, mongoError) || other.mongoError == mongoError)&&(identical(other.redisError, redisError) || other.redisError == redisError)&&(identical(other.pterodactylError, pterodactylError) || other.pterodactylError == pterodactylError));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ok,mongo,redis,pterodactyl,mongoError,redisError,pterodactylError);
}

@override
String toString() {
    return 'HealthzResponse(ok: $ok, mongo: $mongo, redis: $redis, pterodactyl: $pterodactyl, mongoError: $mongoError, redisError: $redisError, pterodactylError: $pterodactylError)';
}


}

/// @nodoc
abstract mixin class _$HealthzResponseCopyWith<$Res> implements $HealthzResponseCopyWith<$Res> {
  factory _$HealthzResponseCopyWith(_HealthzResponse value, $Res Function(_HealthzResponse) _then) = __$HealthzResponseCopyWithImpl;
@override @useResult
$Res call({
 bool ok, bool mongo, bool redis, bool pterodactyl,@JsonKey(name: 'mongo_error') String? mongoError,@JsonKey(name: 'redis_error') String? redisError,@JsonKey(name: 'pterodactyl_error') String? pterodactylError
});




}
/// @nodoc
class __$HealthzResponseCopyWithImpl<$Res>
    implements _$HealthzResponseCopyWith<$Res> {
  __$HealthzResponseCopyWithImpl(this._self, this._then);

  final _HealthzResponse _self;
  final $Res Function(_HealthzResponse) _then;

/// Create a copy of HealthzResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? mongo = null,Object? redis = null,Object? pterodactyl = null,Object? mongoError = freezed,Object? redisError = freezed,Object? pterodactylError = freezed,}) {
  return _then(_HealthzResponse(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,mongo: null == mongo ? _self.mongo : mongo // ignore: cast_nullable_to_non_nullable
as bool,redis: null == redis ? _self.redis : redis // ignore: cast_nullable_to_non_nullable
as bool,pterodactyl: null == pterodactyl ? _self.pterodactyl : pterodactyl // ignore: cast_nullable_to_non_nullable
as bool,mongoError: freezed == mongoError ? _self.mongoError : mongoError // ignore: cast_nullable_to_non_nullable
as String?,redisError: freezed == redisError ? _self.redisError : redisError // ignore: cast_nullable_to_non_nullable
as String?,pterodactylError: freezed == pterodactylError ? _self.pterodactylError : pterodactylError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
