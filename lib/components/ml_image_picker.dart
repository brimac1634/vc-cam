import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/ocr_images.dart';

import '../vc_app_theme.dart';

class MLImagePicker extends StatefulWidget {
  @override
  _MLImagePickerState createState() => _MLImagePickerState();
}

class _MLImagePickerState extends State<MLImagePicker> {
  Future _getImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(source: imageSource);
    if (imageFile == null) return null;
    final visionImage = FirebaseVisionImage.fromFile(File(imageFile.path));
    final textRecognizer = FirebaseVision.instance.textRecognizer();
    final visionText = await textRecognizer.processImage(visionImage);

    String text = visionText.text;
    for (TextBlock block in visionText.blocks) {
      final Rect boundingBox = block.boundingBox;
      final List<Offset> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<RecognizedLanguage> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        print(line.text);
        // for (TextElement element in line.elements) {
        //   print(element);
        // }
      }
    }

    textRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    final ocrImages = Provider.of<OCRImages>(context);
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
          title: Text(
            'Camera',
            style: TextStyle(
              fontFamily: VCAppTheme.fontName,
              fontWeight: FontWeight.normal,
              fontSize: 20,
              color: VCAppTheme.darkerText,
            ),
          ),
          trailing: Image.asset(
            'assets/shoot.png',
            width: VCAppTheme.iconWidth,
            height: VCAppTheme.iconHeight,
          ),
          onTap: () async {
            final image = await _getImage(ImageSource.camera);
            // print(image);
            // ocrImages.addImage(ocrImage)
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
          title: Text(
            'Gallery',
            style: TextStyle(
              fontFamily: VCAppTheme.fontName,
              fontWeight: FontWeight.normal,
              fontSize: 20,
              color: VCAppTheme.darkerText,
            ),
          ),
          trailing: Image.asset('assets/import.png',
              width: VCAppTheme.iconWidth, height: VCAppTheme.iconHeight),
          onTap: () async {
            final image = await _getImage(ImageSource.gallery);
            // print(image);
            // ocrImages.addImage(ocrImage)
          },
        ),
      ],
    );
  }
}
