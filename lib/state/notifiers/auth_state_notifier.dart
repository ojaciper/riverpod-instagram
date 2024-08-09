import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram_clone/main.dart';
import 'package:instantgram_clone/state/auth/backend/authenticator.dart';
import 'package:instantgram_clone/state/auth/models/auth_result.dart';
import 'package:instantgram_clone/state/auth/models/auth_state.dart';
import 'package:instantgram_clone/state/posts/typedefs/user_id.dart';
import 'package:instantgram_clone/state/user_info/models/backend/user_info_storage.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final _authenticator = const Authenticator();
  final _userInfoStorage = UserInfoStorage();

  AuthStateNotifier() : super(const AuthState.unknow()) {
    if (_authenticator.isAlreadyLoggedIn) {
      state = AuthState(
          result: AuthResult.success,
          isLoading: false,
          userId: _authenticator.userId);
    }
  }

  Future<void> logOut() async {
    state = state.copiedWithIsloading(true);
    await _authenticator.logOut();
    state = const AuthState.unknow();
  }

  Future<void> loginWithGoogle() async {
    state = state.copiedWithIsloading(true);
    final result = await _authenticator.loginWithGoogle();
    final userId = _authenticator.userId;
    if (result == AuthResult.success && _authenticator.userId != null) {
      await saveUserInfo(userId: userId!);
    }
    state = AuthState(
      result: AuthResult.success,
      isLoading: false,
      userId: userId,
    );
  }

  Future<void> loginWithFacebook() async {
    state = state.copiedWithIsloading(true);

    final result = await _authenticator.loginWithFacebook();
    if (result == AuthResult.success) {
      final userId = _authenticator.userId;
      if (result == AuthResult.success && _authenticator.userId != null) {
        await saveUserInfo(userId: userId!);
      }
      state = AuthState(
        result: AuthResult.success,
        isLoading: false,
        userId: userId,
      );
    } else {
      result.log();
    }
  }

  Future<void> saveUserInfo({required UserId userId}) =>
      _userInfoStorage.saveUserInfo(
        userId: userId,
        displayName: _authenticator.displayName,
        email: _authenticator.email,
      );
}
