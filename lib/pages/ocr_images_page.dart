import 'package:flutter/material.dart';

class OCRImagesPage extends StatelessWidget {
  final AnimationController animationController;

  OCRImagesPage({@required this.animationController});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text('image grid here', style: TextStyle(color: Colors.black)));
  }
}
