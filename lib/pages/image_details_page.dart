import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/top_bar.dart';
import '../components/display_image.dart';

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
    final _selectedImage = Provider.of<OCRImages>(context).selectedImage;
    return Scaffold(
      backgroundColor: VCAppTheme.background,
      body: Stack(children: [
        Center(
            child: DisplayImage(
          ocrImage: _selectedImage,
        )
            //     Image.asset(
            //   _selectedImage.imageURL,
            //   fit: BoxFit.contain,
            //   width: double.infinity,
            //   height: double.infinity,
            // )
            ),
        TopBar(
          topBarOpacity: 1.0,
          animationController: animationController,
          title: '',
          canGoBack: true,
        ),
      ]),
    );
  }
}
