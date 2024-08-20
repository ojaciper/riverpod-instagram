import 'package:instantgram_clone/state/post_settings/constants/constants.dart';

enum PostsSettings {
  allowLikes(
    title: Constants.allowLikesTitle,
    description: Constants.allowLikesDescription,
    storageKey: Constants.allowLikesStorageKey,
  ),
  allowComments(
    title: Constants.allowCommentsTitle,
    description: Constants.allowCommentsDescription,
    storageKey: Constants.allowCommentsStorageKey,
  );

  final String title;
  final String description;
  final String storageKey;

  const PostsSettings({
    required this.title,
    required this.description,
    required this.storageKey,
  });
}
