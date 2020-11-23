import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/top_bar.dart';
import '../widgets/display_image.dart';

import '../providers/ocr_images.dart';

import '../vc_app_theme.dart';

class ImageDetailsPage extends StatefulWidget {
  static const pathName = '/image-details-page';

  ImageDetailsPage();

  @override
  _ImageDetailsPageState createState() => _ImageDetailsPageState();
}

class _ImageDetailsPageState extends State<ImageDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final animationController =
        ModalRoute.of(context).settings.arguments as AnimationController;
    final _ocrImageProvider = Provider.of<OCRImages>(context);
    return Scaffold(
      backgroundColor: VCAppTheme.background,
      body: Stack(children: [
        DisplayImage(
          ocrImage: _ocrImageProvider.selectedImage,
        ),
        TopBar(
          topBarOpacity: 1.0,
          animationController: animationController,
          title: '',
          canGoBack: true,
          child: IconButton(
            icon: Image.asset(
              'assets/trash.png',
              width: VCAppTheme.iconWidth,
              height: VCAppTheme.iconHeight,
            ),
            onPressed: () {
              // TODO PRESENT MODAL ASKING IF SURE
              _ocrImageProvider.deleteImage(_ocrImageProvider.selectedImage.id);
              Navigator.of(context).pop();
            },
          ),
        ),
      ]),
    );
  }
}
