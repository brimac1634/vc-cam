import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:provider/provider.dart';

import '../providers/ocr_images.dart';
import '../models/ocr_image.dart';
import '../models/string_block.dart';

import '../vc_app_theme.dart';

class MLImagePicker extends StatefulWidget {
  final Function(bool) setIsLoading;

  MLImagePicker(this.setIsLoading);

  @override
  _MLImagePickerState createState() => _MLImagePickerState();
}

class _MLImagePickerState extends State<MLImagePicker> {
  Future<List<OCRImage>> _pickAndAnalyzeImages({bool isCamera}) async {
    try {
      final textRecognizer = FirebaseVision.instance.textRecognizer();

      List<OCRImage> ocrImages = [];

      if (isCamera) {
        final picker = ImagePicker();
        final imageFile = await picker.getImage(source: ImageSource.camera);
        if (imageFile != null) {
          widget.setIsLoading(true);
          final ocrImage = await analyzeImage(imageFile.path, textRecognizer);
          if (ocrImage != null) {
            ocrImages.add(ocrImage);
          }
        }
      } else {
        List<Asset> assetList = await MultiImagePicker.pickImages(
          maxImages: 10,
          enableCamera: true,
          materialOptions: MaterialOptions(
            actionBarColor: "#FF000000",
            statusBarColor: "#FF000000",
          ),
        );

        if (assetList != null && assetList.length >= 1) {
          widget.setIsLoading(true);
          for (Asset asset in assetList) {
            final filePath =
                await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
            final ocrImage = await analyzeImage(filePath, textRecognizer);
            if (ocrImage != null) {
              ocrImages.add(ocrImage);
            }
          }
        }
      }

      textRecognizer.close();

      return ocrImages;
    } on Exception catch (error) {
      print(error);
    }
  }

  Future<OCRImage> analyzeImage(
      String filePath, TextRecognizer textRecognizer) async {
    if (filePath == null || textRecognizer == null) return null;
    final visionImage = FirebaseVisionImage.fromFile(File(filePath));
    final visionText = await textRecognizer.processImage(visionImage);

    List<StringBlock> stringBlocks = [];
    for (TextBlock block in visionText.blocks) {
      final Rect boundingBox = block.boundingBox;
      // final List<Offset> cornerPoints = block.cornerPoints;
      final String text = block.text;
      // final List<RecognizedLanguage> languages = block.recognizedLanguages;

      stringBlocks.add(
          StringBlock(id: Uuid().v4(), text: text, boundingBox: boundingBox));
      // for (TextLine line in block.lines) {
      //   print(line.text);
      //   // for (TextElement element in line.elements) {
      //   //   print(element);
      //   // }
      // }
    }

    return OCRImage(
        id: Uuid().v4(),
        imageURL: filePath,
        stringBlocks: stringBlocks,
        createdAt: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final ocrImagesProvider = Provider.of<OCRImages>(context);
    return Column(children: [
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
          final ocrImages = await _pickAndAnalyzeImages(isCamera: true);
          if (ocrImages != null && ocrImages.length >= 1) {
            ocrImagesProvider.addImages(ocrImages);
          }
          Navigator.pop(context, ocrImages);
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
        trailing: Image.asset('assets/gallery.png',
            width: VCAppTheme.iconWidth, height: VCAppTheme.iconHeight),
        onTap: () async {
          final ocrImages = await _pickAndAnalyzeImages(isCamera: false);
          if (ocrImages != null && ocrImages.length >= 1) {
            ocrImagesProvider.addImages(ocrImages);
          }
          Navigator.pop(context, ocrImages);
        },
      ),
    ]);
  }
}
