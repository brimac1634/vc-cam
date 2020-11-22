import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
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
  Future<List<OCRImage>> _pickAndAnalyzeImages() async {
    try {
      // final picker = ImagePicker();
      // final imageFile = await picker.getImage(source: imageSource);

      // final assetList = await MultiImagePicker.pickImages(
      //   maxImages: 1,
      //   // enableCamera: true,
      // );

      List<Asset> assetList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        materialOptions: MaterialOptions(
          actionBarColor: "#FF000000",
          statusBarColor: "#FF000000",
        ),
      );

      if (assetList == null || assetList.length <= 0) {
        return null;
      }

      final textRecognizer = FirebaseVision.instance.textRecognizer();

      List<OCRImage> ocrImages = [];
      for (Asset asset in assetList) {
        final filePath =
            await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
        final visionImage = FirebaseVisionImage.fromFile(File(filePath));
        final visionText = await textRecognizer.processImage(visionImage);

        List<StringBlock> stringBlocks = [];
        for (TextBlock block in visionText.blocks) {
          final Rect boundingBox = block.boundingBox;
          // final List<Offset> cornerPoints = block.cornerPoints;
          final String text = block.text;
          // final List<RecognizedLanguage> languages = block.recognizedLanguages;

          stringBlocks.add(StringBlock(
              id: Uuid().v4(), text: text, boundingBox: boundingBox));
          // for (TextLine line in block.lines) {
          //   print(line.text);
          //   // for (TextElement element in line.elements) {
          //   //   print(element);
          //   // }
          // }
        }

        ocrImages.add(OCRImage(
            id: Uuid().v4(),
            imageURL: filePath,
            stringBlocks: stringBlocks,
            createdAt: DateTime.now()));
      }

      textRecognizer.close();

      return ocrImages;
    } on Exception catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ocrImagesProvider = Provider.of<OCRImages>(context);
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
              final ocrImages = await _pickAndAnalyzeImages();
              ocrImagesProvider.addImages(ocrImages);
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
              final ocrImages = await _pickAndAnalyzeImages();
              ocrImagesProvider.addImages(ocrImages);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
