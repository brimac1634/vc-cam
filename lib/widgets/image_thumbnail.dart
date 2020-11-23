import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/rect_painter.dart';

import '../models/ocr_image.dart';

class ImageThumbnail extends StatelessWidget {
  final OCRImage ocrImage;

  ImageThumbnail(@required this.ocrImage);

  Future<ui.Image> loadImage(String asset) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  @override
  Widget build(BuildContext context) {
    final List<Rect> _rects =
        ocrImage.stringBlocks.map((block) => block.boundingBox).toList();
    final _imageFile = Image.asset(ocrImage.imageURL);

    return FutureBuilder(
      future: loadImage(ocrImage.imageURL),
      builder: (context, snapshot) {
        final ui.Image _loadedImage = snapshot.data;
        return Container(
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
              painter: RectPainter(
                  stringBlocks: ocrImage.stringBlocks, image: snapshot.data),
            ));
      },
    );
  }
}
