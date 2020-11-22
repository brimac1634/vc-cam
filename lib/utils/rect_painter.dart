import 'package:flutter/material.dart';

import '../models/string_block.dart';

import '../vc_app_theme.dart';

class RectPainter extends CustomPainter {
  final List<Rect> rects;
  // final int selectedIndex;

  RectPainter(this.rects);

  @override
  void paint(Canvas canvas, Size size) {
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

// class BoundingBoxPainter extends CustomPainter {
//   List<StringBlock> stringBlocks;
//   var imageFile;

//   BoundingBoxPainter({@required this.stringBlocks, @required this.imageFile});

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (imageFile != null) {
//       canvas.drawImage(imageFile, Offset.zero, Paint());
//     }

//     for (StringBlock block in stringBlocks) {
//       canvas.drawRect(
//         block.boundingBox,
//         Paint()
//           ..color = Colors.teal
//           ..strokeWidth = 6.0
//           ..style = PaintingStyle.stroke,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
