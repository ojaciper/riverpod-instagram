import 'package:flutter/material.dart';
import 'package:instantgram_clone/state/post_settings/model/post.dart';

class PostThumbnailView extends StatelessWidget {
  final Post post;
  final VoidCallback voidCallback;
  const PostThumbnailView({
    required this.post,
    required this.voidCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: voidCallback,
      child: Image.network(
        post.thumbnailUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
