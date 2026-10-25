/// The account settings page: password, e-mail address, and the panel account.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/peo_api.dart';
import '../models/auth.dart';
import 'async_value.dart';

/// The state of the settings page's three forms.
@immutable
class AccountState {
  const AccountState({
    this.password = const ActionState.idle(),
    this.email = const ActionState.idle(),
  });

  /// The password change form.
  final ActionState password;

  /// The e-mail change form, and its confirmation form.
  final ActionState email;

  AccountState copyWith({ActionState? password, ActionState? email}) =>
      AccountState(
        password: password ?? this.password,
        email: email ?? this.email,
      );
}

/// Owns the account settings actions.
class AccountCubit extends Cubit<AccountState> {
  AccountCubit(this.api) : super(const AccountState());

  final PeoApi api;

  /// Changes the password.
  ///
  /// The server also rotates the panel password when the panel account already
  /// exists, so this one call covers both systems.
  Future<ActionState> changePassword(ChangePasswordRequest body) async {
    emit(state.copyWith(password: const ActionState.pending()));
    final result = await perform(() async {
      await api.changePassword(body);
      return 'password updated';
    });
    if (isClosed) return result;
    emit(state.copyWith(password: result));
    return result;
  }

  /// Requests an e-mail change.
  ///
  /// The new address is not in force until the code is confirmed, and the server
  /// rate limits the request per address, so a repeated request reports
  /// `rate_limited` rather than succeeding silently.
  Future<ActionState> requestEmailChange(String email) async {
    emit(state.copyWith(email: const ActionState.pending()));
    final result = await perform(() async {
      await api.requestEmailChange(ChangeEmailRequest(email: email));
      return 'a confirmation code has been sent';
    });
    if (isClosed) return result;
    emit(state.copyWith(email: result));
    return result;
  }

  /// Confirms the new address with the mailed code.
  Future<ActionState> confirmEmailChange({
    required String email,
    required String code,
  }) async {
    emit(state.copyWith(email: const ActionState.pending()));
    final result = await perform(() async {
      await api.confirmEmailChange(
        ConfirmEmailRequest(email: email, code: code),
      );
      return 'e-mail updated';
    });
    if (isClosed) return result;
    emit(state.copyWith(email: result));
    return result;
  }
}
