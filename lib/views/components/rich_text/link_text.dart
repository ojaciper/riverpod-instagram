import 'package:flutter/material.dart' show immutable, VoidCallback;
import 'package:instantgram_clone/views/components/rich_text/base_text.dart';

@immutable
class LinkText extends BaseText {
  final VoidCallback onTapped;
  const LinkText({
    required super.text,
    super.style,
    required this.onTapped,
  });
}
