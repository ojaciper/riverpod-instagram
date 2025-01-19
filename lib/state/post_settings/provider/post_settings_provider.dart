import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram_clone/state/post_settings/model/posts_settings.dart';
import 'package:instantgram_clone/state/post_settings/notifiers/post_setting_notifier.dart';

final postSettingProvider =
    StateNotifierProvider<PostSettingNotifier, Map<PostsSettings, bool>>(
  (ref) => PostSettingNotifier(),
);
