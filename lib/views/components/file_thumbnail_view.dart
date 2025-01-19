import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram_clone/state/image_upload/model/image_with_aspect_ratio.dart';
import 'package:instantgram_clone/state/image_upload/model/thumbnail_request.dart';
import 'package:instantgram_clone/state/image_upload/providers/thumbnail_provider.dart';
import 'package:instantgram_clone/views/components/animations/models/loading_animation.dart';
import 'package:instantgram_clone/views/components/animations/models/small_erorr_animation.dart';

class FileThumbnailView extends ConsumerWidget {
  final ThumbnailRequest thumbnailRequest;
  const FileThumbnailView({super.key, required this.thumbnailRequest});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thumbnail = ref.watch(thumbnailProvider(thumbnailRequest));
    return thumbnail.when(
      data: (imageWithAspectRatio) {
        return AspectRatio(
          aspectRatio: imageWithAspectRatio.aspectRatio,
          child: imageWithAspectRatio.image,
        );
      },
      error: (error, stackTrace) {
        return const SmallErorrAnimation();
      },
      loading: () {
        return const LoadingAnimation();
      },
    );
  }
}
