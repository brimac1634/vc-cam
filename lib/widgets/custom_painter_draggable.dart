import 'package:flutter/material.dart';
import 'package:vc_cam/utils/rect_painter.dart';

class CustomPainterDraggable extends StatefulWidget {
  RectPainter painter;

  CustomPainterDraggable({@required this.painter});

  @override
  _CustomPainterDraggableState createState() => _CustomPainterDraggableState();
}

class _CustomPainterDraggableState extends State<CustomPainterDraggable> {
  var xPos = 0.0;

  var yPos = 0.0;

  final width = 100.0;

  final height = 100.0;

  bool _dragging = false;

  /// Is the point (x, y) inside the rect?
  bool _insideRect(double x, double y) =>
      x >= xPos && x <= xPos + width && y >= yPos && y <= yPos + height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) => _dragging = _insideRect(
        details.globalPosition.dx,
        details.globalPosition.dy,
      ),
      onPanEnd: (details) {
        _dragging = false;
      },
      onPanUpdate: (details) {
        if (_dragging) {
          setState(() {
            xPos += details.delta.dx;
            yPos += details.delta.dy;
          });
        }
      },
      child: CustomPaint(
        painter: widget.painter,
      ),
    );
  }
}
