import 'package:flutter/material.dart';

import '../models/string_block.dart';

import '../models/ocr_image.dart';

class OCRImages with ChangeNotifier {
  Map<String, OCRImage> _images = {
    '123': OCRImage(
        id: '123',
        imageURL:
            'https://otakimail.co.nz/wp-content/uploads/2014/06/JN14_Vet_Obese-cat.jpg',
        stringBlocks: [StringBlock(id: '1234', text: 'hello there')],
        createdAt: DateTime.now()),
    '124': OCRImage(
        id: '123',
        imageURL:
            'https://otakimail.co.nz/wp-content/uploads/2014/06/JN14_Vet_Obese-cat.jpg',
        stringBlocks: [StringBlock(id: '1234', text: 'hello there')],
        createdAt: DateTime.now()),
    '125': OCRImage(
        id: '123',
        imageURL:
            'https://otakimail.co.nz/wp-content/uploads/2014/06/JN14_Vet_Obese-cat.jpg',
        stringBlocks: [StringBlock(id: '1234', text: 'hello there')],
        createdAt: DateTime.now()),
    '126': OCRImage(
        id: '123',
        imageURL:
            'https://otakimail.co.nz/wp-content/uploads/2014/06/JN14_Vet_Obese-cat.jpg',
        stringBlocks: [StringBlock(id: '1234', text: 'hello there')],
        createdAt: DateTime.now()),
    '127': OCRImage(
        id: '123',
        imageURL:
            'https://otakimail.co.nz/wp-content/uploads/2014/06/JN14_Vet_Obese-cat.jpg',
        stringBlocks: [StringBlock(id: '1234', text: 'hello there')],
        createdAt: DateTime.now()),
    '128': OCRImage(
        id: '123',
        imageURL:
            'https://otakimail.co.nz/wp-content/uploads/2014/06/JN14_Vet_Obese-cat.jpg',
        stringBlocks: [StringBlock(id: '1234', text: 'hello there')],
        createdAt: DateTime.now()),
  };

  OCRImage _selectedImage;

  OCRImage get selectedImage {
    return _selectedImage;
  }

  List<OCRImage> get imagesArray {
    return {..._images}.values.toList();
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

  void addImage(OCRImage ocrImage) {
    _images[ocrImage.id] = ocrImage;
    notifyListeners();
  }

  void updateImage(String id, OCRImage ocrImage) {
    if (_images.containsKey(id)) {
      _images[id] = ocrImage;
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
}
