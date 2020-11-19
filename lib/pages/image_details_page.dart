import 'package:flutter/material.dart';

class ImageDetailsPage extends StatelessWidget {
  static const pathName = '/image-details-page';
  final AnimationController animationController;

  ImageDetailsPage({@required this.animationController});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      'Image details here',
      style: TextStyle(color: Colors.black),
    ));
  }
}
