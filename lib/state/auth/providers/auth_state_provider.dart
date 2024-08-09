import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram_clone/state/auth/models/auth_state.dart';
import 'package:instantgram_clone/state/notifiers/auth_state_notifier.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (_) => AuthStateNotifier(),
);
