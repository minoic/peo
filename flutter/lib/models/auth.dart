/// Authentication request and response bodies.
///
/// Mirrors `server/internal/api/dto/auth.go`.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'documents.dart';

part 'auth.freezed.dart';
part 'auth.g.dart';

/// Credentials of a sign-in attempt.
@freezed
abstract class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    /// Either the user name or the e-mail address; the server tries both.
    required String login,
    required String password,

    /// Issues the long lived token (60 days instead of 24 hours).
    @Default(false) bool remember,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

/// A new account.
@freezed
abstract class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String name,
    required String email,
    required String password,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}

/// Starts the password reset flow.
@freezed
abstract class ForgetPasswordRequest with _$ForgetPasswordRequest {
  const factory ForgetPasswordRequest({required String email}) =
      _ForgetPasswordRequest;

  factory ForgetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ForgetPasswordRequestFromJson(json);
}

/// Finishes the password reset flow with the mailed code.
///
/// The e-mail address is repeated because this endpoint is anonymous: there is
/// no session to take the identity from.
@freezed
abstract class ResetPasswordRequest with _$ResetPasswordRequest {
  const factory ResetPasswordRequest({
    required String email,
    required String code,
    required String newPassword,
  }) = _ResetPasswordRequest;

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);
}

/// Rotates the password of the signed-in user.
@freezed
abstract class ChangePasswordRequest with _$ChangePasswordRequest {
  const factory ChangePasswordRequest({
    required String oldPassword,
    required String newPassword,
  }) = _ChangePasswordRequest;

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);
}

/// Asks for a confirmation code to be mailed to the new address.
@freezed
abstract class ChangeEmailRequest with _$ChangeEmailRequest {
  const factory ChangeEmailRequest({required String email}) =
      _ChangeEmailRequest;

  factory ChangeEmailRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangeEmailRequestFromJson(json);
}

/// Completes an e-mail change.
///
/// The address is repeated because the mailed code is stored under the address,
/// not under the account.
@freezed
abstract class ConfirmEmailRequest with _$ConfirmEmailRequest {
  const factory ConfirmEmailRequest({
    required String email,
    required String code,
  }) = _ConfirmEmailRequest;

  factory ConfirmEmailRequest.fromJson(Map<String, dynamic> json) =>
      _$ConfirmEmailRequestFromJson(json);
}

/// The login and registration success payload.
@freezed
abstract class SessionResponse with _$SessionResponse {
  const factory SessionResponse({
    required String accessToken,
    required String expiresAt,
    required User user,
  }) = _SessionResponse;

  factory SessionResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionResponseFromJson(json);
}

/// The profile payload of `GET /auth/me`.
@freezed
abstract class UserResponse with _$UserResponse {
  const factory UserResponse({required User user}) = _UserResponse;

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
}
