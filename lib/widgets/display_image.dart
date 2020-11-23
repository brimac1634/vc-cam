import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './custom_bottom_sheet.dart';

import '../utils/rect_painter.dart';

import '../models/string_block.dart';
import '../models/ocr_image.dart';
import '../providers/ocr_images.dart';

import '../vc_app_theme.dart';

class DisplayImage extends StatefulWidget {
  final OCRImage ocrImage;
  final bool disableDefault;

  DisplayImage({@required this.ocrImage, this.disableDefault = false});

  @override
  _DisplayImageState createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {
  TextEditingController _editController;
  int _selectedBlockIndex;

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return CustomBottomSheet(
              child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    widget.ocrImage.stringBlocks[_selectedBlockIndex].text,
                    style: VCAppTheme.title,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Text Edit'),
                    controller: _editController = TextEditingController()
                      ..text = widget.ocrImage.stringBlocks[_selectedBlockIndex]
                          .editedText,
                    onSubmitted: (_) {
                      final _updatedStringBlock = StringBlock(
                          id: widget
                              .ocrImage.stringBlocks[_selectedBlockIndex].id,
                          text: widget
                              .ocrImage.stringBlocks[_selectedBlockIndex].text,
                          boundingBox: widget.ocrImage
                              .stringBlocks[_selectedBlockIndex].boundingBox,
                          editedText: _editController.text);

                      List<StringBlock> _stringBlocks = [
                        ...widget.ocrImage.stringBlocks
                      ];

                      _stringBlocks[_selectedBlockIndex] = _updatedStringBlock;

                      Provider.of<OCRImages>(context).updateImage(
                          widget.ocrImage.id,
                          OCRImage(
                              id: widget.ocrImage.id,
                              imageURL: widget.ocrImage.imageURL,
                              stringBlocks: _stringBlocks,
                              createdAt: widget.ocrImage.createdAt,
                              editedAt: DateTime.now()));
                    },
                  ),
                ],
              ),
            ),
          ));
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
    final List<Rect> _rects =
        widget.ocrImage.stringBlocks.map((block) => block.boundingBox).toList();
    final _imageFile = Image.asset(widget.ocrImage.imageURL);
    return FutureBuilder(
      future: loadImage(widget.ocrImage.imageURL),
      builder: (context, snapshot) {
        final ui.Image _loadedImage = snapshot.data;
        return IgnorePointer(
          ignoring: widget.disableDefault,
          child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapDown: (details) {
                RenderBox box = context.findRenderObject();
                final offset = box.globalToLocal(details.globalPosition);
                final index =
                    _rects.lastIndexWhere((rect) => rect.contains(offset));
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
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: CustomPaint(
                  painter: RectPainter(rects: _rects, image: snapshot.data),
                ),
              )),
        );
      },
    );
  }
}
