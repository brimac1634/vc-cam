import 'package:flutter/material.dart';

import '../models/ocr_image.dart';

class OCRImages with ChangeNotifier {
  List<OCRImage> _images = [];

  List<OCRImage> get images {
    return [..._images];
  }

  OCRImage findById(String id) {
    return _images.firstWhere((image) => image.id == id);
  }

  void addImage(OCRImage ocrImage) {
    _images.add(ocrImage);
    notifyListeners();
  }

  void updateImage(String id, OCRImage ocrImage) {
    final _imageIndex = _images.indexWhere((image) => image.id == id);
    if (_imageIndex >= 0) {
      _images[_imageIndex] = ocrImage;
      notifyListeners();
    }
  }

  void deleteImage(String id) {
    final _imageIndex = _images.indexWhere((image) => image.id == id);
    if (_imageIndex >= 0) {
      _images.removeAt(_imageIndex);
      notifyListeners();
    }
  }

  // provide ordered list by date (same as _iamges), and use multiple pointer
  void deleteManyImages(List<String> ids) {}
}
