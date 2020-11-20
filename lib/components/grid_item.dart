import 'package:flutter/material.dart';
import 'package:vc_cam/models/ocr_image.dart';

import '../models/ocr_image.dart';

import '../vc_app_theme.dart';

class GridItem extends StatelessWidget {
  final AnimationController animationController;
  final Animation<dynamic> animation;
  final OCRImage ocrImage;

  GridItem({@required this.ocrImage, this.animationController, this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: VCAppTheme.white,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: VCAppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Image.network(
                  ocrImage.imageURL,
                  fit: BoxFit.cover,
                )),
          ),
        );
      },
    );
  }
}
