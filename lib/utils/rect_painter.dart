import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../models/string_block.dart';

import '../vc_app_theme.dart';

class RectPainter extends CustomPainter {
  static const double strokeWidth = 4.0;
  static const PaintingStyle paintingStyle = PaintingStyle.stroke;

  final List<StringBlock> stringBlocks;
  final ui.Image image;
  final String selectedBlockid;

  RectPainter({@required this.stringBlocks, this.image, this.selectedBlockid});

  Color getColor(StringBlock block) {
    if (block.isUserCreated) return Colors.yellow;
    return block.editedText != null
        ? VCAppTheme.rectPink
        : VCAppTheme.nearlyDarkBlue;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (image != null) {
      canvas.drawImage(image, Offset.zero, Paint());
    }

    for (StringBlock block in stringBlocks) {
      if (selectedBlockid == null || selectedBlockid == block.id) {
        canvas.drawRect(
            block.boundingBox,
            Paint()
              ..color = getColor(block)
              ..strokeWidth = strokeWidth
              ..style = paintingStyle);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
