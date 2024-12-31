import 'package:flutter/material.dart';
import 'package:instantgram_clone/state/post_settings/model/post.dart';
import 'package:instantgram_clone/views/components/post/post_thumbnail_view.dart';

class PostGridView extends StatelessWidget {
  final Iterable<Post> posts;
  const PostGridView({required this.posts, super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts.elementAt(index);
        return PostThumbnailView(
          post: post,
          voidCallback: () {
            // TODO: Navigate to the post details View
          },
        );
      },
    );
  }
}
