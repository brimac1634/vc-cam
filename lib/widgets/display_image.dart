import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

import './text_block_editor.dart';

import '../utils/rect_painter.dart';

import '../models/string_block.dart';
import '../models/ocr_image.dart';
import '../providers/ocr_images.dart';

import '../vc_app_theme.dart';

class DisplayImage extends StatefulWidget {
  final OCRImage ocrImage;

  DisplayImage({@required this.ocrImage});

  @override
  _DisplayImageState createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {
  int _selectedBlockIndex;

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
                      onTapDown: (details) {
                        RenderBox box = context.findRenderObject();
                        final offset =
                            box.globalToLocal(details.globalPosition);

                        final index = _stringBlocks.lastIndexWhere(
                            (block) => block.boundingBox.contains(offset));

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
                      },
                      onLongPressEnd: (details) {
                        final xPos = details.localPosition.dx;
                        final yPos = details.localPosition.dy;
                        final quarterOfWidth =
                            MediaQuery.of(context).size.width / 4;
                        final newBlocks = [...widget.ocrImage.stringBlocks];
                        newBlocks.add(StringBlock(
                            id: Uuid().v4(),
                            text: '',
                            boundingBox: Rect.fromLTRB(
                                (xPos - quarterOfWidth) >= 0
                                    ? xPos - quarterOfWidth
                                    : 0,
                                (yPos - 30) >= 0 ? yPos - 30 : 0,
                                xPos + quarterOfWidth,
                                yPos + 30),
                            isUserCreated: true));

                        Provider.of<OCRImages>(context, listen: false)
                            .updateImage(
                                widget.ocrImage.id,
                                OCRImage(
                                    id: widget.ocrImage.id,
                                    imageURL: widget.ocrImage.imageURL,
                                    stringBlocks: newBlocks,
                                    createdAt: widget.ocrImage.createdAt,
                                    editedAt: widget.ocrImage.editedAt));
                      },
                      child: Container(
                        width: double.infinity,
                        height: (MediaQuery.of(context).size.width *
                                (_loadedImage.height.toDouble() ?? 1)) /
                            (_loadedImage.width.toDouble() ?? 1),
                        child: CustomPaint(
                            painter: RectPainter(
                          stringBlocks: _stringBlocks,
                          selectedBlockid: _selectedBlockIndex != null
                              ? widget
                                  .ocrImage.stringBlocks[_selectedBlockIndex].id
                              : null,
                        )),
                      ),
                    )
                  ],
                );
              }),
            ),
          );
        });
  }
}
