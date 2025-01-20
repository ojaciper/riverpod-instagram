import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image/image.dart' as img;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instantgram_clone/state/constants/firebase_collection_name.dart';
import 'package:instantgram_clone/state/image_upload/extension/get_collection_name_from_file_type.dart';
import 'package:instantgram_clone/state/posts/models/post_payload.dart';
import 'package:uuid/uuid.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram_clone/state/image_upload/constant/constants.dart';
import 'package:instantgram_clone/state/image_upload/exceptions/could_not_build_thumbnail_exception.dart';
import 'package:instantgram_clone/state/image_upload/extension/get_image_data_aspect_ratio.dart';
import 'package:instantgram_clone/state/image_upload/model/file_type.dart';
import 'package:instantgram_clone/state/image_upload/typedefs/is_loding.dart';
import 'package:instantgram_clone/state/post_settings/model/posts_settings.dart';
import 'package:instantgram_clone/state/posts/typedefs/user_id.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ImageUploadNotifier extends StateNotifier<IsLoading> {
  ImageUploadNotifier() : super(false);

  set isLoading(bool value) => state = true;

  Future<bool> upload({
    required File file,
    required FileType fileType,
    required String message,
    required Map<PostsSettings, bool> postSettings,
    required UserId userId,
  }) async {
    isLoading = true;
    late Uint8List thumbnailUint8List;
    switch (fileType) {
      // image
      case FileType.image:
        final fileAsImage = img.decodeImage(file.readAsBytesSync());
        if (fileAsImage == null) {
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
        }
        // create thumbnail
        final thumbnail =
            img.copyResize(fileAsImage, width: Constants.imageThumbnailWidth);
        final thumbnailData = img.encodeJpg(thumbnail);
        thumbnailUint8List = Uint8List.fromList(thumbnailData);
        break;
      // video
      case FileType.video:
        final thumb = await VideoThumbnail.thumbnailData(
          video: file.path,
          imageFormat: ImageFormat.JPEG,
          maxHeight: Constants.videoThumbnailMaxHeight,
          quality: Constants.videoThumbnailQuality,
        );
        if (thumb == null) {
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
        } else {
          thumbnailUint8List = thumb;
        }
        break;
    }

    // calculate the aspect ratio

    final thumbnailAspectRatio = await thumbnailUint8List.getAspectRatio();

    // calculate references
    final fileName = Uuid().v4();

    // create referecnces to thumbnail and the image itself

    final thumbnailRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(FirebaseCollectionName.thumbnails)
        .child(fileName);

    final originalFileRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(fileType.collectionName)
        .child(fileName);

    try {
      final thumbnailUpLoadTask =
          await thumbnailRef.putData(thumbnailUint8List);
      final thumbnailStorageId = thumbnailUpLoadTask.ref.name;

      // upload the original file
      final originalFileUploadTask = await originalFileRef.putFile(file);
      final originalFileStorageId = originalFileUploadTask.ref.name;

      // upload the post itself
      final postPayLoad = PostPayload(
        userId: userId,
        message: message,
        thumbnailUrl: await thumbnailRef.getDownloadURL(),
        fileUrl: await originalFileRef.getDownloadURL(),
        fileType: fileType,
        aspectRatio: thumbnailAspectRatio,
        thumbnailStorageId: thumbnailStorageId,
        originalFileStorageId: originalFileStorageId,
        postSettings: postSettings,
      );

      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.posts)
          .add(postPayLoad);

      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
