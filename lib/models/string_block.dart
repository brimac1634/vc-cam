import 'dart:ui';

import 'package:flutter/foundation.dart';

class StringBlock {
  final String id;
  final String text;
  final String editedText;
  final Rect boundingBox;
  final bool isUserCreated;

  StringBlock(
      {@required this.id,
      @required this.text,
      @required this.boundingBox,
      this.editedText,
      this.isUserCreated = false});
}
