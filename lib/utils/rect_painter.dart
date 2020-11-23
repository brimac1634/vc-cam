import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../models/string_block.dart';

import '../vc_app_theme.dart';

class RectPainter extends CustomPainter {
  final List<StringBlock> stringBlocks;
  final ui.Image image;
  final String selectedBlockid;

  RectPainter({@required this.stringBlocks, this.image, this.selectedBlockid});

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
              ..color = block.editedText != null
                  ? VCAppTheme.rectPink
                  : VCAppTheme.nearlyDarkBlue
              ..strokeWidth = 4.0
              ..style = PaintingStyle.stroke);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
