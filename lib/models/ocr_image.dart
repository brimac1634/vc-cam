import 'package:flutter/foundation.dart';

import './string_block.dart';

class OCRImage {
  final String id;
  final String imageURL;
  final List<StringBlock> stringBlocks;
  final DateTime createdAt;
  final DateTime editedAt;

  OCRImage(
      {@required this.id,
      @required this.imageURL,
      @required this.stringBlocks,
      @required this.createdAt,
      this.editedAt});
}
