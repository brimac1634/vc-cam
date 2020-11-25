import 'package:flutter/material.dart';

import '../models/string_block.dart';

import '../models/ocr_image.dart';

import '../utils/db_helper.dart';

class OCRImages with ChangeNotifier {
  Map<String, OCRImage> _images = {};

  OCRImage _selectedImage;

  OCRImage get selectedImage {
    return _selectedImage;
  }

  List<OCRImage> get imagesArray {
    final list = {..._images}.values.toList();

    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Map<String, OCRImage> get imagesMap {
    return {..._images};
  }

  OCRImage findById(String id) {
    if (_images.containsKey(id)) {
      return _images[id];
    } else {
      return null;
    }
  }

  void selectImage(String id) {
    _selectedImage = _images[id];
    notifyListeners();
  }

  void unselectImage() {
    _selectedImage = null;
    notifyListeners();
  }

  void addImages(List<OCRImage> ocrImages) {
    ocrImages.forEach((ocrImage) {
      _images[ocrImage.id] = ocrImage;
    });
    notifyListeners();

    insertOCRImages(ocrImages);
  }

  void updateImage(String id, OCRImage ocrImage) {
    if (_images.containsKey(id)) {
      _images[id] = ocrImage;
      _selectedImage = ocrImage;
      notifyListeners();
    }
  }

  void deleteImage(String id) {
    if (_images.containsKey(id)) {
      _images.remove(id);
      notifyListeners();
    }
  }

  void deleteManyImages(List<String> ids) {
    if (ids.length >= 1) {
      ids.forEach((id) {
        _images.remove(id);
      });
    }
  }

  void insertOCRImages(List<OCRImage> ocrImages) {
    ocrImages.forEach((ocrImage) {
      DBHelper.insert(DBHelper.ocrImages, {
        'id': ocrImage.id,
        'image_url': ocrImage.imageURL,
        'created_at': ocrImage.createdAt,
        'edited_at': ocrImage.editedAt
      });

      ocrImage.stringBlocks.forEach((block) {
        DBHelper.insert(DBHelper.stringBlocks, {
          'id': block.id,
          'ocr_image': ocrImage.id,
          'text': block.text,
          'edited_text': block.editedText,
          'left': block.boundingBox.left,
          'top': block.boundingBox.top,
          'right': block.boundingBox.right,
          'bottom': block.boundingBox.bottom,
          'is_user_created': block.isUserCreated
        });
      });
    });
  }

  Future<void> fetchAndSetOcrImages() async {
    final dataList = await DBHelper.getData(DBHelper.ocrImages);
    print(dataList);
    notifyListeners();
  }
}
