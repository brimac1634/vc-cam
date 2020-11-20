import 'package:flutter/material.dart';

import '../components/top_bar.dart';

import '../vc_app_theme.dart';

class OCRImagesPage extends StatefulWidget {
  final AnimationController animationController;

  OCRImagesPage({this.animationController});

  @override
  _OCRImagesPageState createState() => _OCRImagesPageState();
}

class _OCRImagesPageState extends State<OCRImagesPage> {
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  bool isEditing = false;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 1.0;
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
                return ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.only(
                    top: AppBar().preferredSize.height +
                        MediaQuery.of(context).padding.top +
                        24,
                    bottom: 62 + MediaQuery.of(context).padding.bottom,
                  ),
                  itemCount: 50,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    widget.animationController.forward();
                    return Text('Hey there');
                  },
                );
              }
            },
          ),
          TopBar(
            topBarOpacity: topBarOpacity,
            animationController: widget.animationController,
            title: 'Images',
            child: Row(
              children: [
                AnimatedOpacity(
                  opacity: isEditing ? 1 : 0,
                  duration: const Duration(milliseconds: 600),
                  curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn),
                  child: IconButton(
                      icon: Image.asset(
                        'assets/delete.png',
                        width: VCAppTheme.iconWidth,
                        height: VCAppTheme.iconHeight,
                      ),
                      onPressed: () {
                        if (!isEditing) return;
                        setState(() {
                          isEditing = !isEditing;
                        });
                      }),
                ),
                IconButton(
                  icon: Image.asset(
                    isEditing ? 'assets/edit1s.png' : 'assets/edit.png',
                    width: VCAppTheme.iconWidth,
                    height: VCAppTheme.iconHeight,
                  ),
                  onPressed: () {
                    setState(() {
                      isEditing = !isEditing;
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
