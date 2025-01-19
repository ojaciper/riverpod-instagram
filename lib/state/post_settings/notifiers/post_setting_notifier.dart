import 'dart:collection';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram_clone/state/post_settings/model/posts_settings.dart';

class PostSettingNotifier extends StateNotifier<Map<PostsSettings, bool>> {
  PostSettingNotifier()
      : super(
          UnmodifiableMapView(
            {
              for (final setting in PostsSettings.values) setting: true,
            },
          ),
        );

  void setSetting(PostsSettings setting, bool value) {
    final existingValue = state[setting];
    if (existingValue == null || existingValue == value) {
      return;
    }
    state = Map.unmodifiable(Map.from(state)..[setting] = value);
  }
}
