import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram_clone/state/posts/provider/user_posts_provider.dart';
import 'package:instantgram_clone/views/components/animations/models/empty_contents_with_text_animation_view.dart';
import 'package:instantgram_clone/views/components/animations/models/error_animation.dart';
import 'package:instantgram_clone/views/components/animations/models/loading_animation.dart';
import 'package:instantgram_clone/views/constants/strings.dart';

class UserPostsView extends ConsumerWidget {
  const UserPostsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(userPostsProvider);
    return RefreshIndicator(
      onRefresh: () {
        ref.refresh(userPostsProvider);
        return Future.delayed(const Duration(seconds: 1));
      },
      child: posts.when(data: (post) {
        if (post.isEmpty) {
          return const EmptyContentsWithTextAnimationView(
            text: Strings.youHaveNoPosts,
          );
        } else {
          return const Text('');
        }
      }, error: (error, stackTrace) {
        return const ErrorAnimation();
      }, loading: () {
        return const LoadingAnimation();
      }),
    );
  }
}
