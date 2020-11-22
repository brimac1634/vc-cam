import 'dart:io';

// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/ocr_images.dart';
import '../models/ocr_image.dart';
import '../models/string_block.dart';

import '../vc_app_theme.dart';

class MLImagePicker extends StatefulWidget {
  @override
  _MLImagePickerState createState() => _MLImagePickerState();
}

class _MLImagePickerState extends State<MLImagePicker> {
  Future<OCRImage> _getImage() async {
    try {
      // final picker = ImagePicker();
      // final imageFile = await picker.getImage(source: imageSource);
      final imageList = await MultiImagePicker.pickImages(
        maxImages: 2,
        enableCamera: true,
      );
      print(imageList);
      // if (imageFile == null) return null;
      // final visionImage = FirebaseVisionImage.fromFile(File(imageFile.path));
      // final textRecognizer = FirebaseVision.instance.textRecognizer();
      // final visionText = await textRecognizer.processImage(visionImage);

      // List<StringBlock> stringBlocks = [];
      // for (TextBlock block in visionText.blocks) {
      //   final Rect boundingBox = block.boundingBox;
      //   // final List<Offset> cornerPoints = block.cornerPoints;
      //   final String text = block.text;
      //   final List<RecognizedLanguage> languages = block.recognizedLanguages;

      //   stringBlocks.add(
      //       StringBlock(id: Uuid().v4(), text: text, boundingBox: boundingBox));
      //   // for (TextLine line in block.lines) {
      //   //   print(line.text);
      //   //   // for (TextElement element in line.elements) {
      //   //   //   print(element);
      //   //   // }
      //   // }
      // }

      // textRecognizer.close();

      // return OCRImage(
      //     id: Uuid().v4(),
      //     imageURL: imageFile.path,
      //     stringBlocks: stringBlocks,
      //     createdAt: DateTime.now());
    } on Exception catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ocrImages = Provider.of<OCRImages>(context);
    return SafeArea(
      child: Column(
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
              final ocrImage = await _getImage();
              ocrImages.addImage(ocrImage);
              Navigator.pop(context);
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
              final ocrImage = await _getImage();
              ocrImages.addImage(ocrImage);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
