import 'package:instantgram_clone/state/auth/providers/auth_state_provider.dart';
import 'package:instantgram_clone/state/posts/typedefs/user_id.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userIdProvider = Provider<UserId?>(
  (ref) => ref.watch(authStateProvider).userId,
);
