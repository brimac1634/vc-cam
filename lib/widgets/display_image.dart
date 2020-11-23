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

  void _submitData() {
    print('hey');
    final _updatedStringBlock = StringBlock(
        id: widget.ocrImage.stringBlocks[_selectedBlockIndex].id,
        text: widget.ocrImage.stringBlocks[_selectedBlockIndex].text,
        boundingBox:
            widget.ocrImage.stringBlocks[_selectedBlockIndex].boundingBox,
        editedText: _editController.text);

    List<StringBlock> _stringBlocks = [...widget.ocrImage.stringBlocks];

    _stringBlocks[_selectedBlockIndex] = _updatedStringBlock;

    Provider.of<OCRImages>(context).updateImage(
        widget.ocrImage.id,
        OCRImage(
            id: widget.ocrImage.id,
            imageURL: widget.ocrImage.imageURL,
            stringBlocks: _stringBlocks,
            createdAt: widget.ocrImage.createdAt,
            editedAt: DateTime.now()));
  }

  void _settingModalBottomSheet(context) {
    print(widget.ocrImage.stringBlocks[_selectedBlockIndex].editedText);
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return CustomBottomSheet(
              child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Text(
                            'Original:',
                            style: VCAppTheme.body1,
                          ),
                        ),
                        Text(
                          widget
                              .ocrImage.stringBlocks[_selectedBlockIndex].text,
                          style: VCAppTheme.title,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 22),
                        child: Text(
                          'Edited:',
                          style: VCAppTheme.body1,
                        ),
                      ),
                      Flexible(
                        child: TextField(
                          cursorColor: VCAppTheme.specialBlue,
                          style: VCAppTheme.title,
                          decoration: InputDecoration(
                            focusColor: VCAppTheme.specialBlue,
                            hoverColor: VCAppTheme.specialBlue,
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: VCAppTheme.dark_grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: VCAppTheme.specialBlue),
                            ),
                            border: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: VCAppTheme.dark_grey),
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          controller: _editController = TextEditingController()
                            ..text = widget.ocrImage
                                .stringBlocks[_selectedBlockIndex].editedText,
                          onSubmitted: (_) => _submitData(),
                        ),
                      ),
                    ]),
                  ),
                  Row(
                    children: [
                      Spacer(),
                      FlatButton(
                          onPressed: _submitData,
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: VCAppTheme.specialBlue,
                              fontFamily: VCAppTheme.fontName,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 0.18,
                            ),
                          ))
                    ],
                  )
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
