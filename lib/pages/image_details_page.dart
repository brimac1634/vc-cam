import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/top_bar.dart';
import '../widgets/display_image.dart';
import '../widgets/custom_alert_dialog.dart';

import '../providers/ocr_images.dart';

import '../vc_app_theme.dart';

class ImageDetailsPage extends StatefulWidget {
  static const pathName = '/image-details-page';

  ImageDetailsPage();

  @override
  _ImageDetailsPageState createState() => _ImageDetailsPageState();
}

class _ImageDetailsPageState extends State<ImageDetailsPage> {
  bool _isAdding = false;
  bool _newRectIsAdded = false;

  @override
  Widget build(BuildContext context) {
    final animationController =
        ModalRoute.of(context).settings.arguments as AnimationController;
    final _ocrImageProvider = Provider.of<OCRImages>(context);
    return Scaffold(
      backgroundColor: VCAppTheme.background,
      body: Stack(children: [
        if (_ocrImageProvider.selectedImage != null)
          DisplayImage(
            ocrImage: _ocrImageProvider.selectedImage,
            isAdding: _isAdding,
            setNewRectIsAdded: (bool rectIsAdded) {
              setState(() {
                _newRectIsAdded = rectIsAdded;
              });
            },
          ),
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
                    'Tap to place a new text box',
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
                IconButton(
                    icon: Image.asset(
                      'assets/plus.png',
                      width: VCAppTheme.iconWidth,
                      height: VCAppTheme.iconHeight,
                    ),
                    onPressed: () {
                      setState(() {
                        _isAdding = !_isAdding;
                      });
                    })
              ],
            )),
      ]),
    );
  }
}
