import 'dart:ui';

import 'package:flutter/material.dart';

import '../utils/rect_painter.dart';

import '../models/string_block.dart';

import '../models/ocr_image.dart';

class DisplayImage extends StatefulWidget {
  final OCRImage ocrImage;

  DisplayImage({@required this.ocrImage});

  @override
  _DisplayImageState createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {
  StringBlock _selectedBlock;

  @override
  Widget build(BuildContext context) {
    final List<Rect> rects =
        widget.ocrImage.stringBlocks.map((block) => block.boundingBox).toList();
    return GestureDetector(
        onTapDown: (details) {
          RenderBox box = context.findRenderObject();
          final offset = box.globalToLocal(details.globalPosition);
          final index = rects.lastIndexWhere((rect) => rect.contains(offset));
          if (index != -1) {
            print('direct hit');
            setState(() {
              _selectedBlock = widget.ocrImage.stringBlocks[index];
            });
          } else {
            setState(() {
              _selectedBlock = null;
            });
          }
        },
        child: Stack(
          children: [
            Image.asset(
              widget.ocrImage.imageURL,
              fit: BoxFit.contain,
            ),
            CustomPaint(
              painter: RectPainter(rects),
            )
          ],
        ));
  }
}
