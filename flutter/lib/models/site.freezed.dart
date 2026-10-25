// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'site.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SiteConfig {

 String get applicationName; String get description; String get hostName; String get adminAddress; bool get albumEnabled; bool get rechargeMode; bool get alipayEnabled; bool get totalDiscount; String get socialLink; String get socialLinkTitle; bool get emailNotice;/// Always present, so the shell can build the navigation bar from one
/// request. False and zero for an anonymous visitor.
 bool get loggedIn; bool get isAdmin; int get unread;
/// Create a copy of SiteConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SiteConfigCopyWith<SiteConfig> get copyWith => _$SiteConfigCopyWithImpl<SiteConfig>(this as SiteConfig, _$identity);

  /// Serializes this SiteConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SiteConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SiteConfig&&(identical(other.applicationName, _this.applicationName) || other.applicationName == _this.applicationName)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.hostName, _this.hostName) || other.hostName == _this.hostName)&&(identical(other.adminAddress, _this.adminAddress) || other.adminAddress == _this.adminAddress)&&(identical(other.albumEnabled, _this.albumEnabled) || other.albumEnabled == _this.albumEnabled)&&(identical(other.rechargeMode, _this.rechargeMode) || other.rechargeMode == _this.rechargeMode)&&(identical(other.alipayEnabled, _this.alipayEnabled) || other.alipayEnabled == _this.alipayEnabled)&&(identical(other.totalDiscount, _this.totalDiscount) || other.totalDiscount == _this.totalDiscount)&&(identical(other.socialLink, _this.socialLink) || other.socialLink == _this.socialLink)&&(identical(other.socialLinkTitle, _this.socialLinkTitle) || other.socialLinkTitle == _this.socialLinkTitle)&&(identical(other.emailNotice, _this.emailNotice) || other.emailNotice == _this.emailNotice)&&(identical(other.loggedIn, _this.loggedIn) || other.loggedIn == _this.loggedIn)&&(identical(other.isAdmin, _this.isAdmin) || other.isAdmin == _this.isAdmin)&&(identical(other.unread, _this.unread) || other.unread == _this.unread));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SiteConfig;
  return Object.hash(runtimeType,_this.applicationName,_this.description,_this.hostName,_this.adminAddress,_this.albumEnabled,_this.rechargeMode,_this.alipayEnabled,_this.totalDiscount,_this.socialLink,_this.socialLinkTitle,_this.emailNotice,_this.loggedIn,_this.isAdmin,_this.unread);
}

@override
String toString() {
  final _this = this as SiteConfig;
  return 'SiteConfig(applicationName: ${_this.applicationName}, description: ${_this.description}, hostName: ${_this.hostName}, adminAddress: ${_this.adminAddress}, albumEnabled: ${_this.albumEnabled}, rechargeMode: ${_this.rechargeMode}, alipayEnabled: ${_this.alipayEnabled}, totalDiscount: ${_this.totalDiscount}, socialLink: ${_this.socialLink}, socialLinkTitle: ${_this.socialLinkTitle}, emailNotice: ${_this.emailNotice}, loggedIn: ${_this.loggedIn}, isAdmin: ${_this.isAdmin}, unread: ${_this.unread})';
}


}

/// @nodoc
abstract mixin class $SiteConfigCopyWith<$Res>  {
  factory $SiteConfigCopyWith(SiteConfig value, $Res Function(SiteConfig) _then) = _$SiteConfigCopyWithImpl;
@useResult
$Res call({
 String applicationName, String description, String hostName, String adminAddress, bool albumEnabled, bool rechargeMode, bool alipayEnabled, bool totalDiscount, String socialLink, String socialLinkTitle, bool emailNotice, bool loggedIn, bool isAdmin, int unread
});




}
/// @nodoc
class _$SiteConfigCopyWithImpl<$Res>
    implements $SiteConfigCopyWith<$Res> {
  _$SiteConfigCopyWithImpl(this._self, this._then);

  final SiteConfig _self;
  final $Res Function(SiteConfig) _then;

/// Create a copy of SiteConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? applicationName = null,Object? description = null,Object? hostName = null,Object? adminAddress = null,Object? albumEnabled = null,Object? rechargeMode = null,Object? alipayEnabled = null,Object? totalDiscount = null,Object? socialLink = null,Object? socialLinkTitle = null,Object? emailNotice = null,Object? loggedIn = null,Object? isAdmin = null,Object? unread = null,}) {
  return _then(SiteConfig(
applicationName: null == applicationName ? _self.applicationName : applicationName // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,hostName: null == hostName ? _self.hostName : hostName // ignore: cast_nullable_to_non_nullable
as String,adminAddress: null == adminAddress ? _self.adminAddress : adminAddress // ignore: cast_nullable_to_non_nullable
as String,albumEnabled: null == albumEnabled ? _self.albumEnabled : albumEnabled // ignore: cast_nullable_to_non_nullable
as bool,rechargeMode: null == rechargeMode ? _self.rechargeMode : rechargeMode // ignore: cast_nullable_to_non_nullable
as bool,alipayEnabled: null == alipayEnabled ? _self.alipayEnabled : alipayEnabled // ignore: cast_nullable_to_non_nullable
as bool,totalDiscount: null == totalDiscount ? _self.totalDiscount : totalDiscount // ignore: cast_nullable_to_non_nullable
as bool,socialLink: null == socialLink ? _self.socialLink : socialLink // ignore: cast_nullable_to_non_nullable
as String,socialLinkTitle: null == socialLinkTitle ? _self.socialLinkTitle : socialLinkTitle // ignore: cast_nullable_to_non_nullable
as String,emailNotice: null == emailNotice ? _self.emailNotice : emailNotice // ignore: cast_nullable_to_non_nullable
as bool,loggedIn: null == loggedIn ? _self.loggedIn : loggedIn // ignore: cast_nullable_to_non_nullable
as bool,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,unread: null == unread ? _self.unread : unread // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SiteConfig].
extension SiteConfigPatterns on SiteConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SiteConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SiteConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SiteConfig value)  $default,){
final _that = this;
switch (_that) {
case _SiteConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SiteConfig value)?  $default,){
final _that = this;
switch (_that) {
case _SiteConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String applicationName,  String description,  String hostName,  String adminAddress,  bool albumEnabled,  bool rechargeMode,  bool alipayEnabled,  bool totalDiscount,  String socialLink,  String socialLinkTitle,  bool emailNotice,  bool loggedIn,  bool isAdmin,  int unread)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SiteConfig() when $default != null:
return $default(_that.applicationName,_that.description,_that.hostName,_that.adminAddress,_that.albumEnabled,_that.rechargeMode,_that.alipayEnabled,_that.totalDiscount,_that.socialLink,_that.socialLinkTitle,_that.emailNotice,_that.loggedIn,_that.isAdmin,_that.unread);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String applicationName,  String description,  String hostName,  String adminAddress,  bool albumEnabled,  bool rechargeMode,  bool alipayEnabled,  bool totalDiscount,  String socialLink,  String socialLinkTitle,  bool emailNotice,  bool loggedIn,  bool isAdmin,  int unread)  $default,) {final _that = this;
switch (_that) {
case _SiteConfig():
return $default(_that.applicationName,_that.description,_that.hostName,_that.adminAddress,_that.albumEnabled,_that.rechargeMode,_that.alipayEnabled,_that.totalDiscount,_that.socialLink,_that.socialLinkTitle,_that.emailNotice,_that.loggedIn,_that.isAdmin,_that.unread);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String applicationName,  String description,  String hostName,  String adminAddress,  bool albumEnabled,  bool rechargeMode,  bool alipayEnabled,  bool totalDiscount,  String socialLink,  String socialLinkTitle,  bool emailNotice,  bool loggedIn,  bool isAdmin,  int unread)?  $default,) {final _that = this;
switch (_that) {
case _SiteConfig() when $default != null:
return $default(_that.applicationName,_that.description,_that.hostName,_that.adminAddress,_that.albumEnabled,_that.rechargeMode,_that.alipayEnabled,_that.totalDiscount,_that.socialLink,_that.socialLinkTitle,_that.emailNotice,_that.loggedIn,_that.isAdmin,_that.unread);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SiteConfig implements SiteConfig {
  const _SiteConfig({this.applicationName = '', this.description = '', this.hostName = '', this.adminAddress = '', this.albumEnabled = false, this.rechargeMode = false, this.alipayEnabled = false, this.totalDiscount = false, this.socialLink = '', this.socialLinkTitle = '', this.emailNotice = false, this.loggedIn = false, this.isAdmin = false, this.unread = 0});
  factory _SiteConfig.fromJson(Map<String, dynamic> json) => _$SiteConfigFromJson(json);

@override@JsonKey() final  String applicationName;
@override@JsonKey() final  String description;
@override@JsonKey() final  String hostName;
@override@JsonKey() final  String adminAddress;
@override@JsonKey() final  bool albumEnabled;
@override@JsonKey() final  bool rechargeMode;
@override@JsonKey() final  bool alipayEnabled;
@override@JsonKey() final  bool totalDiscount;
@override@JsonKey() final  String socialLink;
@override@JsonKey() final  String socialLinkTitle;
@override@JsonKey() final  bool emailNotice;
/// Always present, so the shell can build the navigation bar from one
/// request. False and zero for an anonymous visitor.
@override@JsonKey() final  bool loggedIn;
@override@JsonKey() final  bool isAdmin;
@override@JsonKey() final  int unread;

/// Create a copy of SiteConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SiteConfigCopyWith<_SiteConfig> get copyWith => __$SiteConfigCopyWithImpl<_SiteConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SiteConfigToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SiteConfig&&(identical(other.applicationName, applicationName) || other.applicationName == applicationName)&&(identical(other.description, description) || other.description == description)&&(identical(other.hostName, hostName) || other.hostName == hostName)&&(identical(other.adminAddress, adminAddress) || other.adminAddress == adminAddress)&&(identical(other.albumEnabled, albumEnabled) || other.albumEnabled == albumEnabled)&&(identical(other.rechargeMode, rechargeMode) || other.rechargeMode == rechargeMode)&&(identical(other.alipayEnabled, alipayEnabled) || other.alipayEnabled == alipayEnabled)&&(identical(other.totalDiscount, totalDiscount) || other.totalDiscount == totalDiscount)&&(identical(other.socialLink, socialLink) || other.socialLink == socialLink)&&(identical(other.socialLinkTitle, socialLinkTitle) || other.socialLinkTitle == socialLinkTitle)&&(identical(other.emailNotice, emailNotice) || other.emailNotice == emailNotice)&&(identical(other.loggedIn, loggedIn) || other.loggedIn == loggedIn)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.unread, unread) || other.unread == unread));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,applicationName,description,hostName,adminAddress,albumEnabled,rechargeMode,alipayEnabled,totalDiscount,socialLink,socialLinkTitle,emailNotice,loggedIn,isAdmin,unread);
}

@override
String toString() {
    return 'SiteConfig(applicationName: $applicationName, description: $description, hostName: $hostName, adminAddress: $adminAddress, albumEnabled: $albumEnabled, rechargeMode: $rechargeMode, alipayEnabled: $alipayEnabled, totalDiscount: $totalDiscount, socialLink: $socialLink, socialLinkTitle: $socialLinkTitle, emailNotice: $emailNotice, loggedIn: $loggedIn, isAdmin: $isAdmin, unread: $unread)';
}


}

/// @nodoc
abstract mixin class _$SiteConfigCopyWith<$Res> implements $SiteConfigCopyWith<$Res> {
  factory _$SiteConfigCopyWith(_SiteConfig value, $Res Function(_SiteConfig) _then) = __$SiteConfigCopyWithImpl;
@override @useResult
$Res call({
 String applicationName, String description, String hostName, String adminAddress, bool albumEnabled, bool rechargeMode, bool alipayEnabled, bool totalDiscount, String socialLink, String socialLinkTitle, bool emailNotice, bool loggedIn, bool isAdmin, int unread
});




}
/// @nodoc
class __$SiteConfigCopyWithImpl<$Res>
    implements _$SiteConfigCopyWith<$Res> {
  __$SiteConfigCopyWithImpl(this._self, this._then);

  final _SiteConfig _self;
  final $Res Function(_SiteConfig) _then;

/// Create a copy of SiteConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? applicationName = null,Object? description = null,Object? hostName = null,Object? adminAddress = null,Object? albumEnabled = null,Object? rechargeMode = null,Object? alipayEnabled = null,Object? totalDiscount = null,Object? socialLink = null,Object? socialLinkTitle = null,Object? emailNotice = null,Object? loggedIn = null,Object? isAdmin = null,Object? unread = null,}) {
  return _then(_SiteConfig(
applicationName: null == applicationName ? _self.applicationName : applicationName // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,hostName: null == hostName ? _self.hostName : hostName // ignore: cast_nullable_to_non_nullable
as String,adminAddress: null == adminAddress ? _self.adminAddress : adminAddress // ignore: cast_nullable_to_non_nullable
as String,albumEnabled: null == albumEnabled ? _self.albumEnabled : albumEnabled // ignore: cast_nullable_to_non_nullable
as bool,rechargeMode: null == rechargeMode ? _self.rechargeMode : rechargeMode // ignore: cast_nullable_to_non_nullable
as bool,alipayEnabled: null == alipayEnabled ? _self.alipayEnabled : alipayEnabled // ignore: cast_nullable_to_non_nullable
as bool,totalDiscount: null == totalDiscount ? _self.totalDiscount : totalDiscount // ignore: cast_nullable_to_non_nullable
as bool,socialLink: null == socialLink ? _self.socialLink : socialLink // ignore: cast_nullable_to_non_nullable
as String,socialLinkTitle: null == socialLinkTitle ? _self.socialLinkTitle : socialLinkTitle // ignore: cast_nullable_to_non_nullable
as String,emailNotice: null == emailNotice ? _self.emailNotice : emailNotice // ignore: cast_nullable_to_non_nullable
as bool,loggedIn: null == loggedIn ? _self.loggedIn : loggedIn // ignore: cast_nullable_to_non_nullable
as bool,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,unread: null == unread ? _self.unread : unread // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Intro {

 String get key; String get value; String get label;/// Marks a bullet that carries an extra explanation; used for the retention
/// bullet when the site sends expiry mail.
 bool get hint;
/// Create a copy of Intro
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IntroCopyWith<Intro> get copyWith => _$IntroCopyWithImpl<Intro>(this as Intro, _$identity);

  /// Serializes this Intro to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Intro;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Intro&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.value, _this.value) || other.value == _this.value)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.hint, _this.hint) || other.hint == _this.hint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Intro;
  return Object.hash(runtimeType,_this.key,_this.value,_this.label,_this.hint);
}

@override
String toString() {
  final _this = this as Intro;
  return 'Intro(key: ${_this.key}, value: ${_this.value}, label: ${_this.label}, hint: ${_this.hint})';
}


}

/// @nodoc
abstract mixin class $IntroCopyWith<$Res>  {
  factory $IntroCopyWith(Intro value, $Res Function(Intro) _then) = _$IntroCopyWithImpl;
@useResult
$Res call({
 String key, String value, String label, bool hint
});




}
/// @nodoc
class _$IntroCopyWithImpl<$Res>
    implements $IntroCopyWith<$Res> {
  _$IntroCopyWithImpl(this._self, this._then);

  final Intro _self;
  final $Res Function(Intro) _then;

/// Create a copy of Intro
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? value = null,Object? label = null,Object? hint = null,}) {
  return _then(Intro(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,hint: null == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Intro].
extension IntroPatterns on Intro {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Intro value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Intro() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Intro value)  $default,){
final _that = this;
switch (_that) {
case _Intro():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Intro value)?  $default,){
final _that = this;
switch (_that) {
case _Intro() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String value,  String label,  bool hint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Intro() when $default != null:
return $default(_that.key,_that.value,_that.label,_that.hint);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String value,  String label,  bool hint)  $default,) {final _that = this;
switch (_that) {
case _Intro():
return $default(_that.key,_that.value,_that.label,_that.hint);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String value,  String label,  bool hint)?  $default,) {final _that = this;
switch (_that) {
case _Intro() when $default != null:
return $default(_that.key,_that.value,_that.label,_that.hint);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Intro implements Intro {
  const _Intro({this.key = '', this.value = '', this.label = '', this.hint = false});
  factory _Intro.fromJson(Map<String, dynamic> json) => _$IntroFromJson(json);

@override@JsonKey() final  String key;
@override@JsonKey() final  String value;
@override@JsonKey() final  String label;
/// Marks a bullet that carries an extra explanation; used for the retention
/// bullet when the site sends expiry mail.
@override@JsonKey() final  bool hint;

/// Create a copy of Intro
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IntroCopyWith<_Intro> get copyWith => __$IntroCopyWithImpl<_Intro>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IntroToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Intro&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value)&&(identical(other.label, label) || other.label == label)&&(identical(other.hint, hint) || other.hint == hint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,value,label,hint);
}

@override
String toString() {
    return 'Intro(key: $key, value: $value, label: $label, hint: $hint)';
}


}

/// @nodoc
abstract mixin class _$IntroCopyWith<$Res> implements $IntroCopyWith<$Res> {
  factory _$IntroCopyWith(_Intro value, $Res Function(_Intro) _then) = __$IntroCopyWithImpl;
@override @useResult
$Res call({
 String key, String value, String label, bool hint
});




}
/// @nodoc
class __$IntroCopyWithImpl<$Res>
    implements _$IntroCopyWith<$Res> {
  __$IntroCopyWithImpl(this._self, this._then);

  final _Intro _self;
  final $Res Function(_Intro) _then;

/// Create a copy of Intro
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? value = null,Object? label = null,Object? hint = null,}) {
  return _then(_Intro(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,hint: null == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ProductCard {

 String get specId; String get wareName; int get discount; List<Intro> get intros;/// The total for the billing cycle of the bucket this card sits in.
 int get price;/// The monthly list price before the discount.
 int get monthPrice; int get validDays; int get deleteDays; int get memory; int get cpu; int get disk; int get backups; int get nest; int get egg; List<int> get allowedEggIds;
/// Create a copy of ProductCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCardCopyWith<ProductCard> get copyWith => _$ProductCardCopyWithImpl<ProductCard>(this as ProductCard, _$identity);

  /// Serializes this ProductCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProductCard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductCard&&(identical(other.specId, _this.specId) || other.specId == _this.specId)&&(identical(other.wareName, _this.wareName) || other.wareName == _this.wareName)&&(identical(other.discount, _this.discount) || other.discount == _this.discount)&&const DeepCollectionEquality().equals(other.intros, _this.intros)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.monthPrice, _this.monthPrice) || other.monthPrice == _this.monthPrice)&&(identical(other.validDays, _this.validDays) || other.validDays == _this.validDays)&&(identical(other.deleteDays, _this.deleteDays) || other.deleteDays == _this.deleteDays)&&(identical(other.memory, _this.memory) || other.memory == _this.memory)&&(identical(other.cpu, _this.cpu) || other.cpu == _this.cpu)&&(identical(other.disk, _this.disk) || other.disk == _this.disk)&&(identical(other.backups, _this.backups) || other.backups == _this.backups)&&(identical(other.nest, _this.nest) || other.nest == _this.nest)&&(identical(other.egg, _this.egg) || other.egg == _this.egg)&&const DeepCollectionEquality().equals(other.allowedEggIds, _this.allowedEggIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProductCard;
  return Object.hash(runtimeType,_this.specId,_this.wareName,_this.discount,const DeepCollectionEquality().hash(_this.intros),_this.price,_this.monthPrice,_this.validDays,_this.deleteDays,_this.memory,_this.cpu,_this.disk,_this.backups,_this.nest,_this.egg,const DeepCollectionEquality().hash(_this.allowedEggIds));
}

@override
String toString() {
  final _this = this as ProductCard;
  return 'ProductCard(specId: ${_this.specId}, wareName: ${_this.wareName}, discount: ${_this.discount}, intros: ${_this.intros}, price: ${_this.price}, monthPrice: ${_this.monthPrice}, validDays: ${_this.validDays}, deleteDays: ${_this.deleteDays}, memory: ${_this.memory}, cpu: ${_this.cpu}, disk: ${_this.disk}, backups: ${_this.backups}, nest: ${_this.nest}, egg: ${_this.egg}, allowedEggIds: ${_this.allowedEggIds})';
}


}

/// @nodoc
abstract mixin class $ProductCardCopyWith<$Res>  {
  factory $ProductCardCopyWith(ProductCard value, $Res Function(ProductCard) _then) = _$ProductCardCopyWithImpl;
@useResult
$Res call({
 String specId, String wareName, int discount, List<Intro> intros, int price, int monthPrice, int validDays, int deleteDays, int memory, int cpu, int disk, int backups, int nest, int egg, List<int> allowedEggIds
});




}
/// @nodoc
class _$ProductCardCopyWithImpl<$Res>
    implements $ProductCardCopyWith<$Res> {
  _$ProductCardCopyWithImpl(this._self, this._then);

  final ProductCard _self;
  final $Res Function(ProductCard) _then;

/// Create a copy of ProductCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? specId = null,Object? wareName = null,Object? discount = null,Object? intros = null,Object? price = null,Object? monthPrice = null,Object? validDays = null,Object? deleteDays = null,Object? memory = null,Object? cpu = null,Object? disk = null,Object? backups = null,Object? nest = null,Object? egg = null,Object? allowedEggIds = null,}) {
  return _then(ProductCard(
specId: null == specId ? _self.specId : specId // ignore: cast_nullable_to_non_nullable
as String,wareName: null == wareName ? _self.wareName : wareName // ignore: cast_nullable_to_non_nullable
as String,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as int,intros: null == intros ? _self.intros : intros // ignore: cast_nullable_to_non_nullable
as List<Intro>,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,monthPrice: null == monthPrice ? _self.monthPrice : monthPrice // ignore: cast_nullable_to_non_nullable
as int,validDays: null == validDays ? _self.validDays : validDays // ignore: cast_nullable_to_non_nullable
as int,deleteDays: null == deleteDays ? _self.deleteDays : deleteDays // ignore: cast_nullable_to_non_nullable
as int,memory: null == memory ? _self.memory : memory // ignore: cast_nullable_to_non_nullable
as int,cpu: null == cpu ? _self.cpu : cpu // ignore: cast_nullable_to_non_nullable
as int,disk: null == disk ? _self.disk : disk // ignore: cast_nullable_to_non_nullable
as int,backups: null == backups ? _self.backups : backups // ignore: cast_nullable_to_non_nullable
as int,nest: null == nest ? _self.nest : nest // ignore: cast_nullable_to_non_nullable
as int,egg: null == egg ? _self.egg : egg // ignore: cast_nullable_to_non_nullable
as int,allowedEggIds: null == allowedEggIds ? _self.allowedEggIds : allowedEggIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductCard].
extension ProductCardPatterns on ProductCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductCard value)  $default,){
final _that = this;
switch (_that) {
case _ProductCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductCard value)?  $default,){
final _that = this;
switch (_that) {
case _ProductCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String specId,  String wareName,  int discount,  List<Intro> intros,  int price,  int monthPrice,  int validDays,  int deleteDays,  int memory,  int cpu,  int disk,  int backups,  int nest,  int egg,  List<int> allowedEggIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductCard() when $default != null:
return $default(_that.specId,_that.wareName,_that.discount,_that.intros,_that.price,_that.monthPrice,_that.validDays,_that.deleteDays,_that.memory,_that.cpu,_that.disk,_that.backups,_that.nest,_that.egg,_that.allowedEggIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String specId,  String wareName,  int discount,  List<Intro> intros,  int price,  int monthPrice,  int validDays,  int deleteDays,  int memory,  int cpu,  int disk,  int backups,  int nest,  int egg,  List<int> allowedEggIds)  $default,) {final _that = this;
switch (_that) {
case _ProductCard():
return $default(_that.specId,_that.wareName,_that.discount,_that.intros,_that.price,_that.monthPrice,_that.validDays,_that.deleteDays,_that.memory,_that.cpu,_that.disk,_that.backups,_that.nest,_that.egg,_that.allowedEggIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String specId,  String wareName,  int discount,  List<Intro> intros,  int price,  int monthPrice,  int validDays,  int deleteDays,  int memory,  int cpu,  int disk,  int backups,  int nest,  int egg,  List<int> allowedEggIds)?  $default,) {final _that = this;
switch (_that) {
case _ProductCard() when $default != null:
return $default(_that.specId,_that.wareName,_that.discount,_that.intros,_that.price,_that.monthPrice,_that.validDays,_that.deleteDays,_that.memory,_that.cpu,_that.disk,_that.backups,_that.nest,_that.egg,_that.allowedEggIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductCard extends ProductCard {
  const _ProductCard({this.specId = '', this.wareName = '', this.discount = 0,  List<Intro> intros = const <Intro>[], this.price = 0, this.monthPrice = 0, this.validDays = 0, this.deleteDays = 0, this.memory = 0, this.cpu = 0, this.disk = 0, this.backups = 0, this.nest = 0, this.egg = 0,  List<int> allowedEggIds = const <int>[]}): _intros = intros,_allowedEggIds = allowedEggIds,super._();
  factory _ProductCard.fromJson(Map<String, dynamic> json) => _$ProductCardFromJson(json);

@override@JsonKey() final  String specId;
@override@JsonKey() final  String wareName;
@override@JsonKey() final  int discount;
 final  List<Intro> _intros;
@override@JsonKey() List<Intro> get intros {
  if (_intros is EqualUnmodifiableListView) return _intros;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_intros);
}

/// The total for the billing cycle of the bucket this card sits in.
@override@JsonKey() final  int price;
/// The monthly list price before the discount.
@override@JsonKey() final  int monthPrice;
@override@JsonKey() final  int validDays;
@override@JsonKey() final  int deleteDays;
@override@JsonKey() final  int memory;
@override@JsonKey() final  int cpu;
@override@JsonKey() final  int disk;
@override@JsonKey() final  int backups;
@override@JsonKey() final  int nest;
@override@JsonKey() final  int egg;
 final  List<int> _allowedEggIds;
@override@JsonKey() List<int> get allowedEggIds {
  if (_allowedEggIds is EqualUnmodifiableListView) return _allowedEggIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allowedEggIds);
}


/// Create a copy of ProductCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCardCopyWith<_ProductCard> get copyWith => __$ProductCardCopyWithImpl<_ProductCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductCardToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductCard&&(identical(other.specId, specId) || other.specId == specId)&&(identical(other.wareName, wareName) || other.wareName == wareName)&&(identical(other.discount, discount) || other.discount == discount)&&const DeepCollectionEquality().equals(other.intros, _intros)&&(identical(other.price, price) || other.price == price)&&(identical(other.monthPrice, monthPrice) || other.monthPrice == monthPrice)&&(identical(other.validDays, validDays) || other.validDays == validDays)&&(identical(other.deleteDays, deleteDays) || other.deleteDays == deleteDays)&&(identical(other.memory, memory) || other.memory == memory)&&(identical(other.cpu, cpu) || other.cpu == cpu)&&(identical(other.disk, disk) || other.disk == disk)&&(identical(other.backups, backups) || other.backups == backups)&&(identical(other.nest, nest) || other.nest == nest)&&(identical(other.egg, egg) || other.egg == egg)&&const DeepCollectionEquality().equals(other.allowedEggIds, _allowedEggIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,specId,wareName,discount,const DeepCollectionEquality().hash(_intros),price,monthPrice,validDays,deleteDays,memory,cpu,disk,backups,nest,egg,const DeepCollectionEquality().hash(_allowedEggIds));
}

@override
String toString() {
    return 'ProductCard(specId: $specId, wareName: $wareName, discount: $discount, intros: $intros, price: $price, monthPrice: $monthPrice, validDays: $validDays, deleteDays: $deleteDays, memory: $memory, cpu: $cpu, disk: $disk, backups: $backups, nest: $nest, egg: $egg, allowedEggIds: $allowedEggIds)';
}


}

/// @nodoc
abstract mixin class _$ProductCardCopyWith<$Res> implements $ProductCardCopyWith<$Res> {
  factory _$ProductCardCopyWith(_ProductCard value, $Res Function(_ProductCard) _then) = __$ProductCardCopyWithImpl;
@override @useResult
$Res call({
 String specId, String wareName, int discount, List<Intro> intros, int price, int monthPrice, int validDays, int deleteDays, int memory, int cpu, int disk, int backups, int nest, int egg, List<int> allowedEggIds
});




}
/// @nodoc
class __$ProductCardCopyWithImpl<$Res>
    implements _$ProductCardCopyWith<$Res> {
  __$ProductCardCopyWithImpl(this._self, this._then);

  final _ProductCard _self;
  final $Res Function(_ProductCard) _then;

/// Create a copy of ProductCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? specId = null,Object? wareName = null,Object? discount = null,Object? intros = null,Object? price = null,Object? monthPrice = null,Object? validDays = null,Object? deleteDays = null,Object? memory = null,Object? cpu = null,Object? disk = null,Object? backups = null,Object? nest = null,Object? egg = null,Object? allowedEggIds = null,}) {
  return _then(_ProductCard(
specId: null == specId ? _self.specId : specId // ignore: cast_nullable_to_non_nullable
as String,wareName: null == wareName ? _self.wareName : wareName // ignore: cast_nullable_to_non_nullable
as String,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as int,intros: null == intros ? _self._intros : intros // ignore: cast_nullable_to_non_nullable
as List<Intro>,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,monthPrice: null == monthPrice ? _self.monthPrice : monthPrice // ignore: cast_nullable_to_non_nullable
as int,validDays: null == validDays ? _self.validDays : validDays // ignore: cast_nullable_to_non_nullable
as int,deleteDays: null == deleteDays ? _self.deleteDays : deleteDays // ignore: cast_nullable_to_non_nullable
as int,memory: null == memory ? _self.memory : memory // ignore: cast_nullable_to_non_nullable
as int,cpu: null == cpu ? _self.cpu : cpu // ignore: cast_nullable_to_non_nullable
as int,disk: null == disk ? _self.disk : disk // ignore: cast_nullable_to_non_nullable
as int,backups: null == backups ? _self.backups : backups // ignore: cast_nullable_to_non_nullable
as int,nest: null == nest ? _self.nest : nest // ignore: cast_nullable_to_non_nullable
as int,egg: null == egg ? _self.egg : egg // ignore: cast_nullable_to_non_nullable
as int,allowedEggIds: null == allowedEggIds ? _self._allowedEggIds : allowedEggIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}


/// @nodoc
mixin _$Storefront {

 List<ProductCard> get monthly; List<ProductCard> get quarterly; List<ProductCard> get yearly; bool get emailNotice;
/// Create a copy of Storefront
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorefrontCopyWith<Storefront> get copyWith => _$StorefrontCopyWithImpl<Storefront>(this as Storefront, _$identity);

  /// Serializes this Storefront to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Storefront;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Storefront&&const DeepCollectionEquality().equals(other.monthly, _this.monthly)&&const DeepCollectionEquality().equals(other.quarterly, _this.quarterly)&&const DeepCollectionEquality().equals(other.yearly, _this.yearly)&&(identical(other.emailNotice, _this.emailNotice) || other.emailNotice == _this.emailNotice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Storefront;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.monthly),const DeepCollectionEquality().hash(_this.quarterly),const DeepCollectionEquality().hash(_this.yearly),_this.emailNotice);
}

@override
String toString() {
  final _this = this as Storefront;
  return 'Storefront(monthly: ${_this.monthly}, quarterly: ${_this.quarterly}, yearly: ${_this.yearly}, emailNotice: ${_this.emailNotice})';
}


}

/// @nodoc
abstract mixin class $StorefrontCopyWith<$Res>  {
  factory $StorefrontCopyWith(Storefront value, $Res Function(Storefront) _then) = _$StorefrontCopyWithImpl;
@useResult
$Res call({
 List<ProductCard> monthly, List<ProductCard> quarterly, List<ProductCard> yearly, bool emailNotice
});




}
/// @nodoc
class _$StorefrontCopyWithImpl<$Res>
    implements $StorefrontCopyWith<$Res> {
  _$StorefrontCopyWithImpl(this._self, this._then);

  final Storefront _self;
  final $Res Function(Storefront) _then;

/// Create a copy of Storefront
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monthly = null,Object? quarterly = null,Object? yearly = null,Object? emailNotice = null,}) {
  return _then(Storefront(
monthly: null == monthly ? _self.monthly : monthly // ignore: cast_nullable_to_non_nullable
as List<ProductCard>,quarterly: null == quarterly ? _self.quarterly : quarterly // ignore: cast_nullable_to_non_nullable
as List<ProductCard>,yearly: null == yearly ? _self.yearly : yearly // ignore: cast_nullable_to_non_nullable
as List<ProductCard>,emailNotice: null == emailNotice ? _self.emailNotice : emailNotice // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Storefront].
extension StorefrontPatterns on Storefront {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Storefront value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Storefront() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Storefront value)  $default,){
final _that = this;
switch (_that) {
case _Storefront():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Storefront value)?  $default,){
final _that = this;
switch (_that) {
case _Storefront() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ProductCard> monthly,  List<ProductCard> quarterly,  List<ProductCard> yearly,  bool emailNotice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Storefront() when $default != null:
return $default(_that.monthly,_that.quarterly,_that.yearly,_that.emailNotice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ProductCard> monthly,  List<ProductCard> quarterly,  List<ProductCard> yearly,  bool emailNotice)  $default,) {final _that = this;
switch (_that) {
case _Storefront():
return $default(_that.monthly,_that.quarterly,_that.yearly,_that.emailNotice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ProductCard> monthly,  List<ProductCard> quarterly,  List<ProductCard> yearly,  bool emailNotice)?  $default,) {final _that = this;
switch (_that) {
case _Storefront() when $default != null:
return $default(_that.monthly,_that.quarterly,_that.yearly,_that.emailNotice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Storefront implements Storefront {
  const _Storefront({ List<ProductCard> monthly = const <ProductCard>[],  List<ProductCard> quarterly = const <ProductCard>[],  List<ProductCard> yearly = const <ProductCard>[], this.emailNotice = false}): _monthly = monthly,_quarterly = quarterly,_yearly = yearly;
  factory _Storefront.fromJson(Map<String, dynamic> json) => _$StorefrontFromJson(json);

 final  List<ProductCard> _monthly;
@override@JsonKey() List<ProductCard> get monthly {
  if (_monthly is EqualUnmodifiableListView) return _monthly;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_monthly);
}

 final  List<ProductCard> _quarterly;
@override@JsonKey() List<ProductCard> get quarterly {
  if (_quarterly is EqualUnmodifiableListView) return _quarterly;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_quarterly);
}

 final  List<ProductCard> _yearly;
@override@JsonKey() List<ProductCard> get yearly {
  if (_yearly is EqualUnmodifiableListView) return _yearly;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_yearly);
}

@override@JsonKey() final  bool emailNotice;

/// Create a copy of Storefront
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorefrontCopyWith<_Storefront> get copyWith => __$StorefrontCopyWithImpl<_Storefront>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorefrontToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Storefront&&const DeepCollectionEquality().equals(other.monthly, _monthly)&&const DeepCollectionEquality().equals(other.quarterly, _quarterly)&&const DeepCollectionEquality().equals(other.yearly, _yearly)&&(identical(other.emailNotice, emailNotice) || other.emailNotice == emailNotice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_monthly),const DeepCollectionEquality().hash(_quarterly),const DeepCollectionEquality().hash(_yearly),emailNotice);
}

@override
String toString() {
    return 'Storefront(monthly: $monthly, quarterly: $quarterly, yearly: $yearly, emailNotice: $emailNotice)';
}


}

/// @nodoc
abstract mixin class _$StorefrontCopyWith<$Res> implements $StorefrontCopyWith<$Res> {
  factory _$StorefrontCopyWith(_Storefront value, $Res Function(_Storefront) _then) = __$StorefrontCopyWithImpl;
@override @useResult
$Res call({
 List<ProductCard> monthly, List<ProductCard> quarterly, List<ProductCard> yearly, bool emailNotice
});




}
/// @nodoc
class __$StorefrontCopyWithImpl<$Res>
    implements _$StorefrontCopyWith<$Res> {
  __$StorefrontCopyWithImpl(this._self, this._then);

  final _Storefront _self;
  final $Res Function(_Storefront) _then;

/// Create a copy of Storefront
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monthly = null,Object? quarterly = null,Object? yearly = null,Object? emailNotice = null,}) {
  return _then(_Storefront(
monthly: null == monthly ? _self._monthly : monthly // ignore: cast_nullable_to_non_nullable
as List<ProductCard>,quarterly: null == quarterly ? _self._quarterly : quarterly // ignore: cast_nullable_to_non_nullable
as List<ProductCard>,yearly: null == yearly ? _self._yearly : yearly // ignore: cast_nullable_to_non_nullable
as List<ProductCard>,emailNotice: null == emailNotice ? _self.emailNotice : emailNotice // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Pricing {

 int get originPrice; int get finalPrice;
/// Create a copy of Pricing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PricingCopyWith<Pricing> get copyWith => _$PricingCopyWithImpl<Pricing>(this as Pricing, _$identity);

  /// Serializes this Pricing to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Pricing;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Pricing&&(identical(other.originPrice, _this.originPrice) || other.originPrice == _this.originPrice)&&(identical(other.finalPrice, _this.finalPrice) || other.finalPrice == _this.finalPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Pricing;
  return Object.hash(runtimeType,_this.originPrice,_this.finalPrice);
}

@override
String toString() {
  final _this = this as Pricing;
  return 'Pricing(originPrice: ${_this.originPrice}, finalPrice: ${_this.finalPrice})';
}


}

/// @nodoc
abstract mixin class $PricingCopyWith<$Res>  {
  factory $PricingCopyWith(Pricing value, $Res Function(Pricing) _then) = _$PricingCopyWithImpl;
@useResult
$Res call({
 int originPrice, int finalPrice
});




}
/// @nodoc
class _$PricingCopyWithImpl<$Res>
    implements $PricingCopyWith<$Res> {
  _$PricingCopyWithImpl(this._self, this._then);

  final Pricing _self;
  final $Res Function(Pricing) _then;

/// Create a copy of Pricing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? originPrice = null,Object? finalPrice = null,}) {
  return _then(Pricing(
originPrice: null == originPrice ? _self.originPrice : originPrice // ignore: cast_nullable_to_non_nullable
as int,finalPrice: null == finalPrice ? _self.finalPrice : finalPrice // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Pricing].
extension PricingPatterns on Pricing {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Pricing value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Pricing() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Pricing value)  $default,){
final _that = this;
switch (_that) {
case _Pricing():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Pricing value)?  $default,){
final _that = this;
switch (_that) {
case _Pricing() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int originPrice,  int finalPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Pricing() when $default != null:
return $default(_that.originPrice,_that.finalPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int originPrice,  int finalPrice)  $default,) {final _that = this;
switch (_that) {
case _Pricing():
return $default(_that.originPrice,_that.finalPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int originPrice,  int finalPrice)?  $default,) {final _that = this;
switch (_that) {
case _Pricing() when $default != null:
return $default(_that.originPrice,_that.finalPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Pricing implements Pricing {
  const _Pricing({this.originPrice = 0, this.finalPrice = 0});
  factory _Pricing.fromJson(Map<String, dynamic> json) => _$PricingFromJson(json);

@override@JsonKey() final  int originPrice;
@override@JsonKey() final  int finalPrice;

/// Create a copy of Pricing
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PricingCopyWith<_Pricing> get copyWith => __$PricingCopyWithImpl<_Pricing>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PricingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Pricing&&(identical(other.originPrice, originPrice) || other.originPrice == originPrice)&&(identical(other.finalPrice, finalPrice) || other.finalPrice == finalPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,originPrice,finalPrice);
}

@override
String toString() {
    return 'Pricing(originPrice: $originPrice, finalPrice: $finalPrice)';
}


}

/// @nodoc
abstract mixin class _$PricingCopyWith<$Res> implements $PricingCopyWith<$Res> {
  factory _$PricingCopyWith(_Pricing value, $Res Function(_Pricing) _then) = __$PricingCopyWithImpl;
@override @useResult
$Res call({
 int originPrice, int finalPrice
});




}
/// @nodoc
class __$PricingCopyWithImpl<$Res>
    implements _$PricingCopyWith<$Res> {
  __$PricingCopyWithImpl(this._self, this._then);

  final _Pricing _self;
  final $Res Function(_Pricing) _then;

/// Create a copy of Pricing
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? originPrice = null,Object? finalPrice = null,}) {
  return _then(_Pricing(
originPrice: null == originPrice ? _self.originPrice : originPrice // ignore: cast_nullable_to_non_nullable
as int,finalPrice: null == finalPrice ? _self.finalPrice : finalPrice // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Egg {

/// The JSON key is lowercase `id`, unlike every other identifier on the API.
 int get id; String get name;
/// Create a copy of Egg
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EggCopyWith<Egg> get copyWith => _$EggCopyWithImpl<Egg>(this as Egg, _$identity);

  /// Serializes this Egg to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Egg;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Egg&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Egg;
  return Object.hash(runtimeType,_this.id,_this.name);
}

@override
String toString() {
  final _this = this as Egg;
  return 'Egg(id: ${_this.id}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $EggCopyWith<$Res>  {
  factory $EggCopyWith(Egg value, $Res Function(Egg) _then) = _$EggCopyWithImpl;
@useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class _$EggCopyWithImpl<$Res>
    implements $EggCopyWith<$Res> {
  _$EggCopyWithImpl(this._self, this._then);

  final Egg _self;
  final $Res Function(Egg) _then;

/// Create a copy of Egg
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(Egg(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Egg].
extension EggPatterns on Egg {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Egg value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Egg() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Egg value)  $default,){
final _that = this;
switch (_that) {
case _Egg():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Egg value)?  $default,){
final _that = this;
switch (_that) {
case _Egg() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Egg() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name)  $default,) {final _that = this;
switch (_that) {
case _Egg():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _Egg() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Egg implements Egg {
  const _Egg({this.id = 0, this.name = ''});
  factory _Egg.fromJson(Map<String, dynamic> json) => _$EggFromJson(json);

/// The JSON key is lowercase `id`, unlike every other identifier on the API.
@override@JsonKey() final  int id;
@override@JsonKey() final  String name;

/// Create a copy of Egg
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EggCopyWith<_Egg> get copyWith => __$EggCopyWithImpl<_Egg>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EggToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Egg&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name);
}

@override
String toString() {
    return 'Egg(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$EggCopyWith<$Res> implements $EggCopyWith<$Res> {
  factory _$EggCopyWith(_Egg value, $Res Function(_Egg) _then) = __$EggCopyWithImpl;
@override @useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class __$EggCopyWithImpl<$Res>
    implements _$EggCopyWith<$Res> {
  __$EggCopyWithImpl(this._self, this._then);

  final _Egg _self;
  final $Res Function(_Egg) _then;

/// Create a copy of Egg
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_Egg(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ProductDetail {

 ProductCard get product; Pricing get pricing; String get nestName; String get eggName; List<Egg> get eggs;
/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDetailCopyWith<ProductDetail> get copyWith => _$ProductDetailCopyWithImpl<ProductDetail>(this as ProductDetail, _$identity);

  /// Serializes this ProductDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProductDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetail&&(identical(other.product, _this.product) || other.product == _this.product)&&(identical(other.pricing, _this.pricing) || other.pricing == _this.pricing)&&(identical(other.nestName, _this.nestName) || other.nestName == _this.nestName)&&(identical(other.eggName, _this.eggName) || other.eggName == _this.eggName)&&const DeepCollectionEquality().equals(other.eggs, _this.eggs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProductDetail;
  return Object.hash(runtimeType,_this.product,_this.pricing,_this.nestName,_this.eggName,const DeepCollectionEquality().hash(_this.eggs));
}

@override
String toString() {
  final _this = this as ProductDetail;
  return 'ProductDetail(product: ${_this.product}, pricing: ${_this.pricing}, nestName: ${_this.nestName}, eggName: ${_this.eggName}, eggs: ${_this.eggs})';
}


}

/// @nodoc
abstract mixin class $ProductDetailCopyWith<$Res>  {
  factory $ProductDetailCopyWith(ProductDetail value, $Res Function(ProductDetail) _then) = _$ProductDetailCopyWithImpl;
@useResult
$Res call({
 ProductCard product, Pricing pricing, String nestName, String eggName, List<Egg> eggs
});


$ProductCardCopyWith<$Res> get product;$PricingCopyWith<$Res> get pricing;

}
/// @nodoc
class _$ProductDetailCopyWithImpl<$Res>
    implements $ProductDetailCopyWith<$Res> {
  _$ProductDetailCopyWithImpl(this._self, this._then);

  final ProductDetail _self;
  final $Res Function(ProductDetail) _then;

/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? product = null,Object? pricing = null,Object? nestName = null,Object? eggName = null,Object? eggs = null,}) {
  return _then(ProductDetail(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductCard,pricing: null == pricing ? _self.pricing : pricing // ignore: cast_nullable_to_non_nullable
as Pricing,nestName: null == nestName ? _self.nestName : nestName // ignore: cast_nullable_to_non_nullable
as String,eggName: null == eggName ? _self.eggName : eggName // ignore: cast_nullable_to_non_nullable
as String,eggs: null == eggs ? _self.eggs : eggs // ignore: cast_nullable_to_non_nullable
as List<Egg>,
  ));
}
/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCardCopyWith<$Res> get product {
  
  return $ProductCardCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PricingCopyWith<$Res> get pricing {
  
  return $PricingCopyWith<$Res>(_self.pricing, (value) {
    return _then(_self.copyWith(pricing: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductDetail].
extension ProductDetailPatterns on ProductDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductDetail value)  $default,){
final _that = this;
switch (_that) {
case _ProductDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ProductDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProductCard product,  Pricing pricing,  String nestName,  String eggName,  List<Egg> eggs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductDetail() when $default != null:
return $default(_that.product,_that.pricing,_that.nestName,_that.eggName,_that.eggs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProductCard product,  Pricing pricing,  String nestName,  String eggName,  List<Egg> eggs)  $default,) {final _that = this;
switch (_that) {
case _ProductDetail():
return $default(_that.product,_that.pricing,_that.nestName,_that.eggName,_that.eggs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProductCard product,  Pricing pricing,  String nestName,  String eggName,  List<Egg> eggs)?  $default,) {final _that = this;
switch (_that) {
case _ProductDetail() when $default != null:
return $default(_that.product,_that.pricing,_that.nestName,_that.eggName,_that.eggs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductDetail implements ProductDetail {
  const _ProductDetail({required this.product, required this.pricing, this.nestName = '', this.eggName = '',  List<Egg> eggs = const <Egg>[]}): _eggs = eggs;
  factory _ProductDetail.fromJson(Map<String, dynamic> json) => _$ProductDetailFromJson(json);

@override final  ProductCard product;
@override final  Pricing pricing;
@override@JsonKey() final  String nestName;
@override@JsonKey() final  String eggName;
 final  List<Egg> _eggs;
@override@JsonKey() List<Egg> get eggs {
  if (_eggs is EqualUnmodifiableListView) return _eggs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_eggs);
}


/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductDetailCopyWith<_ProductDetail> get copyWith => __$ProductDetailCopyWithImpl<_ProductDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductDetail&&(identical(other.product, product) || other.product == product)&&(identical(other.pricing, pricing) || other.pricing == pricing)&&(identical(other.nestName, nestName) || other.nestName == nestName)&&(identical(other.eggName, eggName) || other.eggName == eggName)&&const DeepCollectionEquality().equals(other.eggs, _eggs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,product,pricing,nestName,eggName,const DeepCollectionEquality().hash(_eggs));
}

@override
String toString() {
    return 'ProductDetail(product: $product, pricing: $pricing, nestName: $nestName, eggName: $eggName, eggs: $eggs)';
}


}

/// @nodoc
abstract mixin class _$ProductDetailCopyWith<$Res> implements $ProductDetailCopyWith<$Res> {
  factory _$ProductDetailCopyWith(_ProductDetail value, $Res Function(_ProductDetail) _then) = __$ProductDetailCopyWithImpl;
@override @useResult
$Res call({
 ProductCard product, Pricing pricing, String nestName, String eggName, List<Egg> eggs
});


@override $ProductCardCopyWith<$Res> get product;@override $PricingCopyWith<$Res> get pricing;

}
/// @nodoc
class __$ProductDetailCopyWithImpl<$Res>
    implements _$ProductDetailCopyWith<$Res> {
  __$ProductDetailCopyWithImpl(this._self, this._then);

  final _ProductDetail _self;
  final $Res Function(_ProductDetail) _then;

/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? product = null,Object? pricing = null,Object? nestName = null,Object? eggName = null,Object? eggs = null,}) {
  return _then(_ProductDetail(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductCard,pricing: null == pricing ? _self.pricing : pricing // ignore: cast_nullable_to_non_nullable
as Pricing,nestName: null == nestName ? _self.nestName : nestName // ignore: cast_nullable_to_non_nullable
as String,eggName: null == eggName ? _self.eggName : eggName // ignore: cast_nullable_to_non_nullable
as String,eggs: null == eggs ? _self._eggs : eggs // ignore: cast_nullable_to_non_nullable
as List<Egg>,
  ));
}

/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCardCopyWith<$Res> get product {
  
  return $ProductCardCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PricingCopyWith<$Res> get pricing {
  
  return $PricingCopyWith<$Res>(_self.pricing, (value) {
    return _then(_self.copyWith(pricing: value));
  });
}
}


/// @nodoc
mixin _$ProductListResponse {

 List<WareSpec> get products;
/// Create a copy of ProductListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductListResponseCopyWith<ProductListResponse> get copyWith => _$ProductListResponseCopyWithImpl<ProductListResponse>(this as ProductListResponse, _$identity);

  /// Serializes this ProductListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProductListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductListResponse&&const DeepCollectionEquality().equals(other.products, _this.products));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProductListResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.products));
}

@override
String toString() {
  final _this = this as ProductListResponse;
  return 'ProductListResponse(products: ${_this.products})';
}


}

/// @nodoc
abstract mixin class $ProductListResponseCopyWith<$Res>  {
  factory $ProductListResponseCopyWith(ProductListResponse value, $Res Function(ProductListResponse) _then) = _$ProductListResponseCopyWithImpl;
@useResult
$Res call({
 List<WareSpec> products
});




}
/// @nodoc
class _$ProductListResponseCopyWithImpl<$Res>
    implements $ProductListResponseCopyWith<$Res> {
  _$ProductListResponseCopyWithImpl(this._self, this._then);

  final ProductListResponse _self;
  final $Res Function(ProductListResponse) _then;

/// Create a copy of ProductListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? products = null,}) {
  return _then(ProductListResponse(
products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<WareSpec>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductListResponse].
extension ProductListResponsePatterns on ProductListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductListResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProductListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProductListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<WareSpec> products)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<WareSpec> products)  $default,) {final _that = this;
switch (_that) {
case _ProductListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<WareSpec> products)?  $default,) {final _that = this;
switch (_that) {
case _ProductListResponse() when $default != null:
return $default(_that.products);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductListResponse implements ProductListResponse {
  const _ProductListResponse({ List<WareSpec> products = const <WareSpec>[]}): _products = products;
  factory _ProductListResponse.fromJson(Map<String, dynamic> json) => _$ProductListResponseFromJson(json);

 final  List<WareSpec> _products;
@override@JsonKey() List<WareSpec> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}


/// Create a copy of ProductListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductListResponseCopyWith<_ProductListResponse> get copyWith => __$ProductListResponseCopyWithImpl<_ProductListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductListResponse&&const DeepCollectionEquality().equals(other.products, _products));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_products));
}

@override
String toString() {
    return 'ProductListResponse(products: $products)';
}


}

/// @nodoc
abstract mixin class _$ProductListResponseCopyWith<$Res> implements $ProductListResponseCopyWith<$Res> {
  factory _$ProductListResponseCopyWith(_ProductListResponse value, $Res Function(_ProductListResponse) _then) = __$ProductListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<WareSpec> products
});




}
/// @nodoc
class __$ProductListResponseCopyWithImpl<$Res>
    implements _$ProductListResponseCopyWith<$Res> {
  __$ProductListResponseCopyWithImpl(this._self, this._then);

  final _ProductListResponse _self;
  final $Res Function(_ProductListResponse) _then;

/// Create a copy of ProductListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? products = null,}) {
  return _then(_ProductListResponse(
products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<WareSpec>,
  ));
}


}


/// @nodoc
mixin _$EggListResponse {

 List<Egg> get eggs;
/// Create a copy of EggListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EggListResponseCopyWith<EggListResponse> get copyWith => _$EggListResponseCopyWithImpl<EggListResponse>(this as EggListResponse, _$identity);

  /// Serializes this EggListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EggListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EggListResponse&&const DeepCollectionEquality().equals(other.eggs, _this.eggs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EggListResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.eggs));
}

@override
String toString() {
  final _this = this as EggListResponse;
  return 'EggListResponse(eggs: ${_this.eggs})';
}


}

/// @nodoc
abstract mixin class $EggListResponseCopyWith<$Res>  {
  factory $EggListResponseCopyWith(EggListResponse value, $Res Function(EggListResponse) _then) = _$EggListResponseCopyWithImpl;
@useResult
$Res call({
 List<Egg> eggs
});




}
/// @nodoc
class _$EggListResponseCopyWithImpl<$Res>
    implements $EggListResponseCopyWith<$Res> {
  _$EggListResponseCopyWithImpl(this._self, this._then);

  final EggListResponse _self;
  final $Res Function(EggListResponse) _then;

/// Create a copy of EggListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? eggs = null,}) {
  return _then(EggListResponse(
eggs: null == eggs ? _self.eggs : eggs // ignore: cast_nullable_to_non_nullable
as List<Egg>,
  ));
}

}


/// Adds pattern-matching-related methods to [EggListResponse].
extension EggListResponsePatterns on EggListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EggListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EggListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EggListResponse value)  $default,){
final _that = this;
switch (_that) {
case _EggListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EggListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _EggListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Egg> eggs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EggListResponse() when $default != null:
return $default(_that.eggs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Egg> eggs)  $default,) {final _that = this;
switch (_that) {
case _EggListResponse():
return $default(_that.eggs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Egg> eggs)?  $default,) {final _that = this;
switch (_that) {
case _EggListResponse() when $default != null:
return $default(_that.eggs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EggListResponse implements EggListResponse {
  const _EggListResponse({ List<Egg> eggs = const <Egg>[]}): _eggs = eggs;
  factory _EggListResponse.fromJson(Map<String, dynamic> json) => _$EggListResponseFromJson(json);

 final  List<Egg> _eggs;
@override@JsonKey() List<Egg> get eggs {
  if (_eggs is EqualUnmodifiableListView) return _eggs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_eggs);
}


/// Create a copy of EggListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EggListResponseCopyWith<_EggListResponse> get copyWith => __$EggListResponseCopyWithImpl<_EggListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EggListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EggListResponse&&const DeepCollectionEquality().equals(other.eggs, _eggs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_eggs));
}

@override
String toString() {
    return 'EggListResponse(eggs: $eggs)';
}


}

/// @nodoc
abstract mixin class _$EggListResponseCopyWith<$Res> implements $EggListResponseCopyWith<$Res> {
  factory _$EggListResponseCopyWith(_EggListResponse value, $Res Function(_EggListResponse) _then) = __$EggListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<Egg> eggs
});




}
/// @nodoc
class __$EggListResponseCopyWithImpl<$Res>
    implements _$EggListResponseCopyWith<$Res> {
  __$EggListResponseCopyWithImpl(this._self, this._then);

  final _EggListResponse _self;
  final $Res Function(_EggListResponse) _then;

/// Create a copy of EggListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? eggs = null,}) {
  return _then(_EggListResponse(
eggs: null == eggs ? _self._eggs : eggs // ignore: cast_nullable_to_non_nullable
as List<Egg>,
  ));
}


}


/// @nodoc
mixin _$StorefrontResponse {

 List<ProductCard> get monthly; List<ProductCard> get quarterly; List<ProductCard> get yearly; bool get emailNotice;
/// Create a copy of StorefrontResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorefrontResponseCopyWith<StorefrontResponse> get copyWith => _$StorefrontResponseCopyWithImpl<StorefrontResponse>(this as StorefrontResponse, _$identity);

  /// Serializes this StorefrontResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StorefrontResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorefrontResponse&&const DeepCollectionEquality().equals(other.monthly, _this.monthly)&&const DeepCollectionEquality().equals(other.quarterly, _this.quarterly)&&const DeepCollectionEquality().equals(other.yearly, _this.yearly)&&(identical(other.emailNotice, _this.emailNotice) || other.emailNotice == _this.emailNotice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StorefrontResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.monthly),const DeepCollectionEquality().hash(_this.quarterly),const DeepCollectionEquality().hash(_this.yearly),_this.emailNotice);
}

@override
String toString() {
  final _this = this as StorefrontResponse;
  return 'StorefrontResponse(monthly: ${_this.monthly}, quarterly: ${_this.quarterly}, yearly: ${_this.yearly}, emailNotice: ${_this.emailNotice})';
}


}

/// @nodoc
abstract mixin class $StorefrontResponseCopyWith<$Res>  {
  factory $StorefrontResponseCopyWith(StorefrontResponse value, $Res Function(StorefrontResponse) _then) = _$StorefrontResponseCopyWithImpl;
@useResult
$Res call({
 List<ProductCard> monthly, List<ProductCard> quarterly, List<ProductCard> yearly, bool emailNotice
});




}
/// @nodoc
class _$StorefrontResponseCopyWithImpl<$Res>
    implements $StorefrontResponseCopyWith<$Res> {
  _$StorefrontResponseCopyWithImpl(this._self, this._then);

  final StorefrontResponse _self;
  final $Res Function(StorefrontResponse) _then;

/// Create a copy of StorefrontResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monthly = null,Object? quarterly = null,Object? yearly = null,Object? emailNotice = null,}) {
  return _then(StorefrontResponse(
monthly: null == monthly ? _self.monthly : monthly // ignore: cast_nullable_to_non_nullable
as List<ProductCard>,quarterly: null == quarterly ? _self.quarterly : quarterly // ignore: cast_nullable_to_non_nullable
as List<ProductCard>,yearly: null == yearly ? _self.yearly : yearly // ignore: cast_nullable_to_non_nullable
as List<ProductCard>,emailNotice: null == emailNotice ? _self.emailNotice : emailNotice // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StorefrontResponse].
extension StorefrontResponsePatterns on StorefrontResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorefrontResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorefrontResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorefrontResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorefrontResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorefrontResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorefrontResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ProductCard> monthly,  List<ProductCard> quarterly,  List<ProductCard> yearly,  bool emailNotice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorefrontResponse() when $default != null:
return $default(_that.monthly,_that.quarterly,_that.yearly,_that.emailNotice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ProductCard> monthly,  List<ProductCard> quarterly,  List<ProductCard> yearly,  bool emailNotice)  $default,) {final _that = this;
switch (_that) {
case _StorefrontResponse():
return $default(_that.monthly,_that.quarterly,_that.yearly,_that.emailNotice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ProductCard> monthly,  List<ProductCard> quarterly,  List<ProductCard> yearly,  bool emailNotice)?  $default,) {final _that = this;
switch (_that) {
case _StorefrontResponse() when $default != null:
return $default(_that.monthly,_that.quarterly,_that.yearly,_that.emailNotice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorefrontResponse implements StorefrontResponse {
  const _StorefrontResponse({ List<ProductCard> monthly = const <ProductCard>[],  List<ProductCard> quarterly = const <ProductCard>[],  List<ProductCard> yearly = const <ProductCard>[], this.emailNotice = false}): _monthly = monthly,_quarterly = quarterly,_yearly = yearly;
  factory _StorefrontResponse.fromJson(Map<String, dynamic> json) => _$StorefrontResponseFromJson(json);

 final  List<ProductCard> _monthly;
@override@JsonKey() List<ProductCard> get monthly {
  if (_monthly is EqualUnmodifiableListView) return _monthly;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_monthly);
}

 final  List<ProductCard> _quarterly;
@override@JsonKey() List<ProductCard> get quarterly {
  if (_quarterly is EqualUnmodifiableListView) return _quarterly;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_quarterly);
}

 final  List<ProductCard> _yearly;
@override@JsonKey() List<ProductCard> get yearly {
  if (_yearly is EqualUnmodifiableListView) return _yearly;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_yearly);
}

@override@JsonKey() final  bool emailNotice;

/// Create a copy of StorefrontResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorefrontResponseCopyWith<_StorefrontResponse> get copyWith => __$StorefrontResponseCopyWithImpl<_StorefrontResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorefrontResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorefrontResponse&&const DeepCollectionEquality().equals(other.monthly, _monthly)&&const DeepCollectionEquality().equals(other.quarterly, _quarterly)&&const DeepCollectionEquality().equals(other.yearly, _yearly)&&(identical(other.emailNotice, emailNotice) || other.emailNotice == emailNotice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_monthly),const DeepCollectionEquality().hash(_quarterly),const DeepCollectionEquality().hash(_yearly),emailNotice);
}

@override
String toString() {
    return 'StorefrontResponse(monthly: $monthly, quarterly: $quarterly, yearly: $yearly, emailNotice: $emailNotice)';
}


}

/// @nodoc
abstract mixin class _$StorefrontResponseCopyWith<$Res> implements $StorefrontResponseCopyWith<$Res> {
  factory _$StorefrontResponseCopyWith(_StorefrontResponse value, $Res Function(_StorefrontResponse) _then) = __$StorefrontResponseCopyWithImpl;
@override @useResult
$Res call({
 List<ProductCard> monthly, List<ProductCard> quarterly, List<ProductCard> yearly, bool emailNotice
});




}
/// @nodoc
class __$StorefrontResponseCopyWithImpl<$Res>
    implements _$StorefrontResponseCopyWith<$Res> {
  __$StorefrontResponseCopyWithImpl(this._self, this._then);

  final _StorefrontResponse _self;
  final $Res Function(_StorefrontResponse) _then;

/// Create a copy of StorefrontResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monthly = null,Object? quarterly = null,Object? yearly = null,Object? emailNotice = null,}) {
  return _then(_StorefrontResponse(
monthly: null == monthly ? _self._monthly : monthly // ignore: cast_nullable_to_non_nullable
as List<ProductCard>,quarterly: null == quarterly ? _self._quarterly : quarterly // ignore: cast_nullable_to_non_nullable
as List<ProductCard>,yearly: null == yearly ? _self._yearly : yearly // ignore: cast_nullable_to_non_nullable
as List<ProductCard>,emailNotice: null == emailNotice ? _self.emailNotice : emailNotice // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
