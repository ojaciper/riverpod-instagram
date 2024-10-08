import 'package:flutter/foundation.dart' show immutable;

@immutable
class Strings {
  static const allowLikesTitle = 'Allow likes';
  static const allowLikesDescription =
      'By allowing likes,users will be able to press the like button on your post.';
  static const allowLikesStorageKey = 'allow_likes';
  static const allowCommentsTitle = 'Allow comments';
  static const allowCommentsDescription =
      'By allowing comments, users will be able to comment on your post.';
  static const allowCommentsStorageKey = 'allow_comments';

  static const comment = 'comment';
  static const loading = 'Loading';
  static const person = 'person';
  static const people = 'people';
  static const likedThis = 'liked this';

  static const delete = "Delete";
  static const areYouSureYouWantToDeleteThis =
      'Are you sure your want to delete this';

  //log out
  static const logout = 'Log out';
  static const areYouSureYouWantToLogOutFromThisApp =
      'Are you sure you want to log out from the app?';
  static const cancel = 'Cancel';

  const Strings._();
}
