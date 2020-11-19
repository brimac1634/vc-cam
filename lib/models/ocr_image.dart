import 'package:flutter/foundation.dart';

import './string_block.dart';

class OCRImage {
  final String id;
  final String imageURL;
  final List<StringBlock> stringBlocks;
  final DateTime dateTime;

  OCRImage(
      {@required this.id,
      @required this.imageURL,
      @required this.stringBlocks,
      @required this.dateTime});
}
