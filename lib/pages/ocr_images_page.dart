import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './image_details_page.dart';
import '../components/top_bar.dart';
import '../components/grid_item.dart';

import '../providers/ocr_images.dart';
// import '../providers/page_index.dart';

import '../vc_app_theme.dart';

class OCRImagesPage extends StatefulWidget {
  final AnimationController animationController;

  OCRImagesPage({@required this.animationController});

  @override
  _OCRImagesPageState createState() => _OCRImagesPageState();
}

class _OCRImagesPageState extends State<OCRImagesPage>
    with TickerProviderStateMixin {
  // AnimationController animationController;
  final ScrollController scrollController = ScrollController();

  double _topBarOpacity = 0.0;
  bool _isEditing = false;

  @override
  void initState() {
    // animationController = AnimationController(
    //     duration: const Duration(milliseconds: 1000), vsync: this);

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (_topBarOpacity != 1.0) {
          setState(() {
            _topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (_topBarOpacity != scrollController.offset / 24) {
          setState(() {
            _topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (_topBarOpacity != 0.0) {
          setState(() {
            _topBarOpacity = 1.0;
          });
        }
      }
    });
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final _imagesProvider = Provider.of<OCRImages>(context);

    return Container(
      color: VCAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          FutureBuilder<bool>(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              } else {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _imagesProvider.imagesArray.length >= 1
                        ? GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: 1.0),
                            controller: scrollController,
                            padding: EdgeInsets.only(
                              top: AppBar().preferredSize.height +
                                  MediaQuery.of(context).padding.top +
                                  24,
                              bottom:
                                  62 + MediaQuery.of(context).padding.bottom,
                            ),
                            itemCount: _imagesProvider.imagesArray.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              final int count =
                                  _imagesProvider.imagesArray.length > 10
                                      ? 10
                                      : _imagesProvider.imagesArray.length;
                              final Animation<double> _animation =
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                      CurvedAnimation(
                                          parent: widget.animationController,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn)));
                              widget.animationController.forward();
                              return InkWell(
                                onTap: () {
                                  _imagesProvider.selectImage(
                                      _imagesProvider.imagesArray[index].id);
                                  Navigator.of(context).pushNamed(
                                      ImageDetailsPage.pathName,
                                      arguments: widget.animationController);
                                },
                                child: GridItem(
                                  animationController:
                                      widget.animationController,
                                  animation: _animation,
                                  ocrImage: _imagesProvider.imagesArray[index],
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              'Press the plus button below to begin',
                              style: VCAppTheme.title,
                            ),
                          ));
              }
            },
          ),
          TopBar(
            topBarOpacity: _topBarOpacity,
            animationController: widget.animationController,
            title: 'Images',
            child: Row(
              children: [
                AnimatedOpacity(
                  opacity: _isEditing ? 1 : 0,
                  duration: const Duration(milliseconds: 600),
                  curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn),
                  child: IconButton(
                      icon: Image.asset(
                        'assets/delete.png',
                        width: VCAppTheme.iconWidth,
                        height: VCAppTheme.iconHeight,
                      ),
                      onPressed: () {
                        if (!_isEditing) return;
                        setState(() {
                          _isEditing = !_isEditing;
                        });
                      }),
                ),
                IconButton(
                  icon: Image.asset(
                    _isEditing ? 'assets/edit1s.png' : 'assets/edit.png',
                    width: VCAppTheme.iconWidth,
                    height: VCAppTheme.iconHeight,
                  ),
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
