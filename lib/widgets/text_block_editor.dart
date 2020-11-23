import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './custom_bottom_sheet.dart';

import '../providers/ocr_images.dart';
import '../models/string_block.dart';
import '../models/ocr_image.dart';

import '../vc_app_theme.dart';

class TextBlockEditor extends StatefulWidget {
  final OCRImage ocrImage;
  final int selectedBlockIndex;

  TextBlockEditor({
    @required this.ocrImage,
    @required this.selectedBlockIndex,
  });

  @override
  _TextBlockEditorState createState() => _TextBlockEditorState();
}

class _TextBlockEditorState extends State<TextBlockEditor> {
  TextEditingController _editController = TextEditingController();

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final _selectedBlock =
        widget.ocrImage.stringBlocks[widget.selectedBlockIndex];
    if (_editController.text != _selectedBlock.editedText &&
        _editController.text != _selectedBlock.text) {
      final _updatedStringBlock = StringBlock(
          id: _selectedBlock.id,
          text: _selectedBlock.text,
          boundingBox: _selectedBlock.boundingBox,
          editedText: _editController.text);

      List<StringBlock> _stringBlocks = [...widget.ocrImage.stringBlocks];

      _stringBlocks[widget.selectedBlockIndex] = _updatedStringBlock;

      Provider.of<OCRImages>(context, listen: false).updateImage(
          widget.ocrImage.id,
          OCRImage(
              id: widget.ocrImage.id,
              imageURL: widget.ocrImage.imageURL,
              stringBlocks: _stringBlocks,
              createdAt: widget.ocrImage.createdAt,
              editedAt: DateTime.now()));
    }

    _editController.clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
        child: SizedBox(
      width: double.infinity,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: widget.selectedBlockIndex != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: Text(
                              'Original:',
                              style: VCAppTheme.body1,
                            ),
                          ),
                          Flexible(
                              child: Text(
                            widget.ocrImage
                                .stringBlocks[widget.selectedBlockIndex].text,
                            style: VCAppTheme.title,
                            textAlign: TextAlign.left,
                          ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
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
                                maxLines: null,
                                decoration: InputDecoration(
                                  focusColor: VCAppTheme.specialBlue,
                                  hoverColor: VCAppTheme.specialBlue,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: VCAppTheme.dark_grey),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: VCAppTheme.dark_grey),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: VCAppTheme.dark_grey),
                                  ),
                                ),
                                textInputAction: TextInputAction.done,
                                controller: _editController
                                  ..text = widget
                                          .ocrImage
                                          .stringBlocks[
                                              widget.selectedBlockIndex]
                                          .editedText ??
                                      widget
                                          .ocrImage
                                          .stringBlocks[
                                              widget.selectedBlockIndex]
                                          .text,
                                onSubmitted: (_) => _submit(context),
                              ),
                            ),
                          ]),
                    ),
                    Row(
                      children: [
                        Spacer(),
                        FlatButton(
                            onPressed: () {
                              _submit(context);
                            },
                            child: Text('Save', style: VCAppTheme.flatButton))
                      ],
                    )
                  ],
                )
              : Container(
                  color: VCAppTheme.white,
                )),
    ));
  }
}
