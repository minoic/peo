// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'documents.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

 String? get id; String? get createdAt; String? get updatedAt; String get name; String get email; int get balance; bool get isAdmin; bool get emailConfirmed; bool get pteUserCreated; int get totalUpTime; String get uuid;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as User;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.balance, _this.balance) || other.balance == _this.balance)&&(identical(other.isAdmin, _this.isAdmin) || other.isAdmin == _this.isAdmin)&&(identical(other.emailConfirmed, _this.emailConfirmed) || other.emailConfirmed == _this.emailConfirmed)&&(identical(other.pteUserCreated, _this.pteUserCreated) || other.pteUserCreated == _this.pteUserCreated)&&(identical(other.totalUpTime, _this.totalUpTime) || other.totalUpTime == _this.totalUpTime)&&(identical(other.uuid, _this.uuid) || other.uuid == _this.uuid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as User;
  return Object.hash(runtimeType,_this.id,_this.createdAt,_this.updatedAt,_this.name,_this.email,_this.balance,_this.isAdmin,_this.emailConfirmed,_this.pteUserCreated,_this.totalUpTime,_this.uuid);
}

@override
String toString() {
  final _this = this as User;
  return 'User(id: ${_this.id}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, name: ${_this.name}, email: ${_this.email}, balance: ${_this.balance}, isAdmin: ${_this.isAdmin}, emailConfirmed: ${_this.emailConfirmed}, pteUserCreated: ${_this.pteUserCreated}, totalUpTime: ${_this.totalUpTime}, uuid: ${_this.uuid})';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String? id, String? createdAt, String? updatedAt, String name, String email, int balance, bool isAdmin, bool emailConfirmed, bool pteUserCreated, int totalUpTime, String uuid
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? name = null,Object? email = null,Object? balance = null,Object? isAdmin = null,Object? emailConfirmed = null,Object? pteUserCreated = null,Object? totalUpTime = null,Object? uuid = null,}) {
  return _then(User(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,emailConfirmed: null == emailConfirmed ? _self.emailConfirmed : emailConfirmed // ignore: cast_nullable_to_non_nullable
as bool,pteUserCreated: null == pteUserCreated ? _self.pteUserCreated : pteUserCreated // ignore: cast_nullable_to_non_nullable
as bool,totalUpTime: null == totalUpTime ? _self.totalUpTime : totalUpTime // ignore: cast_nullable_to_non_nullable
as int,uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? createdAt,  String? updatedAt,  String name,  String email,  int balance,  bool isAdmin,  bool emailConfirmed,  bool pteUserCreated,  int totalUpTime,  String uuid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.name,_that.email,_that.balance,_that.isAdmin,_that.emailConfirmed,_that.pteUserCreated,_that.totalUpTime,_that.uuid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? createdAt,  String? updatedAt,  String name,  String email,  int balance,  bool isAdmin,  bool emailConfirmed,  bool pteUserCreated,  int totalUpTime,  String uuid)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.name,_that.email,_that.balance,_that.isAdmin,_that.emailConfirmed,_that.pteUserCreated,_that.totalUpTime,_that.uuid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? createdAt,  String? updatedAt,  String name,  String email,  int balance,  bool isAdmin,  bool emailConfirmed,  bool pteUserCreated,  int totalUpTime,  String uuid)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.name,_that.email,_that.balance,_that.isAdmin,_that.emailConfirmed,_that.pteUserCreated,_that.totalUpTime,_that.uuid);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User extends User {
  const _User({this.id, this.createdAt, this.updatedAt, required this.name, required this.email, this.balance = 0, this.isAdmin = false, this.emailConfirmed = false, this.pteUserCreated = false, this.totalUpTime = 0, this.uuid = ''}): super._();
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  String? id;
@override final  String? createdAt;
@override final  String? updatedAt;
@override final  String name;
@override final  String email;
@override@JsonKey() final  int balance;
@override@JsonKey() final  bool isAdmin;
@override@JsonKey() final  bool emailConfirmed;
@override@JsonKey() final  bool pteUserCreated;
@override@JsonKey() final  int totalUpTime;
@override@JsonKey() final  String uuid;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.emailConfirmed, emailConfirmed) || other.emailConfirmed == emailConfirmed)&&(identical(other.pteUserCreated, pteUserCreated) || other.pteUserCreated == pteUserCreated)&&(identical(other.totalUpTime, totalUpTime) || other.totalUpTime == totalUpTime)&&(identical(other.uuid, uuid) || other.uuid == uuid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,createdAt,updatedAt,name,email,balance,isAdmin,emailConfirmed,pteUserCreated,totalUpTime,uuid);
}

@override
String toString() {
    return 'User(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, name: $name, email: $email, balance: $balance, isAdmin: $isAdmin, emailConfirmed: $emailConfirmed, pteUserCreated: $pteUserCreated, totalUpTime: $totalUpTime, uuid: $uuid)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? createdAt, String? updatedAt, String name, String email, int balance, bool isAdmin, bool emailConfirmed, bool pteUserCreated, int totalUpTime, String uuid
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? name = null,Object? email = null,Object? balance = null,Object? isAdmin = null,Object? emailConfirmed = null,Object? pteUserCreated = null,Object? totalUpTime = null,Object? uuid = null,}) {
  return _then(_User(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,emailConfirmed: null == emailConfirmed ? _self.emailConfirmed : emailConfirmed // ignore: cast_nullable_to_non_nullable
as bool,pteUserCreated: null == pteUserCreated ? _self.pteUserCreated : pteUserCreated // ignore: cast_nullable_to_non_nullable
as bool,totalUpTime: null == totalUpTime ? _self.totalUpTime : totalUpTime // ignore: cast_nullable_to_non_nullable
as int,uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$WareSpec {

 String? get id; String? get createdAt; String? get updatedAt; int get pricePerMonth; String get wareName; String get wareDescription; int get node; int get memory; int get cpu; int get swap; int get disk; int get io; int get backups; int get nest; String get tagSlug; int get egg; List<int> get allowedEggIds; int get discount; bool get startOnCompletion; bool get oomDisabled; String get dockerImage; int get validDuration; int get deleteDuration;
/// Create a copy of WareSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WareSpecCopyWith<WareSpec> get copyWith => _$WareSpecCopyWithImpl<WareSpec>(this as WareSpec, _$identity);

  /// Serializes this WareSpec to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WareSpec;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WareSpec&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.pricePerMonth, _this.pricePerMonth) || other.pricePerMonth == _this.pricePerMonth)&&(identical(other.wareName, _this.wareName) || other.wareName == _this.wareName)&&(identical(other.wareDescription, _this.wareDescription) || other.wareDescription == _this.wareDescription)&&(identical(other.node, _this.node) || other.node == _this.node)&&(identical(other.memory, _this.memory) || other.memory == _this.memory)&&(identical(other.cpu, _this.cpu) || other.cpu == _this.cpu)&&(identical(other.swap, _this.swap) || other.swap == _this.swap)&&(identical(other.disk, _this.disk) || other.disk == _this.disk)&&(identical(other.io, _this.io) || other.io == _this.io)&&(identical(other.backups, _this.backups) || other.backups == _this.backups)&&(identical(other.nest, _this.nest) || other.nest == _this.nest)&&(identical(other.tagSlug, _this.tagSlug) || other.tagSlug == _this.tagSlug)&&(identical(other.egg, _this.egg) || other.egg == _this.egg)&&const DeepCollectionEquality().equals(other.allowedEggIds, _this.allowedEggIds)&&(identical(other.discount, _this.discount) || other.discount == _this.discount)&&(identical(other.startOnCompletion, _this.startOnCompletion) || other.startOnCompletion == _this.startOnCompletion)&&(identical(other.oomDisabled, _this.oomDisabled) || other.oomDisabled == _this.oomDisabled)&&(identical(other.dockerImage, _this.dockerImage) || other.dockerImage == _this.dockerImage)&&(identical(other.validDuration, _this.validDuration) || other.validDuration == _this.validDuration)&&(identical(other.deleteDuration, _this.deleteDuration) || other.deleteDuration == _this.deleteDuration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WareSpec;
  return Object.hashAll([runtimeType,_this.id,_this.createdAt,_this.updatedAt,_this.pricePerMonth,_this.wareName,_this.wareDescription,_this.node,_this.memory,_this.cpu,_this.swap,_this.disk,_this.io,_this.backups,_this.nest,_this.tagSlug,_this.egg,const DeepCollectionEquality().hash(_this.allowedEggIds),_this.discount,_this.startOnCompletion,_this.oomDisabled,_this.dockerImage,_this.validDuration,_this.deleteDuration]);
}

@override
String toString() {
  final _this = this as WareSpec;
  return 'WareSpec(id: ${_this.id}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, pricePerMonth: ${_this.pricePerMonth}, wareName: ${_this.wareName}, wareDescription: ${_this.wareDescription}, node: ${_this.node}, memory: ${_this.memory}, cpu: ${_this.cpu}, swap: ${_this.swap}, disk: ${_this.disk}, io: ${_this.io}, backups: ${_this.backups}, nest: ${_this.nest}, tagSlug: ${_this.tagSlug}, egg: ${_this.egg}, allowedEggIds: ${_this.allowedEggIds}, discount: ${_this.discount}, startOnCompletion: ${_this.startOnCompletion}, oomDisabled: ${_this.oomDisabled}, dockerImage: ${_this.dockerImage}, validDuration: ${_this.validDuration}, deleteDuration: ${_this.deleteDuration})';
}


}

/// @nodoc
abstract mixin class $WareSpecCopyWith<$Res>  {
  factory $WareSpecCopyWith(WareSpec value, $Res Function(WareSpec) _then) = _$WareSpecCopyWithImpl;
@useResult
$Res call({
 String? id, String? createdAt, String? updatedAt, int pricePerMonth, String wareName, String wareDescription, int node, int memory, int cpu, int swap, int disk, int io, int backups, int nest, String tagSlug, int egg, List<int> allowedEggIds, int discount, bool startOnCompletion, bool oomDisabled, String dockerImage, int validDuration, int deleteDuration
});




}
/// @nodoc
class _$WareSpecCopyWithImpl<$Res>
    implements $WareSpecCopyWith<$Res> {
  _$WareSpecCopyWithImpl(this._self, this._then);

  final WareSpec _self;
  final $Res Function(WareSpec) _then;

/// Create a copy of WareSpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? pricePerMonth = null,Object? wareName = null,Object? wareDescription = null,Object? node = null,Object? memory = null,Object? cpu = null,Object? swap = null,Object? disk = null,Object? io = null,Object? backups = null,Object? nest = null,Object? tagSlug = null,Object? egg = null,Object? allowedEggIds = null,Object? discount = null,Object? startOnCompletion = null,Object? oomDisabled = null,Object? dockerImage = null,Object? validDuration = null,Object? deleteDuration = null,}) {
  return _then(WareSpec(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,pricePerMonth: null == pricePerMonth ? _self.pricePerMonth : pricePerMonth // ignore: cast_nullable_to_non_nullable
as int,wareName: null == wareName ? _self.wareName : wareName // ignore: cast_nullable_to_non_nullable
as String,wareDescription: null == wareDescription ? _self.wareDescription : wareDescription // ignore: cast_nullable_to_non_nullable
as String,node: null == node ? _self.node : node // ignore: cast_nullable_to_non_nullable
as int,memory: null == memory ? _self.memory : memory // ignore: cast_nullable_to_non_nullable
as int,cpu: null == cpu ? _self.cpu : cpu // ignore: cast_nullable_to_non_nullable
as int,swap: null == swap ? _self.swap : swap // ignore: cast_nullable_to_non_nullable
as int,disk: null == disk ? _self.disk : disk // ignore: cast_nullable_to_non_nullable
as int,io: null == io ? _self.io : io // ignore: cast_nullable_to_non_nullable
as int,backups: null == backups ? _self.backups : backups // ignore: cast_nullable_to_non_nullable
as int,nest: null == nest ? _self.nest : nest // ignore: cast_nullable_to_non_nullable
as int,tagSlug: null == tagSlug ? _self.tagSlug : tagSlug // ignore: cast_nullable_to_non_nullable
as String,egg: null == egg ? _self.egg : egg // ignore: cast_nullable_to_non_nullable
as int,allowedEggIds: null == allowedEggIds ? _self.allowedEggIds : allowedEggIds // ignore: cast_nullable_to_non_nullable
as List<int>,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as int,startOnCompletion: null == startOnCompletion ? _self.startOnCompletion : startOnCompletion // ignore: cast_nullable_to_non_nullable
as bool,oomDisabled: null == oomDisabled ? _self.oomDisabled : oomDisabled // ignore: cast_nullable_to_non_nullable
as bool,dockerImage: null == dockerImage ? _self.dockerImage : dockerImage // ignore: cast_nullable_to_non_nullable
as String,validDuration: null == validDuration ? _self.validDuration : validDuration // ignore: cast_nullable_to_non_nullable
as int,deleteDuration: null == deleteDuration ? _self.deleteDuration : deleteDuration // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WareSpec].
extension WareSpecPatterns on WareSpec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WareSpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WareSpec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WareSpec value)  $default,){
final _that = this;
switch (_that) {
case _WareSpec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WareSpec value)?  $default,){
final _that = this;
switch (_that) {
case _WareSpec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? createdAt,  String? updatedAt,  int pricePerMonth,  String wareName,  String wareDescription,  int node,  int memory,  int cpu,  int swap,  int disk,  int io,  int backups,  int nest,  String tagSlug,  int egg,  List<int> allowedEggIds,  int discount,  bool startOnCompletion,  bool oomDisabled,  String dockerImage,  int validDuration,  int deleteDuration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WareSpec() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.pricePerMonth,_that.wareName,_that.wareDescription,_that.node,_that.memory,_that.cpu,_that.swap,_that.disk,_that.io,_that.backups,_that.nest,_that.tagSlug,_that.egg,_that.allowedEggIds,_that.discount,_that.startOnCompletion,_that.oomDisabled,_that.dockerImage,_that.validDuration,_that.deleteDuration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? createdAt,  String? updatedAt,  int pricePerMonth,  String wareName,  String wareDescription,  int node,  int memory,  int cpu,  int swap,  int disk,  int io,  int backups,  int nest,  String tagSlug,  int egg,  List<int> allowedEggIds,  int discount,  bool startOnCompletion,  bool oomDisabled,  String dockerImage,  int validDuration,  int deleteDuration)  $default,) {final _that = this;
switch (_that) {
case _WareSpec():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.pricePerMonth,_that.wareName,_that.wareDescription,_that.node,_that.memory,_that.cpu,_that.swap,_that.disk,_that.io,_that.backups,_that.nest,_that.tagSlug,_that.egg,_that.allowedEggIds,_that.discount,_that.startOnCompletion,_that.oomDisabled,_that.dockerImage,_that.validDuration,_that.deleteDuration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? createdAt,  String? updatedAt,  int pricePerMonth,  String wareName,  String wareDescription,  int node,  int memory,  int cpu,  int swap,  int disk,  int io,  int backups,  int nest,  String tagSlug,  int egg,  List<int> allowedEggIds,  int discount,  bool startOnCompletion,  bool oomDisabled,  String dockerImage,  int validDuration,  int deleteDuration)?  $default,) {final _that = this;
switch (_that) {
case _WareSpec() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.pricePerMonth,_that.wareName,_that.wareDescription,_that.node,_that.memory,_that.cpu,_that.swap,_that.disk,_that.io,_that.backups,_that.nest,_that.tagSlug,_that.egg,_that.allowedEggIds,_that.discount,_that.startOnCompletion,_that.oomDisabled,_that.dockerImage,_that.validDuration,_that.deleteDuration);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WareSpec extends WareSpec {
  const _WareSpec({this.id, this.createdAt, this.updatedAt, this.pricePerMonth = 0, this.wareName = '', this.wareDescription = '', this.node = 0, this.memory = 0, this.cpu = 0, this.swap = 0, this.disk = 0, this.io = 0, this.backups = 0, this.nest = 0, this.tagSlug = '', this.egg = 0,  List<int> allowedEggIds = const <int>[], this.discount = 0, this.startOnCompletion = false, this.oomDisabled = false, this.dockerImage = '', this.validDuration = 0, this.deleteDuration = 0}): _allowedEggIds = allowedEggIds,super._();
  factory _WareSpec.fromJson(Map<String, dynamic> json) => _$WareSpecFromJson(json);

@override final  String? id;
@override final  String? createdAt;
@override final  String? updatedAt;
@override@JsonKey() final  int pricePerMonth;
@override@JsonKey() final  String wareName;
@override@JsonKey() final  String wareDescription;
@override@JsonKey() final  int node;
@override@JsonKey() final  int memory;
@override@JsonKey() final  int cpu;
@override@JsonKey() final  int swap;
@override@JsonKey() final  int disk;
@override@JsonKey() final  int io;
@override@JsonKey() final  int backups;
@override@JsonKey() final  int nest;
@override@JsonKey() final  String tagSlug;
@override@JsonKey() final  int egg;
 final  List<int> _allowedEggIds;
@override@JsonKey() List<int> get allowedEggIds {
  if (_allowedEggIds is EqualUnmodifiableListView) return _allowedEggIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allowedEggIds);
}

@override@JsonKey() final  int discount;
@override@JsonKey() final  bool startOnCompletion;
@override@JsonKey() final  bool oomDisabled;
@override@JsonKey() final  String dockerImage;
@override@JsonKey() final  int validDuration;
@override@JsonKey() final  int deleteDuration;

/// Create a copy of WareSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WareSpecCopyWith<_WareSpec> get copyWith => __$WareSpecCopyWithImpl<_WareSpec>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WareSpecToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WareSpec&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.pricePerMonth, pricePerMonth) || other.pricePerMonth == pricePerMonth)&&(identical(other.wareName, wareName) || other.wareName == wareName)&&(identical(other.wareDescription, wareDescription) || other.wareDescription == wareDescription)&&(identical(other.node, node) || other.node == node)&&(identical(other.memory, memory) || other.memory == memory)&&(identical(other.cpu, cpu) || other.cpu == cpu)&&(identical(other.swap, swap) || other.swap == swap)&&(identical(other.disk, disk) || other.disk == disk)&&(identical(other.io, io) || other.io == io)&&(identical(other.backups, backups) || other.backups == backups)&&(identical(other.nest, nest) || other.nest == nest)&&(identical(other.tagSlug, tagSlug) || other.tagSlug == tagSlug)&&(identical(other.egg, egg) || other.egg == egg)&&const DeepCollectionEquality().equals(other.allowedEggIds, _allowedEggIds)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.startOnCompletion, startOnCompletion) || other.startOnCompletion == startOnCompletion)&&(identical(other.oomDisabled, oomDisabled) || other.oomDisabled == oomDisabled)&&(identical(other.dockerImage, dockerImage) || other.dockerImage == dockerImage)&&(identical(other.validDuration, validDuration) || other.validDuration == validDuration)&&(identical(other.deleteDuration, deleteDuration) || other.deleteDuration == deleteDuration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,createdAt,updatedAt,pricePerMonth,wareName,wareDescription,node,memory,cpu,swap,disk,io,backups,nest,tagSlug,egg,const DeepCollectionEquality().hash(_allowedEggIds),discount,startOnCompletion,oomDisabled,dockerImage,validDuration,deleteDuration]);
}

@override
String toString() {
    return 'WareSpec(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, pricePerMonth: $pricePerMonth, wareName: $wareName, wareDescription: $wareDescription, node: $node, memory: $memory, cpu: $cpu, swap: $swap, disk: $disk, io: $io, backups: $backups, nest: $nest, tagSlug: $tagSlug, egg: $egg, allowedEggIds: $allowedEggIds, discount: $discount, startOnCompletion: $startOnCompletion, oomDisabled: $oomDisabled, dockerImage: $dockerImage, validDuration: $validDuration, deleteDuration: $deleteDuration)';
}


}

/// @nodoc
abstract mixin class _$WareSpecCopyWith<$Res> implements $WareSpecCopyWith<$Res> {
  factory _$WareSpecCopyWith(_WareSpec value, $Res Function(_WareSpec) _then) = __$WareSpecCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? createdAt, String? updatedAt, int pricePerMonth, String wareName, String wareDescription, int node, int memory, int cpu, int swap, int disk, int io, int backups, int nest, String tagSlug, int egg, List<int> allowedEggIds, int discount, bool startOnCompletion, bool oomDisabled, String dockerImage, int validDuration, int deleteDuration
});




}
/// @nodoc
class __$WareSpecCopyWithImpl<$Res>
    implements _$WareSpecCopyWith<$Res> {
  __$WareSpecCopyWithImpl(this._self, this._then);

  final _WareSpec _self;
  final $Res Function(_WareSpec) _then;

/// Create a copy of WareSpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? pricePerMonth = null,Object? wareName = null,Object? wareDescription = null,Object? node = null,Object? memory = null,Object? cpu = null,Object? swap = null,Object? disk = null,Object? io = null,Object? backups = null,Object? nest = null,Object? tagSlug = null,Object? egg = null,Object? allowedEggIds = null,Object? discount = null,Object? startOnCompletion = null,Object? oomDisabled = null,Object? dockerImage = null,Object? validDuration = null,Object? deleteDuration = null,}) {
  return _then(_WareSpec(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,pricePerMonth: null == pricePerMonth ? _self.pricePerMonth : pricePerMonth // ignore: cast_nullable_to_non_nullable
as int,wareName: null == wareName ? _self.wareName : wareName // ignore: cast_nullable_to_non_nullable
as String,wareDescription: null == wareDescription ? _self.wareDescription : wareDescription // ignore: cast_nullable_to_non_nullable
as String,node: null == node ? _self.node : node // ignore: cast_nullable_to_non_nullable
as int,memory: null == memory ? _self.memory : memory // ignore: cast_nullable_to_non_nullable
as int,cpu: null == cpu ? _self.cpu : cpu // ignore: cast_nullable_to_non_nullable
as int,swap: null == swap ? _self.swap : swap // ignore: cast_nullable_to_non_nullable
as int,disk: null == disk ? _self.disk : disk // ignore: cast_nullable_to_non_nullable
as int,io: null == io ? _self.io : io // ignore: cast_nullable_to_non_nullable
as int,backups: null == backups ? _self.backups : backups // ignore: cast_nullable_to_non_nullable
as int,nest: null == nest ? _self.nest : nest // ignore: cast_nullable_to_non_nullable
as int,tagSlug: null == tagSlug ? _self.tagSlug : tagSlug // ignore: cast_nullable_to_non_nullable
as String,egg: null == egg ? _self.egg : egg // ignore: cast_nullable_to_non_nullable
as int,allowedEggIds: null == allowedEggIds ? _self._allowedEggIds : allowedEggIds // ignore: cast_nullable_to_non_nullable
as List<int>,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as int,startOnCompletion: null == startOnCompletion ? _self.startOnCompletion : startOnCompletion // ignore: cast_nullable_to_non_nullable
as bool,oomDisabled: null == oomDisabled ? _self.oomDisabled : oomDisabled // ignore: cast_nullable_to_non_nullable
as bool,dockerImage: null == dockerImage ? _self.dockerImage : dockerImage // ignore: cast_nullable_to_non_nullable
as String,validDuration: null == validDuration ? _self.validDuration : validDuration // ignore: cast_nullable_to_non_nullable
as int,deleteDuration: null == deleteDuration ? _self.deleteDuration : deleteDuration // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WareEntity {

 String? get id; String? get createdAt; String? get updatedAt; String get userId; String get specId; String get serverExternalId; String get userExternalId; String get hostName; int get deleteStatus; String get validDate;
/// Create a copy of WareEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WareEntityCopyWith<WareEntity> get copyWith => _$WareEntityCopyWithImpl<WareEntity>(this as WareEntity, _$identity);

  /// Serializes this WareEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WareEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WareEntity&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.specId, _this.specId) || other.specId == _this.specId)&&(identical(other.serverExternalId, _this.serverExternalId) || other.serverExternalId == _this.serverExternalId)&&(identical(other.userExternalId, _this.userExternalId) || other.userExternalId == _this.userExternalId)&&(identical(other.hostName, _this.hostName) || other.hostName == _this.hostName)&&(identical(other.deleteStatus, _this.deleteStatus) || other.deleteStatus == _this.deleteStatus)&&(identical(other.validDate, _this.validDate) || other.validDate == _this.validDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WareEntity;
  return Object.hash(runtimeType,_this.id,_this.createdAt,_this.updatedAt,_this.userId,_this.specId,_this.serverExternalId,_this.userExternalId,_this.hostName,_this.deleteStatus,_this.validDate);
}

@override
String toString() {
  final _this = this as WareEntity;
  return 'WareEntity(id: ${_this.id}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, userId: ${_this.userId}, specId: ${_this.specId}, serverExternalId: ${_this.serverExternalId}, userExternalId: ${_this.userExternalId}, hostName: ${_this.hostName}, deleteStatus: ${_this.deleteStatus}, validDate: ${_this.validDate})';
}


}

/// @nodoc
abstract mixin class $WareEntityCopyWith<$Res>  {
  factory $WareEntityCopyWith(WareEntity value, $Res Function(WareEntity) _then) = _$WareEntityCopyWithImpl;
@useResult
$Res call({
 String? id, String? createdAt, String? updatedAt, String userId, String specId, String serverExternalId, String userExternalId, String hostName, int deleteStatus, String validDate
});




}
/// @nodoc
class _$WareEntityCopyWithImpl<$Res>
    implements $WareEntityCopyWith<$Res> {
  _$WareEntityCopyWithImpl(this._self, this._then);

  final WareEntity _self;
  final $Res Function(WareEntity) _then;

/// Create a copy of WareEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? userId = null,Object? specId = null,Object? serverExternalId = null,Object? userExternalId = null,Object? hostName = null,Object? deleteStatus = null,Object? validDate = null,}) {
  return _then(WareEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,specId: null == specId ? _self.specId : specId // ignore: cast_nullable_to_non_nullable
as String,serverExternalId: null == serverExternalId ? _self.serverExternalId : serverExternalId // ignore: cast_nullable_to_non_nullable
as String,userExternalId: null == userExternalId ? _self.userExternalId : userExternalId // ignore: cast_nullable_to_non_nullable
as String,hostName: null == hostName ? _self.hostName : hostName // ignore: cast_nullable_to_non_nullable
as String,deleteStatus: null == deleteStatus ? _self.deleteStatus : deleteStatus // ignore: cast_nullable_to_non_nullable
as int,validDate: null == validDate ? _self.validDate : validDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WareEntity].
extension WareEntityPatterns on WareEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WareEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WareEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WareEntity value)  $default,){
final _that = this;
switch (_that) {
case _WareEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WareEntity value)?  $default,){
final _that = this;
switch (_that) {
case _WareEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? createdAt,  String? updatedAt,  String userId,  String specId,  String serverExternalId,  String userExternalId,  String hostName,  int deleteStatus,  String validDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WareEntity() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.userId,_that.specId,_that.serverExternalId,_that.userExternalId,_that.hostName,_that.deleteStatus,_that.validDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? createdAt,  String? updatedAt,  String userId,  String specId,  String serverExternalId,  String userExternalId,  String hostName,  int deleteStatus,  String validDate)  $default,) {final _that = this;
switch (_that) {
case _WareEntity():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.userId,_that.specId,_that.serverExternalId,_that.userExternalId,_that.hostName,_that.deleteStatus,_that.validDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? createdAt,  String? updatedAt,  String userId,  String specId,  String serverExternalId,  String userExternalId,  String hostName,  int deleteStatus,  String validDate)?  $default,) {final _that = this;
switch (_that) {
case _WareEntity() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.userId,_that.specId,_that.serverExternalId,_that.userExternalId,_that.hostName,_that.deleteStatus,_that.validDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WareEntity extends WareEntity {
  const _WareEntity({this.id, this.createdAt, this.updatedAt, this.userId = '', this.specId = '', this.serverExternalId = '', this.userExternalId = '', this.hostName = '', this.deleteStatus = 0, this.validDate = ''}): super._();
  factory _WareEntity.fromJson(Map<String, dynamic> json) => _$WareEntityFromJson(json);

@override final  String? id;
@override final  String? createdAt;
@override final  String? updatedAt;
@override@JsonKey() final  String userId;
@override@JsonKey() final  String specId;
@override@JsonKey() final  String serverExternalId;
@override@JsonKey() final  String userExternalId;
@override@JsonKey() final  String hostName;
@override@JsonKey() final  int deleteStatus;
@override@JsonKey() final  String validDate;

/// Create a copy of WareEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WareEntityCopyWith<_WareEntity> get copyWith => __$WareEntityCopyWithImpl<_WareEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WareEntityToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WareEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.specId, specId) || other.specId == specId)&&(identical(other.serverExternalId, serverExternalId) || other.serverExternalId == serverExternalId)&&(identical(other.userExternalId, userExternalId) || other.userExternalId == userExternalId)&&(identical(other.hostName, hostName) || other.hostName == hostName)&&(identical(other.deleteStatus, deleteStatus) || other.deleteStatus == deleteStatus)&&(identical(other.validDate, validDate) || other.validDate == validDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,createdAt,updatedAt,userId,specId,serverExternalId,userExternalId,hostName,deleteStatus,validDate);
}

@override
String toString() {
    return 'WareEntity(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, specId: $specId, serverExternalId: $serverExternalId, userExternalId: $userExternalId, hostName: $hostName, deleteStatus: $deleteStatus, validDate: $validDate)';
}


}

/// @nodoc
abstract mixin class _$WareEntityCopyWith<$Res> implements $WareEntityCopyWith<$Res> {
  factory _$WareEntityCopyWith(_WareEntity value, $Res Function(_WareEntity) _then) = __$WareEntityCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? createdAt, String? updatedAt, String userId, String specId, String serverExternalId, String userExternalId, String hostName, int deleteStatus, String validDate
});




}
/// @nodoc
class __$WareEntityCopyWithImpl<$Res>
    implements _$WareEntityCopyWith<$Res> {
  __$WareEntityCopyWithImpl(this._self, this._then);

  final _WareEntity _self;
  final $Res Function(_WareEntity) _then;

/// Create a copy of WareEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? userId = null,Object? specId = null,Object? serverExternalId = null,Object? userExternalId = null,Object? hostName = null,Object? deleteStatus = null,Object? validDate = null,}) {
  return _then(_WareEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,specId: null == specId ? _self.specId : specId // ignore: cast_nullable_to_non_nullable
as String,serverExternalId: null == serverExternalId ? _self.serverExternalId : serverExternalId // ignore: cast_nullable_to_non_nullable
as String,userExternalId: null == userExternalId ? _self.userExternalId : userExternalId // ignore: cast_nullable_to_non_nullable
as String,hostName: null == hostName ? _self.hostName : hostName // ignore: cast_nullable_to_non_nullable
as String,deleteStatus: null == deleteStatus ? _self.deleteStatus : deleteStatus // ignore: cast_nullable_to_non_nullable
as int,validDate: null == validDate ? _self.validDate : validDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$WareKey {

 String? get id; String? get createdAt; String? get updatedAt; String get specId; String get keyString; String get exp;
/// Create a copy of WareKey
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WareKeyCopyWith<WareKey> get copyWith => _$WareKeyCopyWithImpl<WareKey>(this as WareKey, _$identity);

  /// Serializes this WareKey to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WareKey;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WareKey&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.specId, _this.specId) || other.specId == _this.specId)&&(identical(other.keyString, _this.keyString) || other.keyString == _this.keyString)&&(identical(other.exp, _this.exp) || other.exp == _this.exp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WareKey;
  return Object.hash(runtimeType,_this.id,_this.createdAt,_this.updatedAt,_this.specId,_this.keyString,_this.exp);
}

@override
String toString() {
  final _this = this as WareKey;
  return 'WareKey(id: ${_this.id}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, specId: ${_this.specId}, keyString: ${_this.keyString}, exp: ${_this.exp})';
}


}

/// @nodoc
abstract mixin class $WareKeyCopyWith<$Res>  {
  factory $WareKeyCopyWith(WareKey value, $Res Function(WareKey) _then) = _$WareKeyCopyWithImpl;
@useResult
$Res call({
 String? id, String? createdAt, String? updatedAt, String specId, String keyString, String exp
});




}
/// @nodoc
class _$WareKeyCopyWithImpl<$Res>
    implements $WareKeyCopyWith<$Res> {
  _$WareKeyCopyWithImpl(this._self, this._then);

  final WareKey _self;
  final $Res Function(WareKey) _then;

/// Create a copy of WareKey
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? specId = null,Object? keyString = null,Object? exp = null,}) {
  return _then(WareKey(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,specId: null == specId ? _self.specId : specId // ignore: cast_nullable_to_non_nullable
as String,keyString: null == keyString ? _self.keyString : keyString // ignore: cast_nullable_to_non_nullable
as String,exp: null == exp ? _self.exp : exp // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WareKey].
extension WareKeyPatterns on WareKey {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WareKey value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WareKey() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WareKey value)  $default,){
final _that = this;
switch (_that) {
case _WareKey():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WareKey value)?  $default,){
final _that = this;
switch (_that) {
case _WareKey() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? createdAt,  String? updatedAt,  String specId,  String keyString,  String exp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WareKey() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.specId,_that.keyString,_that.exp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? createdAt,  String? updatedAt,  String specId,  String keyString,  String exp)  $default,) {final _that = this;
switch (_that) {
case _WareKey():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.specId,_that.keyString,_that.exp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? createdAt,  String? updatedAt,  String specId,  String keyString,  String exp)?  $default,) {final _that = this;
switch (_that) {
case _WareKey() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.specId,_that.keyString,_that.exp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WareKey implements WareKey {
  const _WareKey({this.id, this.createdAt, this.updatedAt, this.specId = '', this.keyString = '', this.exp = ''});
  factory _WareKey.fromJson(Map<String, dynamic> json) => _$WareKeyFromJson(json);

@override final  String? id;
@override final  String? createdAt;
@override final  String? updatedAt;
@override@JsonKey() final  String specId;
@override@JsonKey() final  String keyString;
@override@JsonKey() final  String exp;

/// Create a copy of WareKey
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WareKeyCopyWith<_WareKey> get copyWith => __$WareKeyCopyWithImpl<_WareKey>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WareKeyToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WareKey&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.specId, specId) || other.specId == specId)&&(identical(other.keyString, keyString) || other.keyString == keyString)&&(identical(other.exp, exp) || other.exp == exp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,createdAt,updatedAt,specId,keyString,exp);
}

@override
String toString() {
    return 'WareKey(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, specId: $specId, keyString: $keyString, exp: $exp)';
}


}

/// @nodoc
abstract mixin class _$WareKeyCopyWith<$Res> implements $WareKeyCopyWith<$Res> {
  factory _$WareKeyCopyWith(_WareKey value, $Res Function(_WareKey) _then) = __$WareKeyCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? createdAt, String? updatedAt, String specId, String keyString, String exp
});




}
/// @nodoc
class __$WareKeyCopyWithImpl<$Res>
    implements _$WareKeyCopyWith<$Res> {
  __$WareKeyCopyWithImpl(this._self, this._then);

  final _WareKey _self;
  final $Res Function(_WareKey) _then;

/// Create a copy of WareKey
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? specId = null,Object? keyString = null,Object? exp = null,}) {
  return _then(_WareKey(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,specId: null == specId ? _self.specId : specId // ignore: cast_nullable_to_non_nullable
as String,keyString: null == keyString ? _self.keyString : keyString // ignore: cast_nullable_to_non_nullable
as String,exp: null == exp ? _self.exp : exp // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RechargeKey {

 String? get id; String? get createdAt; String? get updatedAt; String get keyString; int get balance; String get exp;
/// Create a copy of RechargeKey
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RechargeKeyCopyWith<RechargeKey> get copyWith => _$RechargeKeyCopyWithImpl<RechargeKey>(this as RechargeKey, _$identity);

  /// Serializes this RechargeKey to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RechargeKey;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RechargeKey&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.keyString, _this.keyString) || other.keyString == _this.keyString)&&(identical(other.balance, _this.balance) || other.balance == _this.balance)&&(identical(other.exp, _this.exp) || other.exp == _this.exp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RechargeKey;
  return Object.hash(runtimeType,_this.id,_this.createdAt,_this.updatedAt,_this.keyString,_this.balance,_this.exp);
}

@override
String toString() {
  final _this = this as RechargeKey;
  return 'RechargeKey(id: ${_this.id}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, keyString: ${_this.keyString}, balance: ${_this.balance}, exp: ${_this.exp})';
}


}

/// @nodoc
abstract mixin class $RechargeKeyCopyWith<$Res>  {
  factory $RechargeKeyCopyWith(RechargeKey value, $Res Function(RechargeKey) _then) = _$RechargeKeyCopyWithImpl;
@useResult
$Res call({
 String? id, String? createdAt, String? updatedAt, String keyString, int balance, String exp
});




}
/// @nodoc
class _$RechargeKeyCopyWithImpl<$Res>
    implements $RechargeKeyCopyWith<$Res> {
  _$RechargeKeyCopyWithImpl(this._self, this._then);

  final RechargeKey _self;
  final $Res Function(RechargeKey) _then;

/// Create a copy of RechargeKey
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? keyString = null,Object? balance = null,Object? exp = null,}) {
  return _then(RechargeKey(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,keyString: null == keyString ? _self.keyString : keyString // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,exp: null == exp ? _self.exp : exp // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RechargeKey].
extension RechargeKeyPatterns on RechargeKey {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RechargeKey value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RechargeKey() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RechargeKey value)  $default,){
final _that = this;
switch (_that) {
case _RechargeKey():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RechargeKey value)?  $default,){
final _that = this;
switch (_that) {
case _RechargeKey() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? createdAt,  String? updatedAt,  String keyString,  int balance,  String exp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RechargeKey() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.keyString,_that.balance,_that.exp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? createdAt,  String? updatedAt,  String keyString,  int balance,  String exp)  $default,) {final _that = this;
switch (_that) {
case _RechargeKey():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.keyString,_that.balance,_that.exp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? createdAt,  String? updatedAt,  String keyString,  int balance,  String exp)?  $default,) {final _that = this;
switch (_that) {
case _RechargeKey() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.keyString,_that.balance,_that.exp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RechargeKey implements RechargeKey {
  const _RechargeKey({this.id, this.createdAt, this.updatedAt, this.keyString = '', this.balance = 0, this.exp = ''});
  factory _RechargeKey.fromJson(Map<String, dynamic> json) => _$RechargeKeyFromJson(json);

@override final  String? id;
@override final  String? createdAt;
@override final  String? updatedAt;
@override@JsonKey() final  String keyString;
@override@JsonKey() final  int balance;
@override@JsonKey() final  String exp;

/// Create a copy of RechargeKey
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RechargeKeyCopyWith<_RechargeKey> get copyWith => __$RechargeKeyCopyWithImpl<_RechargeKey>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RechargeKeyToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RechargeKey&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.keyString, keyString) || other.keyString == keyString)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.exp, exp) || other.exp == exp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,createdAt,updatedAt,keyString,balance,exp);
}

@override
String toString() {
    return 'RechargeKey(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, keyString: $keyString, balance: $balance, exp: $exp)';
}


}

/// @nodoc
abstract mixin class _$RechargeKeyCopyWith<$Res> implements $RechargeKeyCopyWith<$Res> {
  factory _$RechargeKeyCopyWith(_RechargeKey value, $Res Function(_RechargeKey) _then) = __$RechargeKeyCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? createdAt, String? updatedAt, String keyString, int balance, String exp
});




}
/// @nodoc
class __$RechargeKeyCopyWithImpl<$Res>
    implements _$RechargeKeyCopyWith<$Res> {
  __$RechargeKeyCopyWithImpl(this._self, this._then);

  final _RechargeKey _self;
  final $Res Function(_RechargeKey) _then;

/// Create a copy of RechargeKey
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? keyString = null,Object? balance = null,Object? exp = null,}) {
  return _then(_RechargeKey(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,keyString: null == keyString ? _self.keyString : keyString // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,exp: null == exp ? _self.exp : exp // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Order {

 String? get id; String? get createdAt; String? get updatedAt; String get specId; String get userId; int get allocationId; int get originPrice; int get finalPrice; bool get paid; bool get confirmed; bool get closed;
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCopyWith<Order> get copyWith => _$OrderCopyWithImpl<Order>(this as Order, _$identity);

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Order;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Order&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.specId, _this.specId) || other.specId == _this.specId)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.allocationId, _this.allocationId) || other.allocationId == _this.allocationId)&&(identical(other.originPrice, _this.originPrice) || other.originPrice == _this.originPrice)&&(identical(other.finalPrice, _this.finalPrice) || other.finalPrice == _this.finalPrice)&&(identical(other.paid, _this.paid) || other.paid == _this.paid)&&(identical(other.confirmed, _this.confirmed) || other.confirmed == _this.confirmed)&&(identical(other.closed, _this.closed) || other.closed == _this.closed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Order;
  return Object.hash(runtimeType,_this.id,_this.createdAt,_this.updatedAt,_this.specId,_this.userId,_this.allocationId,_this.originPrice,_this.finalPrice,_this.paid,_this.confirmed,_this.closed);
}

@override
String toString() {
  final _this = this as Order;
  return 'Order(id: ${_this.id}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, specId: ${_this.specId}, userId: ${_this.userId}, allocationId: ${_this.allocationId}, originPrice: ${_this.originPrice}, finalPrice: ${_this.finalPrice}, paid: ${_this.paid}, confirmed: ${_this.confirmed}, closed: ${_this.closed})';
}


}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res>  {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) = _$OrderCopyWithImpl;
@useResult
$Res call({
 String? id, String? createdAt, String? updatedAt, String specId, String userId, int allocationId, int originPrice, int finalPrice, bool paid, bool confirmed, bool closed
});




}
/// @nodoc
class _$OrderCopyWithImpl<$Res>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? specId = null,Object? userId = null,Object? allocationId = null,Object? originPrice = null,Object? finalPrice = null,Object? paid = null,Object? confirmed = null,Object? closed = null,}) {
  return _then(Order(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,specId: null == specId ? _self.specId : specId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,allocationId: null == allocationId ? _self.allocationId : allocationId // ignore: cast_nullable_to_non_nullable
as int,originPrice: null == originPrice ? _self.originPrice : originPrice // ignore: cast_nullable_to_non_nullable
as int,finalPrice: null == finalPrice ? _self.finalPrice : finalPrice // ignore: cast_nullable_to_non_nullable
as int,paid: null == paid ? _self.paid : paid // ignore: cast_nullable_to_non_nullable
as bool,confirmed: null == confirmed ? _self.confirmed : confirmed // ignore: cast_nullable_to_non_nullable
as bool,closed: null == closed ? _self.closed : closed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Order].
extension OrderPatterns on Order {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Order value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Order value)  $default,){
final _that = this;
switch (_that) {
case _Order():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Order value)?  $default,){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? createdAt,  String? updatedAt,  String specId,  String userId,  int allocationId,  int originPrice,  int finalPrice,  bool paid,  bool confirmed,  bool closed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.specId,_that.userId,_that.allocationId,_that.originPrice,_that.finalPrice,_that.paid,_that.confirmed,_that.closed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? createdAt,  String? updatedAt,  String specId,  String userId,  int allocationId,  int originPrice,  int finalPrice,  bool paid,  bool confirmed,  bool closed)  $default,) {final _that = this;
switch (_that) {
case _Order():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.specId,_that.userId,_that.allocationId,_that.originPrice,_that.finalPrice,_that.paid,_that.confirmed,_that.closed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? createdAt,  String? updatedAt,  String specId,  String userId,  int allocationId,  int originPrice,  int finalPrice,  bool paid,  bool confirmed,  bool closed)?  $default,) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.specId,_that.userId,_that.allocationId,_that.originPrice,_that.finalPrice,_that.paid,_that.confirmed,_that.closed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Order extends Order {
  const _Order({this.id, this.createdAt, this.updatedAt, this.specId = '', this.userId = '', this.allocationId = 0, this.originPrice = 0, this.finalPrice = 0, this.paid = false, this.confirmed = false, this.closed = false}): super._();
  factory _Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

@override final  String? id;
@override final  String? createdAt;
@override final  String? updatedAt;
@override@JsonKey() final  String specId;
@override@JsonKey() final  String userId;
@override@JsonKey() final  int allocationId;
@override@JsonKey() final  int originPrice;
@override@JsonKey() final  int finalPrice;
@override@JsonKey() final  bool paid;
@override@JsonKey() final  bool confirmed;
@override@JsonKey() final  bool closed;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCopyWith<_Order> get copyWith => __$OrderCopyWithImpl<_Order>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Order&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.specId, specId) || other.specId == specId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.allocationId, allocationId) || other.allocationId == allocationId)&&(identical(other.originPrice, originPrice) || other.originPrice == originPrice)&&(identical(other.finalPrice, finalPrice) || other.finalPrice == finalPrice)&&(identical(other.paid, paid) || other.paid == paid)&&(identical(other.confirmed, confirmed) || other.confirmed == confirmed)&&(identical(other.closed, closed) || other.closed == closed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,createdAt,updatedAt,specId,userId,allocationId,originPrice,finalPrice,paid,confirmed,closed);
}

@override
String toString() {
    return 'Order(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, specId: $specId, userId: $userId, allocationId: $allocationId, originPrice: $originPrice, finalPrice: $finalPrice, paid: $paid, confirmed: $confirmed, closed: $closed)';
}


}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) = __$OrderCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? createdAt, String? updatedAt, String specId, String userId, int allocationId, int originPrice, int finalPrice, bool paid, bool confirmed, bool closed
});




}
/// @nodoc
class __$OrderCopyWithImpl<$Res>
    implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? specId = null,Object? userId = null,Object? allocationId = null,Object? originPrice = null,Object? finalPrice = null,Object? paid = null,Object? confirmed = null,Object? closed = null,}) {
  return _then(_Order(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,specId: null == specId ? _self.specId : specId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,allocationId: null == allocationId ? _self.allocationId : allocationId // ignore: cast_nullable_to_non_nullable
as int,originPrice: null == originPrice ? _self.originPrice : originPrice // ignore: cast_nullable_to_non_nullable
as int,finalPrice: null == finalPrice ? _self.finalPrice : finalPrice // ignore: cast_nullable_to_non_nullable
as int,paid: null == paid ? _self.paid : paid // ignore: cast_nullable_to_non_nullable
as bool,confirmed: null == confirmed ? _self.confirmed : confirmed // ignore: cast_nullable_to_non_nullable
as bool,closed: null == closed ? _self.closed : closed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Message {

 String? get id; String? get createdAt; String? get updatedAt; String get senderName; String get receiverId; String get text; String get timeText; bool get haveRead;
/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageCopyWith<Message> get copyWith => _$MessageCopyWithImpl<Message>(this as Message, _$identity);

  /// Serializes this Message to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Message;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Message&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.senderName, _this.senderName) || other.senderName == _this.senderName)&&(identical(other.receiverId, _this.receiverId) || other.receiverId == _this.receiverId)&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.timeText, _this.timeText) || other.timeText == _this.timeText)&&(identical(other.haveRead, _this.haveRead) || other.haveRead == _this.haveRead));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Message;
  return Object.hash(runtimeType,_this.id,_this.createdAt,_this.updatedAt,_this.senderName,_this.receiverId,_this.text,_this.timeText,_this.haveRead);
}

@override
String toString() {
  final _this = this as Message;
  return 'Message(id: ${_this.id}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, senderName: ${_this.senderName}, receiverId: ${_this.receiverId}, text: ${_this.text}, timeText: ${_this.timeText}, haveRead: ${_this.haveRead})';
}


}

/// @nodoc
abstract mixin class $MessageCopyWith<$Res>  {
  factory $MessageCopyWith(Message value, $Res Function(Message) _then) = _$MessageCopyWithImpl;
@useResult
$Res call({
 String? id, String? createdAt, String? updatedAt, String senderName, String receiverId, String text, String timeText, bool haveRead
});




}
/// @nodoc
class _$MessageCopyWithImpl<$Res>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._self, this._then);

  final Message _self;
  final $Res Function(Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? senderName = null,Object? receiverId = null,Object? text = null,Object? timeText = null,Object? haveRead = null,}) {
  return _then(Message(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,receiverId: null == receiverId ? _self.receiverId : receiverId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,timeText: null == timeText ? _self.timeText : timeText // ignore: cast_nullable_to_non_nullable
as String,haveRead: null == haveRead ? _self.haveRead : haveRead // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Message].
extension MessagePatterns on Message {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Message value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Message() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Message value)  $default,){
final _that = this;
switch (_that) {
case _Message():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Message value)?  $default,){
final _that = this;
switch (_that) {
case _Message() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? createdAt,  String? updatedAt,  String senderName,  String receiverId,  String text,  String timeText,  bool haveRead)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.senderName,_that.receiverId,_that.text,_that.timeText,_that.haveRead);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? createdAt,  String? updatedAt,  String senderName,  String receiverId,  String text,  String timeText,  bool haveRead)  $default,) {final _that = this;
switch (_that) {
case _Message():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.senderName,_that.receiverId,_that.text,_that.timeText,_that.haveRead);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? createdAt,  String? updatedAt,  String senderName,  String receiverId,  String text,  String timeText,  bool haveRead)?  $default,) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.senderName,_that.receiverId,_that.text,_that.timeText,_that.haveRead);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Message implements Message {
  const _Message({this.id, this.createdAt, this.updatedAt, this.senderName = '', this.receiverId = '', this.text = '', this.timeText = '', this.haveRead = false});
  factory _Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

@override final  String? id;
@override final  String? createdAt;
@override final  String? updatedAt;
@override@JsonKey() final  String senderName;
@override@JsonKey() final  String receiverId;
@override@JsonKey() final  String text;
@override@JsonKey() final  String timeText;
@override@JsonKey() final  bool haveRead;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageCopyWith<_Message> get copyWith => __$MessageCopyWithImpl<_Message>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Message&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.receiverId, receiverId) || other.receiverId == receiverId)&&(identical(other.text, text) || other.text == text)&&(identical(other.timeText, timeText) || other.timeText == timeText)&&(identical(other.haveRead, haveRead) || other.haveRead == haveRead));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,createdAt,updatedAt,senderName,receiverId,text,timeText,haveRead);
}

@override
String toString() {
    return 'Message(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, senderName: $senderName, receiverId: $receiverId, text: $text, timeText: $timeText, haveRead: $haveRead)';
}


}

/// @nodoc
abstract mixin class _$MessageCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$MessageCopyWith(_Message value, $Res Function(_Message) _then) = __$MessageCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? createdAt, String? updatedAt, String senderName, String receiverId, String text, String timeText, bool haveRead
});




}
/// @nodoc
class __$MessageCopyWithImpl<$Res>
    implements _$MessageCopyWith<$Res> {
  __$MessageCopyWithImpl(this._self, this._then);

  final _Message _self;
  final $Res Function(_Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? senderName = null,Object? receiverId = null,Object? text = null,Object? timeText = null,Object? haveRead = null,}) {
  return _then(_Message(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,receiverId: null == receiverId ? _self.receiverId : receiverId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,timeText: null == timeText ? _self.timeText : timeText // ignore: cast_nullable_to_non_nullable
as String,haveRead: null == haveRead ? _self.haveRead : haveRead // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$GalleryItem {

 String? get id; String? get createdAt; String? get updatedAt; String get userId; String get itemName; String get itemDescription; int get likes; bool get reviewPassed; String get imgSource;
/// Create a copy of GalleryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GalleryItemCopyWith<GalleryItem> get copyWith => _$GalleryItemCopyWithImpl<GalleryItem>(this as GalleryItem, _$identity);

  /// Serializes this GalleryItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GalleryItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GalleryItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.itemName, _this.itemName) || other.itemName == _this.itemName)&&(identical(other.itemDescription, _this.itemDescription) || other.itemDescription == _this.itemDescription)&&(identical(other.likes, _this.likes) || other.likes == _this.likes)&&(identical(other.reviewPassed, _this.reviewPassed) || other.reviewPassed == _this.reviewPassed)&&(identical(other.imgSource, _this.imgSource) || other.imgSource == _this.imgSource));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GalleryItem;
  return Object.hash(runtimeType,_this.id,_this.createdAt,_this.updatedAt,_this.userId,_this.itemName,_this.itemDescription,_this.likes,_this.reviewPassed,_this.imgSource);
}

@override
String toString() {
  final _this = this as GalleryItem;
  return 'GalleryItem(id: ${_this.id}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, userId: ${_this.userId}, itemName: ${_this.itemName}, itemDescription: ${_this.itemDescription}, likes: ${_this.likes}, reviewPassed: ${_this.reviewPassed}, imgSource: ${_this.imgSource})';
}


}

/// @nodoc
abstract mixin class $GalleryItemCopyWith<$Res>  {
  factory $GalleryItemCopyWith(GalleryItem value, $Res Function(GalleryItem) _then) = _$GalleryItemCopyWithImpl;
@useResult
$Res call({
 String? id, String? createdAt, String? updatedAt, String userId, String itemName, String itemDescription, int likes, bool reviewPassed, String imgSource
});




}
/// @nodoc
class _$GalleryItemCopyWithImpl<$Res>
    implements $GalleryItemCopyWith<$Res> {
  _$GalleryItemCopyWithImpl(this._self, this._then);

  final GalleryItem _self;
  final $Res Function(GalleryItem) _then;

/// Create a copy of GalleryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? userId = null,Object? itemName = null,Object? itemDescription = null,Object? likes = null,Object? reviewPassed = null,Object? imgSource = null,}) {
  return _then(GalleryItem(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,itemDescription: null == itemDescription ? _self.itemDescription : itemDescription // ignore: cast_nullable_to_non_nullable
as String,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,reviewPassed: null == reviewPassed ? _self.reviewPassed : reviewPassed // ignore: cast_nullable_to_non_nullable
as bool,imgSource: null == imgSource ? _self.imgSource : imgSource // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GalleryItem].
extension GalleryItemPatterns on GalleryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GalleryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GalleryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GalleryItem value)  $default,){
final _that = this;
switch (_that) {
case _GalleryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GalleryItem value)?  $default,){
final _that = this;
switch (_that) {
case _GalleryItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? createdAt,  String? updatedAt,  String userId,  String itemName,  String itemDescription,  int likes,  bool reviewPassed,  String imgSource)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GalleryItem() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.userId,_that.itemName,_that.itemDescription,_that.likes,_that.reviewPassed,_that.imgSource);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? createdAt,  String? updatedAt,  String userId,  String itemName,  String itemDescription,  int likes,  bool reviewPassed,  String imgSource)  $default,) {final _that = this;
switch (_that) {
case _GalleryItem():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.userId,_that.itemName,_that.itemDescription,_that.likes,_that.reviewPassed,_that.imgSource);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? createdAt,  String? updatedAt,  String userId,  String itemName,  String itemDescription,  int likes,  bool reviewPassed,  String imgSource)?  $default,) {final _that = this;
switch (_that) {
case _GalleryItem() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.userId,_that.itemName,_that.itemDescription,_that.likes,_that.reviewPassed,_that.imgSource);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GalleryItem implements GalleryItem {
  const _GalleryItem({this.id, this.createdAt, this.updatedAt, this.userId = '', this.itemName = '', this.itemDescription = '', this.likes = 0, this.reviewPassed = false, this.imgSource = ''});
  factory _GalleryItem.fromJson(Map<String, dynamic> json) => _$GalleryItemFromJson(json);

@override final  String? id;
@override final  String? createdAt;
@override final  String? updatedAt;
@override@JsonKey() final  String userId;
@override@JsonKey() final  String itemName;
@override@JsonKey() final  String itemDescription;
@override@JsonKey() final  int likes;
@override@JsonKey() final  bool reviewPassed;
@override@JsonKey() final  String imgSource;

/// Create a copy of GalleryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GalleryItemCopyWith<_GalleryItem> get copyWith => __$GalleryItemCopyWithImpl<_GalleryItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GalleryItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GalleryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.itemDescription, itemDescription) || other.itemDescription == itemDescription)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.reviewPassed, reviewPassed) || other.reviewPassed == reviewPassed)&&(identical(other.imgSource, imgSource) || other.imgSource == imgSource));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,createdAt,updatedAt,userId,itemName,itemDescription,likes,reviewPassed,imgSource);
}

@override
String toString() {
    return 'GalleryItem(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, itemName: $itemName, itemDescription: $itemDescription, likes: $likes, reviewPassed: $reviewPassed, imgSource: $imgSource)';
}


}

/// @nodoc
abstract mixin class _$GalleryItemCopyWith<$Res> implements $GalleryItemCopyWith<$Res> {
  factory _$GalleryItemCopyWith(_GalleryItem value, $Res Function(_GalleryItem) _then) = __$GalleryItemCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? createdAt, String? updatedAt, String userId, String itemName, String itemDescription, int likes, bool reviewPassed, String imgSource
});




}
/// @nodoc
class __$GalleryItemCopyWithImpl<$Res>
    implements _$GalleryItemCopyWith<$Res> {
  __$GalleryItemCopyWithImpl(this._self, this._then);

  final _GalleryItem _self;
  final $Res Function(_GalleryItem) _then;

/// Create a copy of GalleryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? userId = null,Object? itemName = null,Object? itemDescription = null,Object? likes = null,Object? reviewPassed = null,Object? imgSource = null,}) {
  return _then(_GalleryItem(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,itemDescription: null == itemDescription ? _self.itemDescription : itemDescription // ignore: cast_nullable_to_non_nullable
as String,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,reviewPassed: null == reviewPassed ? _self.reviewPassed : reviewPassed // ignore: cast_nullable_to_non_nullable
as bool,imgSource: null == imgSource ? _self.imgSource : imgSource // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$WorkOrder {

 String? get id; String? get createdAt; String? get updatedAt; String get userId; String get userName; String get orderTitle; String get orderText; bool get closed;
/// Create a copy of WorkOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkOrderCopyWith<WorkOrder> get copyWith => _$WorkOrderCopyWithImpl<WorkOrder>(this as WorkOrder, _$identity);

  /// Serializes this WorkOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkOrder;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkOrder&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.userName, _this.userName) || other.userName == _this.userName)&&(identical(other.orderTitle, _this.orderTitle) || other.orderTitle == _this.orderTitle)&&(identical(other.orderText, _this.orderText) || other.orderText == _this.orderText)&&(identical(other.closed, _this.closed) || other.closed == _this.closed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkOrder;
  return Object.hash(runtimeType,_this.id,_this.createdAt,_this.updatedAt,_this.userId,_this.userName,_this.orderTitle,_this.orderText,_this.closed);
}

@override
String toString() {
  final _this = this as WorkOrder;
  return 'WorkOrder(id: ${_this.id}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, userId: ${_this.userId}, userName: ${_this.userName}, orderTitle: ${_this.orderTitle}, orderText: ${_this.orderText}, closed: ${_this.closed})';
}


}

/// @nodoc
abstract mixin class $WorkOrderCopyWith<$Res>  {
  factory $WorkOrderCopyWith(WorkOrder value, $Res Function(WorkOrder) _then) = _$WorkOrderCopyWithImpl;
@useResult
$Res call({
 String? id, String? createdAt, String? updatedAt, String userId, String userName, String orderTitle, String orderText, bool closed
});




}
/// @nodoc
class _$WorkOrderCopyWithImpl<$Res>
    implements $WorkOrderCopyWith<$Res> {
  _$WorkOrderCopyWithImpl(this._self, this._then);

  final WorkOrder _self;
  final $Res Function(WorkOrder) _then;

/// Create a copy of WorkOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? userId = null,Object? userName = null,Object? orderTitle = null,Object? orderText = null,Object? closed = null,}) {
  return _then(WorkOrder(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,orderTitle: null == orderTitle ? _self.orderTitle : orderTitle // ignore: cast_nullable_to_non_nullable
as String,orderText: null == orderText ? _self.orderText : orderText // ignore: cast_nullable_to_non_nullable
as String,closed: null == closed ? _self.closed : closed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkOrder].
extension WorkOrderPatterns on WorkOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkOrder value)  $default,){
final _that = this;
switch (_that) {
case _WorkOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkOrder value)?  $default,){
final _that = this;
switch (_that) {
case _WorkOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? createdAt,  String? updatedAt,  String userId,  String userName,  String orderTitle,  String orderText,  bool closed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkOrder() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.userId,_that.userName,_that.orderTitle,_that.orderText,_that.closed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? createdAt,  String? updatedAt,  String userId,  String userName,  String orderTitle,  String orderText,  bool closed)  $default,) {final _that = this;
switch (_that) {
case _WorkOrder():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.userId,_that.userName,_that.orderTitle,_that.orderText,_that.closed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? createdAt,  String? updatedAt,  String userId,  String userName,  String orderTitle,  String orderText,  bool closed)?  $default,) {final _that = this;
switch (_that) {
case _WorkOrder() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.userId,_that.userName,_that.orderTitle,_that.orderText,_that.closed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkOrder implements WorkOrder {
  const _WorkOrder({this.id, this.createdAt, this.updatedAt, this.userId = '', this.userName = '', this.orderTitle = '', this.orderText = '', this.closed = false});
  factory _WorkOrder.fromJson(Map<String, dynamic> json) => _$WorkOrderFromJson(json);

@override final  String? id;
@override final  String? createdAt;
@override final  String? updatedAt;
@override@JsonKey() final  String userId;
@override@JsonKey() final  String userName;
@override@JsonKey() final  String orderTitle;
@override@JsonKey() final  String orderText;
@override@JsonKey() final  bool closed;

/// Create a copy of WorkOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkOrderCopyWith<_WorkOrder> get copyWith => __$WorkOrderCopyWithImpl<_WorkOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkOrderToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.orderTitle, orderTitle) || other.orderTitle == orderTitle)&&(identical(other.orderText, orderText) || other.orderText == orderText)&&(identical(other.closed, closed) || other.closed == closed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,createdAt,updatedAt,userId,userName,orderTitle,orderText,closed);
}

@override
String toString() {
    return 'WorkOrder(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, userName: $userName, orderTitle: $orderTitle, orderText: $orderText, closed: $closed)';
}


}

/// @nodoc
abstract mixin class _$WorkOrderCopyWith<$Res> implements $WorkOrderCopyWith<$Res> {
  factory _$WorkOrderCopyWith(_WorkOrder value, $Res Function(_WorkOrder) _then) = __$WorkOrderCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? createdAt, String? updatedAt, String userId, String userName, String orderTitle, String orderText, bool closed
});




}
/// @nodoc
class __$WorkOrderCopyWithImpl<$Res>
    implements _$WorkOrderCopyWith<$Res> {
  __$WorkOrderCopyWithImpl(this._self, this._then);

  final _WorkOrder _self;
  final $Res Function(_WorkOrder) _then;

/// Create a copy of WorkOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? userId = null,Object? userName = null,Object? orderTitle = null,Object? orderText = null,Object? closed = null,}) {
  return _then(_WorkOrder(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,orderTitle: null == orderTitle ? _self.orderTitle : orderTitle // ignore: cast_nullable_to_non_nullable
as String,orderText: null == orderText ? _self.orderText : orderText // ignore: cast_nullable_to_non_nullable
as String,closed: null == closed ? _self.closed : closed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$RechargeLog {

 String? get id; String? get createdAt; String? get updatedAt; String get userId; String get code; String get method; int get balance; String get time; String get outTradeNo; String get status;
/// Create a copy of RechargeLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RechargeLogCopyWith<RechargeLog> get copyWith => _$RechargeLogCopyWithImpl<RechargeLog>(this as RechargeLog, _$identity);

  /// Serializes this RechargeLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RechargeLog;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RechargeLog&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.balance, _this.balance) || other.balance == _this.balance)&&(identical(other.time, _this.time) || other.time == _this.time)&&(identical(other.outTradeNo, _this.outTradeNo) || other.outTradeNo == _this.outTradeNo)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RechargeLog;
  return Object.hash(runtimeType,_this.id,_this.createdAt,_this.updatedAt,_this.userId,_this.code,_this.method,_this.balance,_this.time,_this.outTradeNo,_this.status);
}

@override
String toString() {
  final _this = this as RechargeLog;
  return 'RechargeLog(id: ${_this.id}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, userId: ${_this.userId}, code: ${_this.code}, method: ${_this.method}, balance: ${_this.balance}, time: ${_this.time}, outTradeNo: ${_this.outTradeNo}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $RechargeLogCopyWith<$Res>  {
  factory $RechargeLogCopyWith(RechargeLog value, $Res Function(RechargeLog) _then) = _$RechargeLogCopyWithImpl;
@useResult
$Res call({
 String? id, String? createdAt, String? updatedAt, String userId, String code, String method, int balance, String time, String outTradeNo, String status
});




}
/// @nodoc
class _$RechargeLogCopyWithImpl<$Res>
    implements $RechargeLogCopyWith<$Res> {
  _$RechargeLogCopyWithImpl(this._self, this._then);

  final RechargeLog _self;
  final $Res Function(RechargeLog) _then;

/// Create a copy of RechargeLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? userId = null,Object? code = null,Object? method = null,Object? balance = null,Object? time = null,Object? outTradeNo = null,Object? status = null,}) {
  return _then(RechargeLog(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,outTradeNo: null == outTradeNo ? _self.outTradeNo : outTradeNo // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RechargeLog].
extension RechargeLogPatterns on RechargeLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RechargeLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RechargeLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RechargeLog value)  $default,){
final _that = this;
switch (_that) {
case _RechargeLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RechargeLog value)?  $default,){
final _that = this;
switch (_that) {
case _RechargeLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? createdAt,  String? updatedAt,  String userId,  String code,  String method,  int balance,  String time,  String outTradeNo,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RechargeLog() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.userId,_that.code,_that.method,_that.balance,_that.time,_that.outTradeNo,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? createdAt,  String? updatedAt,  String userId,  String code,  String method,  int balance,  String time,  String outTradeNo,  String status)  $default,) {final _that = this;
switch (_that) {
case _RechargeLog():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.userId,_that.code,_that.method,_that.balance,_that.time,_that.outTradeNo,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? createdAt,  String? updatedAt,  String userId,  String code,  String method,  int balance,  String time,  String outTradeNo,  String status)?  $default,) {final _that = this;
switch (_that) {
case _RechargeLog() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.userId,_that.code,_that.method,_that.balance,_that.time,_that.outTradeNo,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RechargeLog implements RechargeLog {
  const _RechargeLog({this.id, this.createdAt, this.updatedAt, this.userId = '', this.code = '', this.method = '', this.balance = 0, this.time = '', this.outTradeNo = '', this.status = RechargeStatus.pending});
  factory _RechargeLog.fromJson(Map<String, dynamic> json) => _$RechargeLogFromJson(json);

@override final  String? id;
@override final  String? createdAt;
@override final  String? updatedAt;
@override@JsonKey() final  String userId;
@override@JsonKey() final  String code;
@override@JsonKey() final  String method;
@override@JsonKey() final  int balance;
@override@JsonKey() final  String time;
@override@JsonKey() final  String outTradeNo;
@override@JsonKey() final  String status;

/// Create a copy of RechargeLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RechargeLogCopyWith<_RechargeLog> get copyWith => __$RechargeLogCopyWithImpl<_RechargeLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RechargeLogToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RechargeLog&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.code, code) || other.code == code)&&(identical(other.method, method) || other.method == method)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.time, time) || other.time == time)&&(identical(other.outTradeNo, outTradeNo) || other.outTradeNo == outTradeNo)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,createdAt,updatedAt,userId,code,method,balance,time,outTradeNo,status);
}

@override
String toString() {
    return 'RechargeLog(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, code: $code, method: $method, balance: $balance, time: $time, outTradeNo: $outTradeNo, status: $status)';
}


}

/// @nodoc
abstract mixin class _$RechargeLogCopyWith<$Res> implements $RechargeLogCopyWith<$Res> {
  factory _$RechargeLogCopyWith(_RechargeLog value, $Res Function(_RechargeLog) _then) = __$RechargeLogCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? createdAt, String? updatedAt, String userId, String code, String method, int balance, String time, String outTradeNo, String status
});




}
/// @nodoc
class __$RechargeLogCopyWithImpl<$Res>
    implements _$RechargeLogCopyWith<$Res> {
  __$RechargeLogCopyWithImpl(this._self, this._then);

  final _RechargeLog _self;
  final $Res Function(_RechargeLog) _then;

/// Create a copy of RechargeLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? userId = null,Object? code = null,Object? method = null,Object? balance = null,Object? time = null,Object? outTradeNo = null,Object? status = null,}) {
  return _then(_RechargeLog(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,outTradeNo: null == outTradeNo ? _self.outTradeNo : outTradeNo // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
