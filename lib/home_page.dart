import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './pages/ocr_images_page.dart';
import './pages/image_details_page.dart';

import './components/bottom_bar_view.dart';
import './components/ml_image_picker.dart';

import './models/tab_icon_data.dart';
import './providers/page_index.dart';

import 'vc_app_theme.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  int pageIndex = 0;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: VCAppTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = OCRImagesPage(animationController: animationController);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final newIndex = Provider.of<PageIndex>(context).pageIndex;

    if (pageIndex != newIndex) {
      print(pageIndex != newIndex);
      animationController.reverse().then<dynamic>((data) {
        if (!mounted) {
          return;
        }
        setState(() {
          if (newIndex == 0) {
            tabBody = OCRImagesPage(animationController: animationController);
          } else if (newIndex == 1) {
            tabBody =
                ImageDetailsPage(animationController: animationController);
          }

          pageIndex = newIndex;
        });
      });
    }

    super.didChangeDependencies();
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

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return Wrap(children: [
            Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    color: VCAppTheme.white,
                    borderRadius: BorderRadius.only(
                        topLeft: VCAppTheme.borderRadius,
                        topRight: VCAppTheme.borderRadius)),
                child: MLImagePicker()),
          ]);
        });
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
                  tabBody,
                  BottomBarView(
                    tabIconsList: tabIconsList,
                    addClick: () {
                      _settingModalBottomSheet(context);
                    },
                    changeIndex: (int index) {
                      Provider.of<PageIndex>(context, listen: false)
                          .setPageIndex(index);
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
