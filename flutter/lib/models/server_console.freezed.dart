// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_console.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServerConsole {

 ConsoleServer get server; ConsoleLimits get limits; ServerStartup get startup;
/// Create a copy of ServerConsole
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerConsoleCopyWith<ServerConsole> get copyWith => _$ServerConsoleCopyWithImpl<ServerConsole>(this as ServerConsole, _$identity);

  /// Serializes this ServerConsole to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ServerConsole;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerConsole&&(identical(other.server, _this.server) || other.server == _this.server)&&(identical(other.limits, _this.limits) || other.limits == _this.limits)&&(identical(other.startup, _this.startup) || other.startup == _this.startup));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ServerConsole;
  return Object.hash(runtimeType,_this.server,_this.limits,_this.startup);
}

@override
String toString() {
  final _this = this as ServerConsole;
  return 'ServerConsole(server: ${_this.server}, limits: ${_this.limits}, startup: ${_this.startup})';
}


}

/// @nodoc
abstract mixin class $ServerConsoleCopyWith<$Res>  {
  factory $ServerConsoleCopyWith(ServerConsole value, $Res Function(ServerConsole) _then) = _$ServerConsoleCopyWithImpl;
@useResult
$Res call({
 ConsoleServer server, ConsoleLimits limits, ServerStartup startup
});


$ConsoleServerCopyWith<$Res> get server;$ConsoleLimitsCopyWith<$Res> get limits;$ServerStartupCopyWith<$Res> get startup;

}
/// @nodoc
class _$ServerConsoleCopyWithImpl<$Res>
    implements $ServerConsoleCopyWith<$Res> {
  _$ServerConsoleCopyWithImpl(this._self, this._then);

  final ServerConsole _self;
  final $Res Function(ServerConsole) _then;

/// Create a copy of ServerConsole
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? server = null,Object? limits = null,Object? startup = null,}) {
  return _then(ServerConsole(
server: null == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as ConsoleServer,limits: null == limits ? _self.limits : limits // ignore: cast_nullable_to_non_nullable
as ConsoleLimits,startup: null == startup ? _self.startup : startup // ignore: cast_nullable_to_non_nullable
as ServerStartup,
  ));
}
/// Create a copy of ServerConsole
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConsoleServerCopyWith<$Res> get server {
  
  return $ConsoleServerCopyWith<$Res>(_self.server, (value) {
    return _then(_self.copyWith(server: value));
  });
}/// Create a copy of ServerConsole
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConsoleLimitsCopyWith<$Res> get limits {
  
  return $ConsoleLimitsCopyWith<$Res>(_self.limits, (value) {
    return _then(_self.copyWith(limits: value));
  });
}/// Create a copy of ServerConsole
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServerStartupCopyWith<$Res> get startup {
  
  return $ServerStartupCopyWith<$Res>(_self.startup, (value) {
    return _then(_self.copyWith(startup: value));
  });
}
}


/// Adds pattern-matching-related methods to [ServerConsole].
extension ServerConsolePatterns on ServerConsole {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerConsole value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerConsole() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerConsole value)  $default,){
final _that = this;
switch (_that) {
case _ServerConsole():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerConsole value)?  $default,){
final _that = this;
switch (_that) {
case _ServerConsole() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ConsoleServer server,  ConsoleLimits limits,  ServerStartup startup)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerConsole() when $default != null:
return $default(_that.server,_that.limits,_that.startup);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ConsoleServer server,  ConsoleLimits limits,  ServerStartup startup)  $default,) {final _that = this;
switch (_that) {
case _ServerConsole():
return $default(_that.server,_that.limits,_that.startup);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ConsoleServer server,  ConsoleLimits limits,  ServerStartup startup)?  $default,) {final _that = this;
switch (_that) {
case _ServerConsole() when $default != null:
return $default(_that.server,_that.limits,_that.startup);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServerConsole implements ServerConsole {
  const _ServerConsole({this.server = const ConsoleServer(), this.limits = const ConsoleLimits(), this.startup = const ServerStartup()});
  factory _ServerConsole.fromJson(Map<String, dynamic> json) => _$ServerConsoleFromJson(json);

@override@JsonKey() final  ConsoleServer server;
@override@JsonKey() final  ConsoleLimits limits;
@override@JsonKey() final  ServerStartup startup;

/// Create a copy of ServerConsole
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerConsoleCopyWith<_ServerConsole> get copyWith => __$ServerConsoleCopyWithImpl<_ServerConsole>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServerConsoleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerConsole&&(identical(other.server, server) || other.server == server)&&(identical(other.limits, limits) || other.limits == limits)&&(identical(other.startup, startup) || other.startup == startup));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,server,limits,startup);
}

@override
String toString() {
    return 'ServerConsole(server: $server, limits: $limits, startup: $startup)';
}


}

/// @nodoc
abstract mixin class _$ServerConsoleCopyWith<$Res> implements $ServerConsoleCopyWith<$Res> {
  factory _$ServerConsoleCopyWith(_ServerConsole value, $Res Function(_ServerConsole) _then) = __$ServerConsoleCopyWithImpl;
@override @useResult
$Res call({
 ConsoleServer server, ConsoleLimits limits, ServerStartup startup
});


@override $ConsoleServerCopyWith<$Res> get server;@override $ConsoleLimitsCopyWith<$Res> get limits;@override $ServerStartupCopyWith<$Res> get startup;

}
/// @nodoc
class __$ServerConsoleCopyWithImpl<$Res>
    implements _$ServerConsoleCopyWith<$Res> {
  __$ServerConsoleCopyWithImpl(this._self, this._then);

  final _ServerConsole _self;
  final $Res Function(_ServerConsole) _then;

/// Create a copy of ServerConsole
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? server = null,Object? limits = null,Object? startup = null,}) {
  return _then(_ServerConsole(
server: null == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as ConsoleServer,limits: null == limits ? _self.limits : limits // ignore: cast_nullable_to_non_nullable
as ConsoleLimits,startup: null == startup ? _self.startup : startup // ignore: cast_nullable_to_non_nullable
as ServerStartup,
  ));
}

/// Create a copy of ServerConsole
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConsoleServerCopyWith<$Res> get server {
  
  return $ConsoleServerCopyWith<$Res>(_self.server, (value) {
    return _then(_self.copyWith(server: value));
  });
}/// Create a copy of ServerConsole
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConsoleLimitsCopyWith<$Res> get limits {
  
  return $ConsoleLimitsCopyWith<$Res>(_self.limits, (value) {
    return _then(_self.copyWith(limits: value));
  });
}/// Create a copy of ServerConsole
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServerStartupCopyWith<$Res> get startup {
  
  return $ServerStartupCopyWith<$Res>(_self.startup, (value) {
    return _then(_self.copyWith(startup: value));
  });
}
}


/// @nodoc
mixin _$ConsoleServer {

 String get id; String get identifier; String get name; String get status; bool get suspended; bool get installing;
/// Create a copy of ConsoleServer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsoleServerCopyWith<ConsoleServer> get copyWith => _$ConsoleServerCopyWithImpl<ConsoleServer>(this as ConsoleServer, _$identity);

  /// Serializes this ConsoleServer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ConsoleServer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsoleServer&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.identifier, _this.identifier) || other.identifier == _this.identifier)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.suspended, _this.suspended) || other.suspended == _this.suspended)&&(identical(other.installing, _this.installing) || other.installing == _this.installing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ConsoleServer;
  return Object.hash(runtimeType,_this.id,_this.identifier,_this.name,_this.status,_this.suspended,_this.installing);
}

@override
String toString() {
  final _this = this as ConsoleServer;
  return 'ConsoleServer(id: ${_this.id}, identifier: ${_this.identifier}, name: ${_this.name}, status: ${_this.status}, suspended: ${_this.suspended}, installing: ${_this.installing})';
}


}

/// @nodoc
abstract mixin class $ConsoleServerCopyWith<$Res>  {
  factory $ConsoleServerCopyWith(ConsoleServer value, $Res Function(ConsoleServer) _then) = _$ConsoleServerCopyWithImpl;
@useResult
$Res call({
 String id, String identifier, String name, String status, bool suspended, bool installing
});




}
/// @nodoc
class _$ConsoleServerCopyWithImpl<$Res>
    implements $ConsoleServerCopyWith<$Res> {
  _$ConsoleServerCopyWithImpl(this._self, this._then);

  final ConsoleServer _self;
  final $Res Function(ConsoleServer) _then;

/// Create a copy of ConsoleServer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? identifier = null,Object? name = null,Object? status = null,Object? suspended = null,Object? installing = null,}) {
  return _then(ConsoleServer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,identifier: null == identifier ? _self.identifier : identifier // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,suspended: null == suspended ? _self.suspended : suspended // ignore: cast_nullable_to_non_nullable
as bool,installing: null == installing ? _self.installing : installing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsoleServer].
extension ConsoleServerPatterns on ConsoleServer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsoleServer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsoleServer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsoleServer value)  $default,){
final _that = this;
switch (_that) {
case _ConsoleServer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsoleServer value)?  $default,){
final _that = this;
switch (_that) {
case _ConsoleServer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String identifier,  String name,  String status,  bool suspended,  bool installing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsoleServer() when $default != null:
return $default(_that.id,_that.identifier,_that.name,_that.status,_that.suspended,_that.installing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String identifier,  String name,  String status,  bool suspended,  bool installing)  $default,) {final _that = this;
switch (_that) {
case _ConsoleServer():
return $default(_that.id,_that.identifier,_that.name,_that.status,_that.suspended,_that.installing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String identifier,  String name,  String status,  bool suspended,  bool installing)?  $default,) {final _that = this;
switch (_that) {
case _ConsoleServer() when $default != null:
return $default(_that.id,_that.identifier,_that.name,_that.status,_that.suspended,_that.installing);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsoleServer implements ConsoleServer {
  const _ConsoleServer({this.id = '', this.identifier = '', this.name = '', this.status = '', this.suspended = false, this.installing = false});
  factory _ConsoleServer.fromJson(Map<String, dynamic> json) => _$ConsoleServerFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String identifier;
@override@JsonKey() final  String name;
@override@JsonKey() final  String status;
@override@JsonKey() final  bool suspended;
@override@JsonKey() final  bool installing;

/// Create a copy of ConsoleServer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsoleServerCopyWith<_ConsoleServer> get copyWith => __$ConsoleServerCopyWithImpl<_ConsoleServer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsoleServerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsoleServer&&(identical(other.id, id) || other.id == id)&&(identical(other.identifier, identifier) || other.identifier == identifier)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.suspended, suspended) || other.suspended == suspended)&&(identical(other.installing, installing) || other.installing == installing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,identifier,name,status,suspended,installing);
}

@override
String toString() {
    return 'ConsoleServer(id: $id, identifier: $identifier, name: $name, status: $status, suspended: $suspended, installing: $installing)';
}


}

/// @nodoc
abstract mixin class _$ConsoleServerCopyWith<$Res> implements $ConsoleServerCopyWith<$Res> {
  factory _$ConsoleServerCopyWith(_ConsoleServer value, $Res Function(_ConsoleServer) _then) = __$ConsoleServerCopyWithImpl;
@override @useResult
$Res call({
 String id, String identifier, String name, String status, bool suspended, bool installing
});




}
/// @nodoc
class __$ConsoleServerCopyWithImpl<$Res>
    implements _$ConsoleServerCopyWith<$Res> {
  __$ConsoleServerCopyWithImpl(this._self, this._then);

  final _ConsoleServer _self;
  final $Res Function(_ConsoleServer) _then;

/// Create a copy of ConsoleServer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? identifier = null,Object? name = null,Object? status = null,Object? suspended = null,Object? installing = null,}) {
  return _then(_ConsoleServer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,identifier: null == identifier ? _self.identifier : identifier // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,suspended: null == suspended ? _self.suspended : suspended // ignore: cast_nullable_to_non_nullable
as bool,installing: null == installing ? _self.installing : installing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ConsoleLimits {

 int get memory; int get disk; int get cpu; int get io; int get swap; String get threads; int get backups;
/// Create a copy of ConsoleLimits
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsoleLimitsCopyWith<ConsoleLimits> get copyWith => _$ConsoleLimitsCopyWithImpl<ConsoleLimits>(this as ConsoleLimits, _$identity);

  /// Serializes this ConsoleLimits to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ConsoleLimits;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsoleLimits&&(identical(other.memory, _this.memory) || other.memory == _this.memory)&&(identical(other.disk, _this.disk) || other.disk == _this.disk)&&(identical(other.cpu, _this.cpu) || other.cpu == _this.cpu)&&(identical(other.io, _this.io) || other.io == _this.io)&&(identical(other.swap, _this.swap) || other.swap == _this.swap)&&(identical(other.threads, _this.threads) || other.threads == _this.threads)&&(identical(other.backups, _this.backups) || other.backups == _this.backups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ConsoleLimits;
  return Object.hash(runtimeType,_this.memory,_this.disk,_this.cpu,_this.io,_this.swap,_this.threads,_this.backups);
}

@override
String toString() {
  final _this = this as ConsoleLimits;
  return 'ConsoleLimits(memory: ${_this.memory}, disk: ${_this.disk}, cpu: ${_this.cpu}, io: ${_this.io}, swap: ${_this.swap}, threads: ${_this.threads}, backups: ${_this.backups})';
}


}

/// @nodoc
abstract mixin class $ConsoleLimitsCopyWith<$Res>  {
  factory $ConsoleLimitsCopyWith(ConsoleLimits value, $Res Function(ConsoleLimits) _then) = _$ConsoleLimitsCopyWithImpl;
@useResult
$Res call({
 int memory, int disk, int cpu, int io, int swap, String threads, int backups
});




}
/// @nodoc
class _$ConsoleLimitsCopyWithImpl<$Res>
    implements $ConsoleLimitsCopyWith<$Res> {
  _$ConsoleLimitsCopyWithImpl(this._self, this._then);

  final ConsoleLimits _self;
  final $Res Function(ConsoleLimits) _then;

/// Create a copy of ConsoleLimits
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memory = null,Object? disk = null,Object? cpu = null,Object? io = null,Object? swap = null,Object? threads = null,Object? backups = null,}) {
  return _then(ConsoleLimits(
memory: null == memory ? _self.memory : memory // ignore: cast_nullable_to_non_nullable
as int,disk: null == disk ? _self.disk : disk // ignore: cast_nullable_to_non_nullable
as int,cpu: null == cpu ? _self.cpu : cpu // ignore: cast_nullable_to_non_nullable
as int,io: null == io ? _self.io : io // ignore: cast_nullable_to_non_nullable
as int,swap: null == swap ? _self.swap : swap // ignore: cast_nullable_to_non_nullable
as int,threads: null == threads ? _self.threads : threads // ignore: cast_nullable_to_non_nullable
as String,backups: null == backups ? _self.backups : backups // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsoleLimits].
extension ConsoleLimitsPatterns on ConsoleLimits {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsoleLimits value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsoleLimits() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsoleLimits value)  $default,){
final _that = this;
switch (_that) {
case _ConsoleLimits():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsoleLimits value)?  $default,){
final _that = this;
switch (_that) {
case _ConsoleLimits() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int memory,  int disk,  int cpu,  int io,  int swap,  String threads,  int backups)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsoleLimits() when $default != null:
return $default(_that.memory,_that.disk,_that.cpu,_that.io,_that.swap,_that.threads,_that.backups);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int memory,  int disk,  int cpu,  int io,  int swap,  String threads,  int backups)  $default,) {final _that = this;
switch (_that) {
case _ConsoleLimits():
return $default(_that.memory,_that.disk,_that.cpu,_that.io,_that.swap,_that.threads,_that.backups);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int memory,  int disk,  int cpu,  int io,  int swap,  String threads,  int backups)?  $default,) {final _that = this;
switch (_that) {
case _ConsoleLimits() when $default != null:
return $default(_that.memory,_that.disk,_that.cpu,_that.io,_that.swap,_that.threads,_that.backups);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsoleLimits implements ConsoleLimits {
  const _ConsoleLimits({this.memory = 0, this.disk = 0, this.cpu = 0, this.io = 0, this.swap = 0, this.threads = '', this.backups = 0});
  factory _ConsoleLimits.fromJson(Map<String, dynamic> json) => _$ConsoleLimitsFromJson(json);

@override@JsonKey() final  int memory;
@override@JsonKey() final  int disk;
@override@JsonKey() final  int cpu;
@override@JsonKey() final  int io;
@override@JsonKey() final  int swap;
@override@JsonKey() final  String threads;
@override@JsonKey() final  int backups;

/// Create a copy of ConsoleLimits
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsoleLimitsCopyWith<_ConsoleLimits> get copyWith => __$ConsoleLimitsCopyWithImpl<_ConsoleLimits>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsoleLimitsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsoleLimits&&(identical(other.memory, memory) || other.memory == memory)&&(identical(other.disk, disk) || other.disk == disk)&&(identical(other.cpu, cpu) || other.cpu == cpu)&&(identical(other.io, io) || other.io == io)&&(identical(other.swap, swap) || other.swap == swap)&&(identical(other.threads, threads) || other.threads == threads)&&(identical(other.backups, backups) || other.backups == backups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,memory,disk,cpu,io,swap,threads,backups);
}

@override
String toString() {
    return 'ConsoleLimits(memory: $memory, disk: $disk, cpu: $cpu, io: $io, swap: $swap, threads: $threads, backups: $backups)';
}


}

/// @nodoc
abstract mixin class _$ConsoleLimitsCopyWith<$Res> implements $ConsoleLimitsCopyWith<$Res> {
  factory _$ConsoleLimitsCopyWith(_ConsoleLimits value, $Res Function(_ConsoleLimits) _then) = __$ConsoleLimitsCopyWithImpl;
@override @useResult
$Res call({
 int memory, int disk, int cpu, int io, int swap, String threads, int backups
});




}
/// @nodoc
class __$ConsoleLimitsCopyWithImpl<$Res>
    implements _$ConsoleLimitsCopyWith<$Res> {
  __$ConsoleLimitsCopyWithImpl(this._self, this._then);

  final _ConsoleLimits _self;
  final $Res Function(_ConsoleLimits) _then;

/// Create a copy of ConsoleLimits
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memory = null,Object? disk = null,Object? cpu = null,Object? io = null,Object? swap = null,Object? threads = null,Object? backups = null,}) {
  return _then(_ConsoleLimits(
memory: null == memory ? _self.memory : memory // ignore: cast_nullable_to_non_nullable
as int,disk: null == disk ? _self.disk : disk // ignore: cast_nullable_to_non_nullable
as int,cpu: null == cpu ? _self.cpu : cpu // ignore: cast_nullable_to_non_nullable
as int,io: null == io ? _self.io : io // ignore: cast_nullable_to_non_nullable
as int,swap: null == swap ? _self.swap : swap // ignore: cast_nullable_to_non_nullable
as int,threads: null == threads ? _self.threads : threads // ignore: cast_nullable_to_non_nullable
as String,backups: null == backups ? _self.backups : backups // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ServerStartup {

 String get command; List<StartupVariable> get variables; Map<String, String> get dockerImages; String get dockerImage;
/// Create a copy of ServerStartup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerStartupCopyWith<ServerStartup> get copyWith => _$ServerStartupCopyWithImpl<ServerStartup>(this as ServerStartup, _$identity);

  /// Serializes this ServerStartup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ServerStartup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerStartup&&(identical(other.command, _this.command) || other.command == _this.command)&&const DeepCollectionEquality().equals(other.variables, _this.variables)&&const DeepCollectionEquality().equals(other.dockerImages, _this.dockerImages)&&(identical(other.dockerImage, _this.dockerImage) || other.dockerImage == _this.dockerImage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ServerStartup;
  return Object.hash(runtimeType,_this.command,const DeepCollectionEquality().hash(_this.variables),const DeepCollectionEquality().hash(_this.dockerImages),_this.dockerImage);
}

@override
String toString() {
  final _this = this as ServerStartup;
  return 'ServerStartup(command: ${_this.command}, variables: ${_this.variables}, dockerImages: ${_this.dockerImages}, dockerImage: ${_this.dockerImage})';
}


}

/// @nodoc
abstract mixin class $ServerStartupCopyWith<$Res>  {
  factory $ServerStartupCopyWith(ServerStartup value, $Res Function(ServerStartup) _then) = _$ServerStartupCopyWithImpl;
@useResult
$Res call({
 String command, List<StartupVariable> variables, Map<String, String> dockerImages, String dockerImage
});




}
/// @nodoc
class _$ServerStartupCopyWithImpl<$Res>
    implements $ServerStartupCopyWith<$Res> {
  _$ServerStartupCopyWithImpl(this._self, this._then);

  final ServerStartup _self;
  final $Res Function(ServerStartup) _then;

/// Create a copy of ServerStartup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? command = null,Object? variables = null,Object? dockerImages = null,Object? dockerImage = null,}) {
  return _then(ServerStartup(
command: null == command ? _self.command : command // ignore: cast_nullable_to_non_nullable
as String,variables: null == variables ? _self.variables : variables // ignore: cast_nullable_to_non_nullable
as List<StartupVariable>,dockerImages: null == dockerImages ? _self.dockerImages : dockerImages // ignore: cast_nullable_to_non_nullable
as Map<String, String>,dockerImage: null == dockerImage ? _self.dockerImage : dockerImage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerStartup].
extension ServerStartupPatterns on ServerStartup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerStartup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerStartup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerStartup value)  $default,){
final _that = this;
switch (_that) {
case _ServerStartup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerStartup value)?  $default,){
final _that = this;
switch (_that) {
case _ServerStartup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String command,  List<StartupVariable> variables,  Map<String, String> dockerImages,  String dockerImage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerStartup() when $default != null:
return $default(_that.command,_that.variables,_that.dockerImages,_that.dockerImage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String command,  List<StartupVariable> variables,  Map<String, String> dockerImages,  String dockerImage)  $default,) {final _that = this;
switch (_that) {
case _ServerStartup():
return $default(_that.command,_that.variables,_that.dockerImages,_that.dockerImage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String command,  List<StartupVariable> variables,  Map<String, String> dockerImages,  String dockerImage)?  $default,) {final _that = this;
switch (_that) {
case _ServerStartup() when $default != null:
return $default(_that.command,_that.variables,_that.dockerImages,_that.dockerImage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServerStartup implements ServerStartup {
  const _ServerStartup({this.command = '',  List<StartupVariable> variables = const <StartupVariable>[],  Map<String, String> dockerImages = const <String, String>{}, this.dockerImage = ''}): _variables = variables,_dockerImages = dockerImages;
  factory _ServerStartup.fromJson(Map<String, dynamic> json) => _$ServerStartupFromJson(json);

@override@JsonKey() final  String command;
 final  List<StartupVariable> _variables;
@override@JsonKey() List<StartupVariable> get variables {
  if (_variables is EqualUnmodifiableListView) return _variables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_variables);
}

 final  Map<String, String> _dockerImages;
@override@JsonKey() Map<String, String> get dockerImages {
  if (_dockerImages is EqualUnmodifiableMapView) return _dockerImages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_dockerImages);
}

@override@JsonKey() final  String dockerImage;

/// Create a copy of ServerStartup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerStartupCopyWith<_ServerStartup> get copyWith => __$ServerStartupCopyWithImpl<_ServerStartup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServerStartupToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerStartup&&(identical(other.command, command) || other.command == command)&&const DeepCollectionEquality().equals(other.variables, _variables)&&const DeepCollectionEquality().equals(other.dockerImages, _dockerImages)&&(identical(other.dockerImage, dockerImage) || other.dockerImage == dockerImage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,command,const DeepCollectionEquality().hash(_variables),const DeepCollectionEquality().hash(_dockerImages),dockerImage);
}

@override
String toString() {
    return 'ServerStartup(command: $command, variables: $variables, dockerImages: $dockerImages, dockerImage: $dockerImage)';
}


}

/// @nodoc
abstract mixin class _$ServerStartupCopyWith<$Res> implements $ServerStartupCopyWith<$Res> {
  factory _$ServerStartupCopyWith(_ServerStartup value, $Res Function(_ServerStartup) _then) = __$ServerStartupCopyWithImpl;
@override @useResult
$Res call({
 String command, List<StartupVariable> variables, Map<String, String> dockerImages, String dockerImage
});




}
/// @nodoc
class __$ServerStartupCopyWithImpl<$Res>
    implements _$ServerStartupCopyWith<$Res> {
  __$ServerStartupCopyWithImpl(this._self, this._then);

  final _ServerStartup _self;
  final $Res Function(_ServerStartup) _then;

/// Create a copy of ServerStartup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? command = null,Object? variables = null,Object? dockerImages = null,Object? dockerImage = null,}) {
  return _then(_ServerStartup(
command: null == command ? _self.command : command // ignore: cast_nullable_to_non_nullable
as String,variables: null == variables ? _self._variables : variables // ignore: cast_nullable_to_non_nullable
as List<StartupVariable>,dockerImages: null == dockerImages ? _self._dockerImages : dockerImages // ignore: cast_nullable_to_non_nullable
as Map<String, String>,dockerImage: null == dockerImage ? _self.dockerImage : dockerImage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$StartupVariable {

 String get key; String get name; String get description; String get value; String get defaultValue; bool get isEditable; String get rules;
/// Create a copy of StartupVariable
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StartupVariableCopyWith<StartupVariable> get copyWith => _$StartupVariableCopyWithImpl<StartupVariable>(this as StartupVariable, _$identity);

  /// Serializes this StartupVariable to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StartupVariable;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StartupVariable&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.value, _this.value) || other.value == _this.value)&&(identical(other.defaultValue, _this.defaultValue) || other.defaultValue == _this.defaultValue)&&(identical(other.isEditable, _this.isEditable) || other.isEditable == _this.isEditable)&&(identical(other.rules, _this.rules) || other.rules == _this.rules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StartupVariable;
  return Object.hash(runtimeType,_this.key,_this.name,_this.description,_this.value,_this.defaultValue,_this.isEditable,_this.rules);
}

@override
String toString() {
  final _this = this as StartupVariable;
  return 'StartupVariable(key: ${_this.key}, name: ${_this.name}, description: ${_this.description}, value: ${_this.value}, defaultValue: ${_this.defaultValue}, isEditable: ${_this.isEditable}, rules: ${_this.rules})';
}


}

/// @nodoc
abstract mixin class $StartupVariableCopyWith<$Res>  {
  factory $StartupVariableCopyWith(StartupVariable value, $Res Function(StartupVariable) _then) = _$StartupVariableCopyWithImpl;
@useResult
$Res call({
 String key, String name, String description, String value, String defaultValue, bool isEditable, String rules
});




}
/// @nodoc
class _$StartupVariableCopyWithImpl<$Res>
    implements $StartupVariableCopyWith<$Res> {
  _$StartupVariableCopyWithImpl(this._self, this._then);

  final StartupVariable _self;
  final $Res Function(StartupVariable) _then;

/// Create a copy of StartupVariable
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? name = null,Object? description = null,Object? value = null,Object? defaultValue = null,Object? isEditable = null,Object? rules = null,}) {
  return _then(StartupVariable(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,defaultValue: null == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as String,isEditable: null == isEditable ? _self.isEditable : isEditable // ignore: cast_nullable_to_non_nullable
as bool,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StartupVariable].
extension StartupVariablePatterns on StartupVariable {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StartupVariable value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StartupVariable() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StartupVariable value)  $default,){
final _that = this;
switch (_that) {
case _StartupVariable():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StartupVariable value)?  $default,){
final _that = this;
switch (_that) {
case _StartupVariable() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String name,  String description,  String value,  String defaultValue,  bool isEditable,  String rules)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StartupVariable() when $default != null:
return $default(_that.key,_that.name,_that.description,_that.value,_that.defaultValue,_that.isEditable,_that.rules);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String name,  String description,  String value,  String defaultValue,  bool isEditable,  String rules)  $default,) {final _that = this;
switch (_that) {
case _StartupVariable():
return $default(_that.key,_that.name,_that.description,_that.value,_that.defaultValue,_that.isEditable,_that.rules);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String name,  String description,  String value,  String defaultValue,  bool isEditable,  String rules)?  $default,) {final _that = this;
switch (_that) {
case _StartupVariable() when $default != null:
return $default(_that.key,_that.name,_that.description,_that.value,_that.defaultValue,_that.isEditable,_that.rules);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StartupVariable implements StartupVariable {
  const _StartupVariable({this.key = '', this.name = '', this.description = '', this.value = '', this.defaultValue = '', this.isEditable = false, this.rules = ''});
  factory _StartupVariable.fromJson(Map<String, dynamic> json) => _$StartupVariableFromJson(json);

@override@JsonKey() final  String key;
@override@JsonKey() final  String name;
@override@JsonKey() final  String description;
@override@JsonKey() final  String value;
@override@JsonKey() final  String defaultValue;
@override@JsonKey() final  bool isEditable;
@override@JsonKey() final  String rules;

/// Create a copy of StartupVariable
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartupVariableCopyWith<_StartupVariable> get copyWith => __$StartupVariableCopyWithImpl<_StartupVariable>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StartupVariableToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StartupVariable&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.value, value) || other.value == value)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.isEditable, isEditable) || other.isEditable == isEditable)&&(identical(other.rules, rules) || other.rules == rules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,name,description,value,defaultValue,isEditable,rules);
}

@override
String toString() {
    return 'StartupVariable(key: $key, name: $name, description: $description, value: $value, defaultValue: $defaultValue, isEditable: $isEditable, rules: $rules)';
}


}

/// @nodoc
abstract mixin class _$StartupVariableCopyWith<$Res> implements $StartupVariableCopyWith<$Res> {
  factory _$StartupVariableCopyWith(_StartupVariable value, $Res Function(_StartupVariable) _then) = __$StartupVariableCopyWithImpl;
@override @useResult
$Res call({
 String key, String name, String description, String value, String defaultValue, bool isEditable, String rules
});




}
/// @nodoc
class __$StartupVariableCopyWithImpl<$Res>
    implements _$StartupVariableCopyWith<$Res> {
  __$StartupVariableCopyWithImpl(this._self, this._then);

  final _StartupVariable _self;
  final $Res Function(_StartupVariable) _then;

/// Create a copy of StartupVariable
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? name = null,Object? description = null,Object? value = null,Object? defaultValue = null,Object? isEditable = null,Object? rules = null,}) {
  return _then(_StartupVariable(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,defaultValue: null == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as String,isEditable: null == isEditable ? _self.isEditable : isEditable // ignore: cast_nullable_to_non_nullable
as bool,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ServerResources {

 String get currentState; bool get isSuspended; ResourceUsage get resources;
/// Create a copy of ServerResources
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerResourcesCopyWith<ServerResources> get copyWith => _$ServerResourcesCopyWithImpl<ServerResources>(this as ServerResources, _$identity);

  /// Serializes this ServerResources to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ServerResources;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerResources&&(identical(other.currentState, _this.currentState) || other.currentState == _this.currentState)&&(identical(other.isSuspended, _this.isSuspended) || other.isSuspended == _this.isSuspended)&&(identical(other.resources, _this.resources) || other.resources == _this.resources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ServerResources;
  return Object.hash(runtimeType,_this.currentState,_this.isSuspended,_this.resources);
}

@override
String toString() {
  final _this = this as ServerResources;
  return 'ServerResources(currentState: ${_this.currentState}, isSuspended: ${_this.isSuspended}, resources: ${_this.resources})';
}


}

/// @nodoc
abstract mixin class $ServerResourcesCopyWith<$Res>  {
  factory $ServerResourcesCopyWith(ServerResources value, $Res Function(ServerResources) _then) = _$ServerResourcesCopyWithImpl;
@useResult
$Res call({
 String currentState, bool isSuspended, ResourceUsage resources
});


$ResourceUsageCopyWith<$Res> get resources;

}
/// @nodoc
class _$ServerResourcesCopyWithImpl<$Res>
    implements $ServerResourcesCopyWith<$Res> {
  _$ServerResourcesCopyWithImpl(this._self, this._then);

  final ServerResources _self;
  final $Res Function(ServerResources) _then;

/// Create a copy of ServerResources
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentState = null,Object? isSuspended = null,Object? resources = null,}) {
  return _then(ServerResources(
currentState: null == currentState ? _self.currentState : currentState // ignore: cast_nullable_to_non_nullable
as String,isSuspended: null == isSuspended ? _self.isSuspended : isSuspended // ignore: cast_nullable_to_non_nullable
as bool,resources: null == resources ? _self.resources : resources // ignore: cast_nullable_to_non_nullable
as ResourceUsage,
  ));
}
/// Create a copy of ServerResources
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResourceUsageCopyWith<$Res> get resources {
  
  return $ResourceUsageCopyWith<$Res>(_self.resources, (value) {
    return _then(_self.copyWith(resources: value));
  });
}
}


/// Adds pattern-matching-related methods to [ServerResources].
extension ServerResourcesPatterns on ServerResources {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerResources value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerResources() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerResources value)  $default,){
final _that = this;
switch (_that) {
case _ServerResources():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerResources value)?  $default,){
final _that = this;
switch (_that) {
case _ServerResources() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String currentState,  bool isSuspended,  ResourceUsage resources)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerResources() when $default != null:
return $default(_that.currentState,_that.isSuspended,_that.resources);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String currentState,  bool isSuspended,  ResourceUsage resources)  $default,) {final _that = this;
switch (_that) {
case _ServerResources():
return $default(_that.currentState,_that.isSuspended,_that.resources);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String currentState,  bool isSuspended,  ResourceUsage resources)?  $default,) {final _that = this;
switch (_that) {
case _ServerResources() when $default != null:
return $default(_that.currentState,_that.isSuspended,_that.resources);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServerResources implements ServerResources {
  const _ServerResources({this.currentState = '', this.isSuspended = false, this.resources = const ResourceUsage()});
  factory _ServerResources.fromJson(Map<String, dynamic> json) => _$ServerResourcesFromJson(json);

@override@JsonKey() final  String currentState;
@override@JsonKey() final  bool isSuspended;
@override@JsonKey() final  ResourceUsage resources;

/// Create a copy of ServerResources
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerResourcesCopyWith<_ServerResources> get copyWith => __$ServerResourcesCopyWithImpl<_ServerResources>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServerResourcesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerResources&&(identical(other.currentState, currentState) || other.currentState == currentState)&&(identical(other.isSuspended, isSuspended) || other.isSuspended == isSuspended)&&(identical(other.resources, resources) || other.resources == resources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,currentState,isSuspended,resources);
}

@override
String toString() {
    return 'ServerResources(currentState: $currentState, isSuspended: $isSuspended, resources: $resources)';
}


}

/// @nodoc
abstract mixin class _$ServerResourcesCopyWith<$Res> implements $ServerResourcesCopyWith<$Res> {
  factory _$ServerResourcesCopyWith(_ServerResources value, $Res Function(_ServerResources) _then) = __$ServerResourcesCopyWithImpl;
@override @useResult
$Res call({
 String currentState, bool isSuspended, ResourceUsage resources
});


@override $ResourceUsageCopyWith<$Res> get resources;

}
/// @nodoc
class __$ServerResourcesCopyWithImpl<$Res>
    implements _$ServerResourcesCopyWith<$Res> {
  __$ServerResourcesCopyWithImpl(this._self, this._then);

  final _ServerResources _self;
  final $Res Function(_ServerResources) _then;

/// Create a copy of ServerResources
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentState = null,Object? isSuspended = null,Object? resources = null,}) {
  return _then(_ServerResources(
currentState: null == currentState ? _self.currentState : currentState // ignore: cast_nullable_to_non_nullable
as String,isSuspended: null == isSuspended ? _self.isSuspended : isSuspended // ignore: cast_nullable_to_non_nullable
as bool,resources: null == resources ? _self.resources : resources // ignore: cast_nullable_to_non_nullable
as ResourceUsage,
  ));
}

/// Create a copy of ServerResources
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResourceUsageCopyWith<$Res> get resources {
  
  return $ResourceUsageCopyWith<$Res>(_self.resources, (value) {
    return _then(_self.copyWith(resources: value));
  });
}
}


/// @nodoc
mixin _$ResourceUsage {

 int get memoryBytes; double get cpuAbsolute; int get diskBytes; int get networkRxBytes; int get networkTxBytes; int get uptime;
/// Create a copy of ResourceUsage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResourceUsageCopyWith<ResourceUsage> get copyWith => _$ResourceUsageCopyWithImpl<ResourceUsage>(this as ResourceUsage, _$identity);

  /// Serializes this ResourceUsage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ResourceUsage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResourceUsage&&(identical(other.memoryBytes, _this.memoryBytes) || other.memoryBytes == _this.memoryBytes)&&(identical(other.cpuAbsolute, _this.cpuAbsolute) || other.cpuAbsolute == _this.cpuAbsolute)&&(identical(other.diskBytes, _this.diskBytes) || other.diskBytes == _this.diskBytes)&&(identical(other.networkRxBytes, _this.networkRxBytes) || other.networkRxBytes == _this.networkRxBytes)&&(identical(other.networkTxBytes, _this.networkTxBytes) || other.networkTxBytes == _this.networkTxBytes)&&(identical(other.uptime, _this.uptime) || other.uptime == _this.uptime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ResourceUsage;
  return Object.hash(runtimeType,_this.memoryBytes,_this.cpuAbsolute,_this.diskBytes,_this.networkRxBytes,_this.networkTxBytes,_this.uptime);
}

@override
String toString() {
  final _this = this as ResourceUsage;
  return 'ResourceUsage(memoryBytes: ${_this.memoryBytes}, cpuAbsolute: ${_this.cpuAbsolute}, diskBytes: ${_this.diskBytes}, networkRxBytes: ${_this.networkRxBytes}, networkTxBytes: ${_this.networkTxBytes}, uptime: ${_this.uptime})';
}


}

/// @nodoc
abstract mixin class $ResourceUsageCopyWith<$Res>  {
  factory $ResourceUsageCopyWith(ResourceUsage value, $Res Function(ResourceUsage) _then) = _$ResourceUsageCopyWithImpl;
@useResult
$Res call({
 int memoryBytes, double cpuAbsolute, int diskBytes, int networkRxBytes, int networkTxBytes, int uptime
});




}
/// @nodoc
class _$ResourceUsageCopyWithImpl<$Res>
    implements $ResourceUsageCopyWith<$Res> {
  _$ResourceUsageCopyWithImpl(this._self, this._then);

  final ResourceUsage _self;
  final $Res Function(ResourceUsage) _then;

/// Create a copy of ResourceUsage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memoryBytes = null,Object? cpuAbsolute = null,Object? diskBytes = null,Object? networkRxBytes = null,Object? networkTxBytes = null,Object? uptime = null,}) {
  return _then(ResourceUsage(
memoryBytes: null == memoryBytes ? _self.memoryBytes : memoryBytes // ignore: cast_nullable_to_non_nullable
as int,cpuAbsolute: null == cpuAbsolute ? _self.cpuAbsolute : cpuAbsolute // ignore: cast_nullable_to_non_nullable
as double,diskBytes: null == diskBytes ? _self.diskBytes : diskBytes // ignore: cast_nullable_to_non_nullable
as int,networkRxBytes: null == networkRxBytes ? _self.networkRxBytes : networkRxBytes // ignore: cast_nullable_to_non_nullable
as int,networkTxBytes: null == networkTxBytes ? _self.networkTxBytes : networkTxBytes // ignore: cast_nullable_to_non_nullable
as int,uptime: null == uptime ? _self.uptime : uptime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ResourceUsage].
extension ResourceUsagePatterns on ResourceUsage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResourceUsage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResourceUsage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResourceUsage value)  $default,){
final _that = this;
switch (_that) {
case _ResourceUsage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResourceUsage value)?  $default,){
final _that = this;
switch (_that) {
case _ResourceUsage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int memoryBytes,  double cpuAbsolute,  int diskBytes,  int networkRxBytes,  int networkTxBytes,  int uptime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResourceUsage() when $default != null:
return $default(_that.memoryBytes,_that.cpuAbsolute,_that.diskBytes,_that.networkRxBytes,_that.networkTxBytes,_that.uptime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int memoryBytes,  double cpuAbsolute,  int diskBytes,  int networkRxBytes,  int networkTxBytes,  int uptime)  $default,) {final _that = this;
switch (_that) {
case _ResourceUsage():
return $default(_that.memoryBytes,_that.cpuAbsolute,_that.diskBytes,_that.networkRxBytes,_that.networkTxBytes,_that.uptime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int memoryBytes,  double cpuAbsolute,  int diskBytes,  int networkRxBytes,  int networkTxBytes,  int uptime)?  $default,) {final _that = this;
switch (_that) {
case _ResourceUsage() when $default != null:
return $default(_that.memoryBytes,_that.cpuAbsolute,_that.diskBytes,_that.networkRxBytes,_that.networkTxBytes,_that.uptime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResourceUsage implements ResourceUsage {
  const _ResourceUsage({this.memoryBytes = 0, this.cpuAbsolute = 0, this.diskBytes = 0, this.networkRxBytes = 0, this.networkTxBytes = 0, this.uptime = 0});
  factory _ResourceUsage.fromJson(Map<String, dynamic> json) => _$ResourceUsageFromJson(json);

@override@JsonKey() final  int memoryBytes;
@override@JsonKey() final  double cpuAbsolute;
@override@JsonKey() final  int diskBytes;
@override@JsonKey() final  int networkRxBytes;
@override@JsonKey() final  int networkTxBytes;
@override@JsonKey() final  int uptime;

/// Create a copy of ResourceUsage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResourceUsageCopyWith<_ResourceUsage> get copyWith => __$ResourceUsageCopyWithImpl<_ResourceUsage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResourceUsageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResourceUsage&&(identical(other.memoryBytes, memoryBytes) || other.memoryBytes == memoryBytes)&&(identical(other.cpuAbsolute, cpuAbsolute) || other.cpuAbsolute == cpuAbsolute)&&(identical(other.diskBytes, diskBytes) || other.diskBytes == diskBytes)&&(identical(other.networkRxBytes, networkRxBytes) || other.networkRxBytes == networkRxBytes)&&(identical(other.networkTxBytes, networkTxBytes) || other.networkTxBytes == networkTxBytes)&&(identical(other.uptime, uptime) || other.uptime == uptime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,memoryBytes,cpuAbsolute,diskBytes,networkRxBytes,networkTxBytes,uptime);
}

@override
String toString() {
    return 'ResourceUsage(memoryBytes: $memoryBytes, cpuAbsolute: $cpuAbsolute, diskBytes: $diskBytes, networkRxBytes: $networkRxBytes, networkTxBytes: $networkTxBytes, uptime: $uptime)';
}


}

/// @nodoc
abstract mixin class _$ResourceUsageCopyWith<$Res> implements $ResourceUsageCopyWith<$Res> {
  factory _$ResourceUsageCopyWith(_ResourceUsage value, $Res Function(_ResourceUsage) _then) = __$ResourceUsageCopyWithImpl;
@override @useResult
$Res call({
 int memoryBytes, double cpuAbsolute, int diskBytes, int networkRxBytes, int networkTxBytes, int uptime
});




}
/// @nodoc
class __$ResourceUsageCopyWithImpl<$Res>
    implements _$ResourceUsageCopyWith<$Res> {
  __$ResourceUsageCopyWithImpl(this._self, this._then);

  final _ResourceUsage _self;
  final $Res Function(_ResourceUsage) _then;

/// Create a copy of ResourceUsage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memoryBytes = null,Object? cpuAbsolute = null,Object? diskBytes = null,Object? networkRxBytes = null,Object? networkTxBytes = null,Object? uptime = null,}) {
  return _then(_ResourceUsage(
memoryBytes: null == memoryBytes ? _self.memoryBytes : memoryBytes // ignore: cast_nullable_to_non_nullable
as int,cpuAbsolute: null == cpuAbsolute ? _self.cpuAbsolute : cpuAbsolute // ignore: cast_nullable_to_non_nullable
as double,diskBytes: null == diskBytes ? _self.diskBytes : diskBytes // ignore: cast_nullable_to_non_nullable
as int,networkRxBytes: null == networkRxBytes ? _self.networkRxBytes : networkRxBytes // ignore: cast_nullable_to_non_nullable
as int,networkTxBytes: null == networkTxBytes ? _self.networkTxBytes : networkTxBytes // ignore: cast_nullable_to_non_nullable
as int,uptime: null == uptime ? _self.uptime : uptime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TerminalTicket {

 String get ticket; String get expiresAt;
/// Create a copy of TerminalTicket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TerminalTicketCopyWith<TerminalTicket> get copyWith => _$TerminalTicketCopyWithImpl<TerminalTicket>(this as TerminalTicket, _$identity);

  /// Serializes this TerminalTicket to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TerminalTicket;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TerminalTicket&&(identical(other.ticket, _this.ticket) || other.ticket == _this.ticket)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TerminalTicket;
  return Object.hash(runtimeType,_this.ticket,_this.expiresAt);
}

@override
String toString() {
  final _this = this as TerminalTicket;
  return 'TerminalTicket(ticket: ${_this.ticket}, expiresAt: ${_this.expiresAt})';
}


}

/// @nodoc
abstract mixin class $TerminalTicketCopyWith<$Res>  {
  factory $TerminalTicketCopyWith(TerminalTicket value, $Res Function(TerminalTicket) _then) = _$TerminalTicketCopyWithImpl;
@useResult
$Res call({
 String ticket, String expiresAt
});




}
/// @nodoc
class _$TerminalTicketCopyWithImpl<$Res>
    implements $TerminalTicketCopyWith<$Res> {
  _$TerminalTicketCopyWithImpl(this._self, this._then);

  final TerminalTicket _self;
  final $Res Function(TerminalTicket) _then;

/// Create a copy of TerminalTicket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ticket = null,Object? expiresAt = null,}) {
  return _then(TerminalTicket(
ticket: null == ticket ? _self.ticket : ticket // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TerminalTicket].
extension TerminalTicketPatterns on TerminalTicket {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TerminalTicket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TerminalTicket() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TerminalTicket value)  $default,){
final _that = this;
switch (_that) {
case _TerminalTicket():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TerminalTicket value)?  $default,){
final _that = this;
switch (_that) {
case _TerminalTicket() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ticket,  String expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TerminalTicket() when $default != null:
return $default(_that.ticket,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ticket,  String expiresAt)  $default,) {final _that = this;
switch (_that) {
case _TerminalTicket():
return $default(_that.ticket,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ticket,  String expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _TerminalTicket() when $default != null:
return $default(_that.ticket,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TerminalTicket implements TerminalTicket {
  const _TerminalTicket({this.ticket = '', this.expiresAt = ''});
  factory _TerminalTicket.fromJson(Map<String, dynamic> json) => _$TerminalTicketFromJson(json);

@override@JsonKey() final  String ticket;
@override@JsonKey() final  String expiresAt;

/// Create a copy of TerminalTicket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TerminalTicketCopyWith<_TerminalTicket> get copyWith => __$TerminalTicketCopyWithImpl<_TerminalTicket>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TerminalTicketToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TerminalTicket&&(identical(other.ticket, ticket) || other.ticket == ticket)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ticket,expiresAt);
}

@override
String toString() {
    return 'TerminalTicket(ticket: $ticket, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$TerminalTicketCopyWith<$Res> implements $TerminalTicketCopyWith<$Res> {
  factory _$TerminalTicketCopyWith(_TerminalTicket value, $Res Function(_TerminalTicket) _then) = __$TerminalTicketCopyWithImpl;
@override @useResult
$Res call({
 String ticket, String expiresAt
});




}
/// @nodoc
class __$TerminalTicketCopyWithImpl<$Res>
    implements _$TerminalTicketCopyWith<$Res> {
  __$TerminalTicketCopyWithImpl(this._self, this._then);

  final _TerminalTicket _self;
  final $Res Function(_TerminalTicket) _then;

/// Create a copy of TerminalTicket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ticket = null,Object? expiresAt = null,}) {
  return _then(_TerminalTicket(
ticket: null == ticket ? _self.ticket : ticket // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ServerFile {

 String get name; String get mode; String get modeBits; int get size; bool get isFile; bool get isSymlink; bool get isEditable; String get mimeType; String get createdAt; String get modifiedAt;
/// Create a copy of ServerFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerFileCopyWith<ServerFile> get copyWith => _$ServerFileCopyWithImpl<ServerFile>(this as ServerFile, _$identity);

  /// Serializes this ServerFile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ServerFile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerFile&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.modeBits, _this.modeBits) || other.modeBits == _this.modeBits)&&(identical(other.size, _this.size) || other.size == _this.size)&&(identical(other.isFile, _this.isFile) || other.isFile == _this.isFile)&&(identical(other.isSymlink, _this.isSymlink) || other.isSymlink == _this.isSymlink)&&(identical(other.isEditable, _this.isEditable) || other.isEditable == _this.isEditable)&&(identical(other.mimeType, _this.mimeType) || other.mimeType == _this.mimeType)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.modifiedAt, _this.modifiedAt) || other.modifiedAt == _this.modifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ServerFile;
  return Object.hash(runtimeType,_this.name,_this.mode,_this.modeBits,_this.size,_this.isFile,_this.isSymlink,_this.isEditable,_this.mimeType,_this.createdAt,_this.modifiedAt);
}

@override
String toString() {
  final _this = this as ServerFile;
  return 'ServerFile(name: ${_this.name}, mode: ${_this.mode}, modeBits: ${_this.modeBits}, size: ${_this.size}, isFile: ${_this.isFile}, isSymlink: ${_this.isSymlink}, isEditable: ${_this.isEditable}, mimeType: ${_this.mimeType}, createdAt: ${_this.createdAt}, modifiedAt: ${_this.modifiedAt})';
}


}

/// @nodoc
abstract mixin class $ServerFileCopyWith<$Res>  {
  factory $ServerFileCopyWith(ServerFile value, $Res Function(ServerFile) _then) = _$ServerFileCopyWithImpl;
@useResult
$Res call({
 String name, String mode, String modeBits, int size, bool isFile, bool isSymlink, bool isEditable, String mimeType, String createdAt, String modifiedAt
});




}
/// @nodoc
class _$ServerFileCopyWithImpl<$Res>
    implements $ServerFileCopyWith<$Res> {
  _$ServerFileCopyWithImpl(this._self, this._then);

  final ServerFile _self;
  final $Res Function(ServerFile) _then;

/// Create a copy of ServerFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? mode = null,Object? modeBits = null,Object? size = null,Object? isFile = null,Object? isSymlink = null,Object? isEditable = null,Object? mimeType = null,Object? createdAt = null,Object? modifiedAt = null,}) {
  return _then(ServerFile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,modeBits: null == modeBits ? _self.modeBits : modeBits // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,isFile: null == isFile ? _self.isFile : isFile // ignore: cast_nullable_to_non_nullable
as bool,isSymlink: null == isSymlink ? _self.isSymlink : isSymlink // ignore: cast_nullable_to_non_nullable
as bool,isEditable: null == isEditable ? _self.isEditable : isEditable // ignore: cast_nullable_to_non_nullable
as bool,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,modifiedAt: null == modifiedAt ? _self.modifiedAt : modifiedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerFile].
extension ServerFilePatterns on ServerFile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerFile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerFile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerFile value)  $default,){
final _that = this;
switch (_that) {
case _ServerFile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerFile value)?  $default,){
final _that = this;
switch (_that) {
case _ServerFile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String mode,  String modeBits,  int size,  bool isFile,  bool isSymlink,  bool isEditable,  String mimeType,  String createdAt,  String modifiedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerFile() when $default != null:
return $default(_that.name,_that.mode,_that.modeBits,_that.size,_that.isFile,_that.isSymlink,_that.isEditable,_that.mimeType,_that.createdAt,_that.modifiedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String mode,  String modeBits,  int size,  bool isFile,  bool isSymlink,  bool isEditable,  String mimeType,  String createdAt,  String modifiedAt)  $default,) {final _that = this;
switch (_that) {
case _ServerFile():
return $default(_that.name,_that.mode,_that.modeBits,_that.size,_that.isFile,_that.isSymlink,_that.isEditable,_that.mimeType,_that.createdAt,_that.modifiedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String mode,  String modeBits,  int size,  bool isFile,  bool isSymlink,  bool isEditable,  String mimeType,  String createdAt,  String modifiedAt)?  $default,) {final _that = this;
switch (_that) {
case _ServerFile() when $default != null:
return $default(_that.name,_that.mode,_that.modeBits,_that.size,_that.isFile,_that.isSymlink,_that.isEditable,_that.mimeType,_that.createdAt,_that.modifiedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServerFile implements ServerFile {
  const _ServerFile({this.name = '', this.mode = '', this.modeBits = '', this.size = 0, this.isFile = false, this.isSymlink = false, this.isEditable = false, this.mimeType = '', this.createdAt = '', this.modifiedAt = ''});
  factory _ServerFile.fromJson(Map<String, dynamic> json) => _$ServerFileFromJson(json);

@override@JsonKey() final  String name;
@override@JsonKey() final  String mode;
@override@JsonKey() final  String modeBits;
@override@JsonKey() final  int size;
@override@JsonKey() final  bool isFile;
@override@JsonKey() final  bool isSymlink;
@override@JsonKey() final  bool isEditable;
@override@JsonKey() final  String mimeType;
@override@JsonKey() final  String createdAt;
@override@JsonKey() final  String modifiedAt;

/// Create a copy of ServerFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerFileCopyWith<_ServerFile> get copyWith => __$ServerFileCopyWithImpl<_ServerFile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServerFileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerFile&&(identical(other.name, name) || other.name == name)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.modeBits, modeBits) || other.modeBits == modeBits)&&(identical(other.size, size) || other.size == size)&&(identical(other.isFile, isFile) || other.isFile == isFile)&&(identical(other.isSymlink, isSymlink) || other.isSymlink == isSymlink)&&(identical(other.isEditable, isEditable) || other.isEditable == isEditable)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.modifiedAt, modifiedAt) || other.modifiedAt == modifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,mode,modeBits,size,isFile,isSymlink,isEditable,mimeType,createdAt,modifiedAt);
}

@override
String toString() {
    return 'ServerFile(name: $name, mode: $mode, modeBits: $modeBits, size: $size, isFile: $isFile, isSymlink: $isSymlink, isEditable: $isEditable, mimeType: $mimeType, createdAt: $createdAt, modifiedAt: $modifiedAt)';
}


}

/// @nodoc
abstract mixin class _$ServerFileCopyWith<$Res> implements $ServerFileCopyWith<$Res> {
  factory _$ServerFileCopyWith(_ServerFile value, $Res Function(_ServerFile) _then) = __$ServerFileCopyWithImpl;
@override @useResult
$Res call({
 String name, String mode, String modeBits, int size, bool isFile, bool isSymlink, bool isEditable, String mimeType, String createdAt, String modifiedAt
});




}
/// @nodoc
class __$ServerFileCopyWithImpl<$Res>
    implements _$ServerFileCopyWith<$Res> {
  __$ServerFileCopyWithImpl(this._self, this._then);

  final _ServerFile _self;
  final $Res Function(_ServerFile) _then;

/// Create a copy of ServerFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? mode = null,Object? modeBits = null,Object? size = null,Object? isFile = null,Object? isSymlink = null,Object? isEditable = null,Object? mimeType = null,Object? createdAt = null,Object? modifiedAt = null,}) {
  return _then(_ServerFile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,modeBits: null == modeBits ? _self.modeBits : modeBits // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,isFile: null == isFile ? _self.isFile : isFile // ignore: cast_nullable_to_non_nullable
as bool,isSymlink: null == isSymlink ? _self.isSymlink : isSymlink // ignore: cast_nullable_to_non_nullable
as bool,isEditable: null == isEditable ? _self.isEditable : isEditable // ignore: cast_nullable_to_non_nullable
as bool,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,modifiedAt: null == modifiedAt ? _self.modifiedAt : modifiedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ServerFileList {

 List<ServerFile> get items;
/// Create a copy of ServerFileList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerFileListCopyWith<ServerFileList> get copyWith => _$ServerFileListCopyWithImpl<ServerFileList>(this as ServerFileList, _$identity);

  /// Serializes this ServerFileList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ServerFileList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerFileList&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ServerFileList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as ServerFileList;
  return 'ServerFileList(items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $ServerFileListCopyWith<$Res>  {
  factory $ServerFileListCopyWith(ServerFileList value, $Res Function(ServerFileList) _then) = _$ServerFileListCopyWithImpl;
@useResult
$Res call({
 List<ServerFile> items
});




}
/// @nodoc
class _$ServerFileListCopyWithImpl<$Res>
    implements $ServerFileListCopyWith<$Res> {
  _$ServerFileListCopyWithImpl(this._self, this._then);

  final ServerFileList _self;
  final $Res Function(ServerFileList) _then;

/// Create a copy of ServerFileList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(ServerFileList(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ServerFile>,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerFileList].
extension ServerFileListPatterns on ServerFileList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerFileList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerFileList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerFileList value)  $default,){
final _that = this;
switch (_that) {
case _ServerFileList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerFileList value)?  $default,){
final _that = this;
switch (_that) {
case _ServerFileList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ServerFile> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerFileList() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ServerFile> items)  $default,) {final _that = this;
switch (_that) {
case _ServerFileList():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ServerFile> items)?  $default,) {final _that = this;
switch (_that) {
case _ServerFileList() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServerFileList implements ServerFileList {
  const _ServerFileList({ List<ServerFile> items = const <ServerFile>[]}): _items = items;
  factory _ServerFileList.fromJson(Map<String, dynamic> json) => _$ServerFileListFromJson(json);

 final  List<ServerFile> _items;
@override@JsonKey() List<ServerFile> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ServerFileList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerFileListCopyWith<_ServerFileList> get copyWith => __$ServerFileListCopyWithImpl<_ServerFileList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServerFileListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerFileList&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'ServerFileList(items: $items)';
}


}

/// @nodoc
abstract mixin class _$ServerFileListCopyWith<$Res> implements $ServerFileListCopyWith<$Res> {
  factory _$ServerFileListCopyWith(_ServerFileList value, $Res Function(_ServerFileList) _then) = __$ServerFileListCopyWithImpl;
@override @useResult
$Res call({
 List<ServerFile> items
});




}
/// @nodoc
class __$ServerFileListCopyWithImpl<$Res>
    implements _$ServerFileListCopyWith<$Res> {
  __$ServerFileListCopyWithImpl(this._self, this._then);

  final _ServerFileList _self;
  final $Res Function(_ServerFileList) _then;

/// Create a copy of ServerFileList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_ServerFileList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ServerFile>,
  ));
}


}


/// @nodoc
mixin _$FileContent {

 String get content;
/// Create a copy of FileContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileContentCopyWith<FileContent> get copyWith => _$FileContentCopyWithImpl<FileContent>(this as FileContent, _$identity);

  /// Serializes this FileContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FileContent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileContent&&(identical(other.content, _this.content) || other.content == _this.content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FileContent;
  return Object.hash(runtimeType,_this.content);
}

@override
String toString() {
  final _this = this as FileContent;
  return 'FileContent(content: ${_this.content})';
}


}

/// @nodoc
abstract mixin class $FileContentCopyWith<$Res>  {
  factory $FileContentCopyWith(FileContent value, $Res Function(FileContent) _then) = _$FileContentCopyWithImpl;
@useResult
$Res call({
 String content
});




}
/// @nodoc
class _$FileContentCopyWithImpl<$Res>
    implements $FileContentCopyWith<$Res> {
  _$FileContentCopyWithImpl(this._self, this._then);

  final FileContent _self;
  final $Res Function(FileContent) _then;

/// Create a copy of FileContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,}) {
  return _then(FileContent(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FileContent].
extension FileContentPatterns on FileContent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FileContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FileContent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FileContent value)  $default,){
final _that = this;
switch (_that) {
case _FileContent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FileContent value)?  $default,){
final _that = this;
switch (_that) {
case _FileContent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FileContent() when $default != null:
return $default(_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String content)  $default,) {final _that = this;
switch (_that) {
case _FileContent():
return $default(_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String content)?  $default,) {final _that = this;
switch (_that) {
case _FileContent() when $default != null:
return $default(_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FileContent implements FileContent {
  const _FileContent({this.content = ''});
  factory _FileContent.fromJson(Map<String, dynamic> json) => _$FileContentFromJson(json);

@override@JsonKey() final  String content;

/// Create a copy of FileContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileContentCopyWith<_FileContent> get copyWith => __$FileContentCopyWithImpl<_FileContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FileContentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FileContent&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,content);
}

@override
String toString() {
    return 'FileContent(content: $content)';
}


}

/// @nodoc
abstract mixin class _$FileContentCopyWith<$Res> implements $FileContentCopyWith<$Res> {
  factory _$FileContentCopyWith(_FileContent value, $Res Function(_FileContent) _then) = __$FileContentCopyWithImpl;
@override @useResult
$Res call({
 String content
});




}
/// @nodoc
class __$FileContentCopyWithImpl<$Res>
    implements _$FileContentCopyWith<$Res> {
  __$FileContentCopyWithImpl(this._self, this._then);

  final _FileContent _self;
  final $Res Function(_FileContent) _then;

/// Create a copy of FileContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,}) {
  return _then(_FileContent(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ServerBackup {

 String get uuid; String get name; int get bytes; bool get completed; bool get locked; String get createdAt; String get checksum; String get status; int get progress;
/// Create a copy of ServerBackup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerBackupCopyWith<ServerBackup> get copyWith => _$ServerBackupCopyWithImpl<ServerBackup>(this as ServerBackup, _$identity);

  /// Serializes this ServerBackup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ServerBackup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerBackup&&(identical(other.uuid, _this.uuid) || other.uuid == _this.uuid)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.bytes, _this.bytes) || other.bytes == _this.bytes)&&(identical(other.completed, _this.completed) || other.completed == _this.completed)&&(identical(other.locked, _this.locked) || other.locked == _this.locked)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.checksum, _this.checksum) || other.checksum == _this.checksum)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.progress, _this.progress) || other.progress == _this.progress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ServerBackup;
  return Object.hash(runtimeType,_this.uuid,_this.name,_this.bytes,_this.completed,_this.locked,_this.createdAt,_this.checksum,_this.status,_this.progress);
}

@override
String toString() {
  final _this = this as ServerBackup;
  return 'ServerBackup(uuid: ${_this.uuid}, name: ${_this.name}, bytes: ${_this.bytes}, completed: ${_this.completed}, locked: ${_this.locked}, createdAt: ${_this.createdAt}, checksum: ${_this.checksum}, status: ${_this.status}, progress: ${_this.progress})';
}


}

/// @nodoc
abstract mixin class $ServerBackupCopyWith<$Res>  {
  factory $ServerBackupCopyWith(ServerBackup value, $Res Function(ServerBackup) _then) = _$ServerBackupCopyWithImpl;
@useResult
$Res call({
 String uuid, String name, int bytes, bool completed, bool locked, String createdAt, String checksum, String status, int progress
});




}
/// @nodoc
class _$ServerBackupCopyWithImpl<$Res>
    implements $ServerBackupCopyWith<$Res> {
  _$ServerBackupCopyWithImpl(this._self, this._then);

  final ServerBackup _self;
  final $Res Function(ServerBackup) _then;

/// Create a copy of ServerBackup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = null,Object? name = null,Object? bytes = null,Object? completed = null,Object? locked = null,Object? createdAt = null,Object? checksum = null,Object? status = null,Object? progress = null,}) {
  return _then(ServerBackup(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,locked: null == locked ? _self.locked : locked // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,checksum: null == checksum ? _self.checksum : checksum // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerBackup].
extension ServerBackupPatterns on ServerBackup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerBackup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerBackup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerBackup value)  $default,){
final _that = this;
switch (_that) {
case _ServerBackup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerBackup value)?  $default,){
final _that = this;
switch (_that) {
case _ServerBackup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uuid,  String name,  int bytes,  bool completed,  bool locked,  String createdAt,  String checksum,  String status,  int progress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerBackup() when $default != null:
return $default(_that.uuid,_that.name,_that.bytes,_that.completed,_that.locked,_that.createdAt,_that.checksum,_that.status,_that.progress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uuid,  String name,  int bytes,  bool completed,  bool locked,  String createdAt,  String checksum,  String status,  int progress)  $default,) {final _that = this;
switch (_that) {
case _ServerBackup():
return $default(_that.uuid,_that.name,_that.bytes,_that.completed,_that.locked,_that.createdAt,_that.checksum,_that.status,_that.progress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uuid,  String name,  int bytes,  bool completed,  bool locked,  String createdAt,  String checksum,  String status,  int progress)?  $default,) {final _that = this;
switch (_that) {
case _ServerBackup() when $default != null:
return $default(_that.uuid,_that.name,_that.bytes,_that.completed,_that.locked,_that.createdAt,_that.checksum,_that.status,_that.progress);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServerBackup implements ServerBackup {
  const _ServerBackup({this.uuid = '', this.name = '', this.bytes = 0, this.completed = false, this.locked = false, this.createdAt = '', this.checksum = '', this.status = '', this.progress = 0});
  factory _ServerBackup.fromJson(Map<String, dynamic> json) => _$ServerBackupFromJson(json);

@override@JsonKey() final  String uuid;
@override@JsonKey() final  String name;
@override@JsonKey() final  int bytes;
@override@JsonKey() final  bool completed;
@override@JsonKey() final  bool locked;
@override@JsonKey() final  String createdAt;
@override@JsonKey() final  String checksum;
@override@JsonKey() final  String status;
@override@JsonKey() final  int progress;

/// Create a copy of ServerBackup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerBackupCopyWith<_ServerBackup> get copyWith => __$ServerBackupCopyWithImpl<_ServerBackup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServerBackupToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerBackup&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.name, name) || other.name == name)&&(identical(other.bytes, bytes) || other.bytes == bytes)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.locked, locked) || other.locked == locked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.checksum, checksum) || other.checksum == checksum)&&(identical(other.status, status) || other.status == status)&&(identical(other.progress, progress) || other.progress == progress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,uuid,name,bytes,completed,locked,createdAt,checksum,status,progress);
}

@override
String toString() {
    return 'ServerBackup(uuid: $uuid, name: $name, bytes: $bytes, completed: $completed, locked: $locked, createdAt: $createdAt, checksum: $checksum, status: $status, progress: $progress)';
}


}

/// @nodoc
abstract mixin class _$ServerBackupCopyWith<$Res> implements $ServerBackupCopyWith<$Res> {
  factory _$ServerBackupCopyWith(_ServerBackup value, $Res Function(_ServerBackup) _then) = __$ServerBackupCopyWithImpl;
@override @useResult
$Res call({
 String uuid, String name, int bytes, bool completed, bool locked, String createdAt, String checksum, String status, int progress
});




}
/// @nodoc
class __$ServerBackupCopyWithImpl<$Res>
    implements _$ServerBackupCopyWith<$Res> {
  __$ServerBackupCopyWithImpl(this._self, this._then);

  final _ServerBackup _self;
  final $Res Function(_ServerBackup) _then;

/// Create a copy of ServerBackup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = null,Object? name = null,Object? bytes = null,Object? completed = null,Object? locked = null,Object? createdAt = null,Object? checksum = null,Object? status = null,Object? progress = null,}) {
  return _then(_ServerBackup(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,locked: null == locked ? _self.locked : locked // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,checksum: null == checksum ? _self.checksum : checksum // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ServerBackupList {

 List<ServerBackup> get items;
/// Create a copy of ServerBackupList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerBackupListCopyWith<ServerBackupList> get copyWith => _$ServerBackupListCopyWithImpl<ServerBackupList>(this as ServerBackupList, _$identity);

  /// Serializes this ServerBackupList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ServerBackupList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerBackupList&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ServerBackupList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as ServerBackupList;
  return 'ServerBackupList(items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $ServerBackupListCopyWith<$Res>  {
  factory $ServerBackupListCopyWith(ServerBackupList value, $Res Function(ServerBackupList) _then) = _$ServerBackupListCopyWithImpl;
@useResult
$Res call({
 List<ServerBackup> items
});




}
/// @nodoc
class _$ServerBackupListCopyWithImpl<$Res>
    implements $ServerBackupListCopyWith<$Res> {
  _$ServerBackupListCopyWithImpl(this._self, this._then);

  final ServerBackupList _self;
  final $Res Function(ServerBackupList) _then;

/// Create a copy of ServerBackupList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(ServerBackupList(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ServerBackup>,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerBackupList].
extension ServerBackupListPatterns on ServerBackupList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerBackupList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerBackupList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerBackupList value)  $default,){
final _that = this;
switch (_that) {
case _ServerBackupList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerBackupList value)?  $default,){
final _that = this;
switch (_that) {
case _ServerBackupList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ServerBackup> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerBackupList() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ServerBackup> items)  $default,) {final _that = this;
switch (_that) {
case _ServerBackupList():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ServerBackup> items)?  $default,) {final _that = this;
switch (_that) {
case _ServerBackupList() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServerBackupList implements ServerBackupList {
  const _ServerBackupList({ List<ServerBackup> items = const <ServerBackup>[]}): _items = items;
  factory _ServerBackupList.fromJson(Map<String, dynamic> json) => _$ServerBackupListFromJson(json);

 final  List<ServerBackup> _items;
@override@JsonKey() List<ServerBackup> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ServerBackupList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerBackupListCopyWith<_ServerBackupList> get copyWith => __$ServerBackupListCopyWithImpl<_ServerBackupList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServerBackupListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerBackupList&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'ServerBackupList(items: $items)';
}


}

/// @nodoc
abstract mixin class _$ServerBackupListCopyWith<$Res> implements $ServerBackupListCopyWith<$Res> {
  factory _$ServerBackupListCopyWith(_ServerBackupList value, $Res Function(_ServerBackupList) _then) = __$ServerBackupListCopyWithImpl;
@override @useResult
$Res call({
 List<ServerBackup> items
});




}
/// @nodoc
class __$ServerBackupListCopyWithImpl<$Res>
    implements _$ServerBackupListCopyWith<$Res> {
  __$ServerBackupListCopyWithImpl(this._self, this._then);

  final _ServerBackupList _self;
  final $Res Function(_ServerBackupList) _then;

/// Create a copy of ServerBackupList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_ServerBackupList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ServerBackup>,
  ));
}


}

// dart format on
