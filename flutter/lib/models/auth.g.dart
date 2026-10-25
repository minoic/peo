// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) =>
    _LoginRequest(
      login: json['login'] as String,
      password: json['password'] as String,
      remember: json['remember'] as bool? ?? false,
    );

Map<String, dynamic> _$LoginRequestToJson(_LoginRequest instance) =>
    <String, dynamic>{
      'login': instance.login,
      'password': instance.password,
      'remember': instance.remember,
    };

_RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    _RegisterRequest(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$RegisterRequestToJson(_RegisterRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
    };

_ForgetPasswordRequest _$ForgetPasswordRequestFromJson(
  Map<String, dynamic> json,
) => _ForgetPasswordRequest(email: json['email'] as String);

Map<String, dynamic> _$ForgetPasswordRequestToJson(
  _ForgetPasswordRequest instance,
) => <String, dynamic>{'email': instance.email};

_ResetPasswordRequest _$ResetPasswordRequestFromJson(
  Map<String, dynamic> json,
) => _ResetPasswordRequest(
  email: json['email'] as String,
  code: json['code'] as String,
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$ResetPasswordRequestToJson(
  _ResetPasswordRequest instance,
) => <String, dynamic>{
  'email': instance.email,
  'code': instance.code,
  'newPassword': instance.newPassword,
};

_ChangePasswordRequest _$ChangePasswordRequestFromJson(
  Map<String, dynamic> json,
) => _ChangePasswordRequest(
  oldPassword: json['oldPassword'] as String,
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$ChangePasswordRequestToJson(
  _ChangePasswordRequest instance,
) => <String, dynamic>{
  'oldPassword': instance.oldPassword,
  'newPassword': instance.newPassword,
};

_ChangeEmailRequest _$ChangeEmailRequestFromJson(Map<String, dynamic> json) =>
    _ChangeEmailRequest(email: json['email'] as String);

Map<String, dynamic> _$ChangeEmailRequestToJson(_ChangeEmailRequest instance) =>
    <String, dynamic>{'email': instance.email};

_ConfirmEmailRequest _$ConfirmEmailRequestFromJson(Map<String, dynamic> json) =>
    _ConfirmEmailRequest(
      email: json['email'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$ConfirmEmailRequestToJson(
  _ConfirmEmailRequest instance,
) => <String, dynamic>{'email': instance.email, 'code': instance.code};

_SessionResponse _$SessionResponseFromJson(Map<String, dynamic> json) =>
    _SessionResponse(
      accessToken: json['accessToken'] as String,
      expiresAt: json['expiresAt'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SessionResponseToJson(_SessionResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'expiresAt': instance.expiresAt,
      'user': instance.user,
    };

_UserResponse _$UserResponseFromJson(Map<String, dynamic> json) =>
    _UserResponse(user: User.fromJson(json['user'] as Map<String, dynamic>));

Map<String, dynamic> _$UserResponseToJson(_UserResponse instance) =>
    <String, dynamic>{'user': instance.user};
