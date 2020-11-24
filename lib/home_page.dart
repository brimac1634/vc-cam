import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './pages/ocr_images_page.dart';
import './pages/image_details_page.dart';

import './widgets/bottom_bar_view.dart';
import './widgets/ml_image_picker.dart';
import './widgets/custom_bottom_sheet.dart';

import './models/ocr_image.dart';
import './providers/ocr_images.dart';

import 'vc_app_theme.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  bool _isLoading = false;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  void _settingModalBottomSheet(context) async {
    try {
      List<OCRImage> imageList = await showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (BuildContext bc) {
            return CustomBottomSheet(child: MLImagePicker((bool isLoading) {
              setState(() {
                _isLoading = isLoading;
              });
            }));
          });
      setState(() {
        _isLoading = false;
      });

      if (imageList.length == 1) {
        Provider.of<OCRImages>(context, listen: false)
            .selectImage(imageList.first.id);
        Navigator.of(context).pushNamed(ImageDetailsPage.pathName,
            arguments: animationController);
      }
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: VCAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  OCRImagesPage(animationController: animationController),
                  BottomBarView(
                    addClick: () {
                      _settingModalBottomSheet(context);
                    },
                  ),
                  if (_isLoading)
                    Center(
                        child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(VCAppTheme.specialBlue),
                    ))
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
