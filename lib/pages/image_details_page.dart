import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../widgets/top_bar.dart';
import '../widgets/display_image.dart';
import '../widgets/custom_alert_dialog.dart';

import '../providers/ocr_images.dart';
import '../models/string_block.dart';
import '../models/ocr_image.dart';

import '../vc_app_theme.dart';

class ImageDetailsPage extends StatefulWidget {
  static const pathName = '/image-details-page';

  ImageDetailsPage();

  @override
  _ImageDetailsPageState createState() => _ImageDetailsPageState();
}

class _ImageDetailsPageState extends State<ImageDetailsPage> {
  Rect _newRect;
  bool _isAdding = false;

  void _addNewRectToStringBoxes(BuildContext context, Rect newRect) {
    final ocrImagesProvider = Provider.of<OCRImages>(context, listen: false);

    final newBlocks = [...ocrImagesProvider.selectedImage.stringBlocks];
    print(newRect.top);
    newBlocks.add(StringBlock(
        id: Uuid().v4(), text: '', boundingBox: newRect, isUserCreated: true));

    ocrImagesProvider.updateImage(
        ocrImagesProvider.selectedImage.id,
        OCRImage(
            id: ocrImagesProvider.selectedImage.id,
            imageURL: ocrImagesProvider.selectedImage.imageURL,
            stringBlocks: newBlocks,
            createdAt: ocrImagesProvider.selectedImage.createdAt,
            editedAt: ocrImagesProvider.selectedImage.editedAt));

    setState(() {
      _isAdding = false;
      _newRect = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final animationController =
        ModalRoute.of(context).settings.arguments as AnimationController;
    final _ocrImageProvider = Provider.of<OCRImages>(context);
    final _newRectIsAdded = _newRect != null;

    return Scaffold(
      backgroundColor: VCAppTheme.background,
      body: Stack(children: [
        if (_ocrImageProvider.selectedImage != null)
          DisplayImage(
              ocrImage: _ocrImageProvider.selectedImage,
              isAdding: _isAdding,
              newRect: _newRect,
              setNewRect: (Rect rect) {
                setState(() {
                  _newRect = rect;
                });
              }),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOutSine,
              opacity: _isAdding ? 1.0 : 0.0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Text(
                    _newRectIsAdded
                        ? 'Drag or adjust the text box as needed'
                        : 'Tap to place a new text box',
                    style: VCAppTheme.title,
                  ),
                ),
              ),
            )),
        TopBar(
            topBarOpacity: 1.0,
            animationController: animationController,
            title: '',
            canGoBack: true,
            onBack: () {
              _ocrImageProvider.selectedImage.stringBlocks.removeWhere(
                  (block) => block.isUserCreated && block.editedText == null);
              _ocrImageProvider.unselectImage();
            },
            child: Row(
              children: [
                if (!_isAdding)
                  IconButton(
                    icon: Image.asset(
                      'assets/trash.png',
                      width: VCAppTheme.iconWidth,
                      height: VCAppTheme.iconHeight,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              title: 'Delete',
                              content: 'Are you sure you?',
                              actions: [
                                FlatButton(
                                  child: Text(
                                    'No',
                                    style: VCAppTheme.flatButton,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    'Yes',
                                    style: VCAppTheme.flatButton,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                )
                              ],
                            );
                          }).then((delete) {
                        if (delete) {
                          _ocrImageProvider
                              .deleteImage(_ocrImageProvider.selectedImage.id);
                          Navigator.of(context).pop();
                        }
                      }).catchError((onError) {
                        print(onError.toString());
                      });
                    },
                  ),
                if (!_isAdding || (_isAdding && _newRectIsAdded))
                  IconButton(
                      icon: Image.asset(
                        _newRectIsAdded
                            ? 'assets/check.png'
                            : 'assets/plus.png',
                        width: VCAppTheme.iconWidth,
                        height: VCAppTheme.iconHeight,
                      ),
                      onPressed: () {
                        if (_newRectIsAdded) {
                          _addNewRectToStringBoxes(context, _newRect);
                        } else {
                          setState(() {
                            _isAdding = !_isAdding;
                          });
                        }
                      }),
              ],
            )),
      ]),
    );
  }
}
