import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './text_block_editor.dart';

import '../utils/rect_painter.dart';

import '../models/string_block.dart';
import '../models/ocr_image.dart';

import '../vc_app_theme.dart';

class DisplayImage extends StatefulWidget {
  final OCRImage ocrImage;
  final bool isAdding;
  final Rect newRect;
  final Function(Rect) setNewRect;

  DisplayImage(
      {@required this.ocrImage,
      @required this.isAdding,
      this.newRect,
      this.setNewRect});

  @override
  _DisplayImageState createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {
  int _selectedBlockIndex;
  bool _dragging = false;

  bool _insideRect(double x, double y) {
    return x >= widget.newRect.left &&
        x <= widget.newRect.right &&
        y >= widget.newRect.top &&
        y <= widget.newRect.bottom;
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return TextBlockEditor(
            ocrImage: widget.ocrImage,
            selectedBlockIndex: _selectedBlockIndex,
          );
        }).then((_) {
      setState(() {
        _selectedBlockIndex = null;
      });
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  void _editBlockOnTap(BuildContext context, TapUpDetails details,
      List<StringBlock> stringBlocks) {
    RenderBox box = context.findRenderObject();
    final offset = box.globalToLocal(details.globalPosition);

    final index = stringBlocks
        .lastIndexWhere((block) => block.boundingBox.contains(offset));

    if (index != -1) {
      setState(() {
        _selectedBlockIndex = index;
      });
      _settingModalBottomSheet(context);
    } else {
      setState(() {
        _selectedBlockIndex = null;
      });
    }
  }

  void _addNewBlockOnTap(TapUpDetails details) {
    final xPos = details.localPosition.dx;
    final yPos = details.localPosition.dy;
    final quarterOfWidth = MediaQuery.of(context).size.width / 4;

    widget.setNewRect(Rect.fromLTRB(
        (xPos - quarterOfWidth) >= 0 ? xPos - quarterOfWidth : 0,
        (yPos - 30) >= 0 ? yPos - 30 : 0,
        xPos + quarterOfWidth,
        yPos + 30));
  }

  Future<ui.Image> loadImage(String asset) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadImage(widget.ocrImage.imageURL),
        builder: (context, snapshot) {
          final ui.Image _loadedImage = snapshot.data;

          if (_loadedImage == null)
            return Container(
              color: VCAppTheme.white,
            );

          final changeInSize = (MediaQuery.of(context).size.width /
              (_loadedImage.width.toDouble() ?? 1));

          final List<StringBlock> _stringBlocks =
              widget.ocrImage.stringBlocks.map((block) {
            return StringBlock(
                id: block.id,
                text: block.text,
                boundingBox: Rect.fromLTRB(
                    block.boundingBox.left * changeInSize,
                    block.boundingBox.top * changeInSize,
                    block.boundingBox.right * changeInSize,
                    block.boundingBox.bottom * changeInSize),
                editedText: block.editedText,
                isUserCreated: block.isUserCreated);
          }).toList();

          return Center(
            child: Container(
              child: LayoutBuilder(builder: (context, constraints) {
                return Stack(
                  children: [
                    Image.asset(
                      widget.ocrImage.imageURL,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTapUp: (details) {
                        if (widget.isAdding) {
                          _addNewBlockOnTap(details);
                        } else {
                          _editBlockOnTap(context, details, _stringBlocks);
                        }
                      },
                      onPanStart: (details) => _dragging = _insideRect(
                        details.localPosition.dx,
                        details.localPosition.dy,
                      ),
                      onPanEnd: (details) {
                        _dragging = false;
                      },
                      onPanUpdate: (details) {
                        if (_dragging) {
                          widget.setNewRect(Rect.fromLTRB(
                              widget.newRect.left + details.delta.dx,
                              widget.newRect.top + details.delta.dy,
                              widget.newRect.right + details.delta.dx,
                              widget.newRect.bottom + details.delta.dy));
                        }
                      },
                      child: Container(
                          width: double.infinity,
                          height: (MediaQuery.of(context).size.width *
                                  (_loadedImage.height.toDouble() ?? 1)) /
                              (_loadedImage.width.toDouble() ?? 1),
                          child: widget.isAdding
                              ? CustomPaint(
                                  painter: RectPainter(
                                      stringBlocks: [],
                                      newRect: widget.newRect),
                                )
                              : CustomPaint(
                                  painter: RectPainter(
                                  stringBlocks: _stringBlocks,
                                  selectedBlockid: _selectedBlockIndex != null
                                      ? widget.ocrImage
                                          .stringBlocks[_selectedBlockIndex].id
                                      : null,
                                ))),
                    )
                  ],
                );
              }),
            ),
          );
        });
  }
}
