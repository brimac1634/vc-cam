import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../models/string_block.dart';

import '../vc_app_theme.dart';

class RectPainter extends CustomPainter {
  final List<Rect> rects;
  final ui.Image image;
  // final int selectedIndex;

  RectPainter({@required this.rects, this.image});

  @override
  void paint(Canvas canvas, Size size) {
    if (image != null) {
      canvas.drawImage(image, Offset.zero, Paint());
    }

    for (Rect rect in rects) {
      canvas.drawRect(
          rect,
          Paint()
            ..color = VCAppTheme.rectPink
            ..strokeWidth = 3.0
            ..style = PaintingStyle.stroke);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
