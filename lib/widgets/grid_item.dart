import 'package:flutter/material.dart';

import './display_image.dart';
import './custom_radio.dart';

import '../models/ocr_image.dart';

import '../utils/rect_painter.dart';

import '../vc_app_theme.dart';

class GridItem extends StatelessWidget {
  final AnimationController animationController;
  final Animation<dynamic> animation;
  final OCRImage ocrImage;
  final bool isSelecting;
  final bool isSelected;

  GridItem(
      {@required this.ocrImage,
      this.animationController,
      this.animation,
      this.isSelecting = false,
      this.isSelected = false});

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
                child: Stack(
                  children: [
                    AnimatedOpacity(
                        opacity: isSelecting ? 0.7 : 1.0,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeOutSine,
                        child: Image.asset(
                          ocrImage.imageURL,
                          fit: BoxFit.fill,
                        )),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: AnimatedOpacity(
                        opacity: isSelecting ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeOutSine,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomRadio(
                            isSelected: isSelected,
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ),
        );
      },
    );
  }
}
