import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import './image_details_page.dart';
import '../widgets/top_bar.dart';
import '../widgets/grid_item.dart';
import '../widgets/custom_alert_dialog.dart';

import '../providers/ocr_images.dart';

import '../vc_app_theme.dart';

class OCRImagesPage extends StatefulWidget {
  final AnimationController animationController;

  OCRImagesPage({@required this.animationController});

  @override
  _OCRImagesPageState createState() => _OCRImagesPageState();
}

class _OCRImagesPageState extends State<OCRImagesPage>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();

  double _topBarOpacity = 0.0;
  bool _isEditing = false;
  Map<String, bool> _selectedItems = {};

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    final _imagesProvider = Provider.of<OCRImages>(context);

    return Container(
      color: VCAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Stack(children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: _imagesProvider.imagesArray.length >= 1
                    ? GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1.0),
                        controller: scrollController,
                        padding: EdgeInsets.only(
                          top: AppBar().preferredSize.height +
                              MediaQuery.of(context).padding.top +
                              24,
                          bottom: 62 + MediaQuery.of(context).padding.bottom,
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
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn)));
                          widget.animationController.forward();
                          return InkWell(
                            onTap: () {
                              final _imageId =
                                  _imagesProvider.imagesArray[index].id;
                              if (_isEditing) {
                                setState(() {
                                  _selectedItems[_imageId] =
                                      _selectedItems[_imageId]
                                          ? !_selectedItems[_imageId]
                                          : true;
                                });
                              } else {
                                _imagesProvider.selectImage(_imageId);
                                Navigator.of(context).pushNamed(
                                    ImageDetailsPage.pathName,
                                    arguments: widget.animationController);
                              }
                            },
                            child: GridItem(
                              animationController: widget.animationController,
                              animation: _animation,
                              ocrImage: _imagesProvider.imagesArray[index],
                              isSelecting: _isEditing,
                              isSelected: _selectedItems[_imagesProvider
                                  .imagesArray[index].id] ??= false,
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'Press the plus button below to begin',
                          style: VCAppTheme.title,
                        ),
                      )),
            TopBar(
              topBarOpacity: _topBarOpacity,
              animationController: widget.animationController,
              title: 'Images',
              onBack: () {},
              child: Row(
                children: [
                  AnimatedOpacity(
                    opacity: _isEditing ? 1 : 0,
                    duration: const Duration(milliseconds: 600),
                    curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn),
                    child: IconButton(
                        icon: Image.asset(
                          'assets/trash.png',
                          width: VCAppTheme.iconWidth,
                          height: VCAppTheme.iconHeight,
                        ),
                        onPressed: () {
                          if (!_isEditing || _selectedItems.length <= 0) return;
                          showDialog(
                              context: context,
                              builder: (context) {
                                return CustomAlertDialog(
                                  title: 'Delete',
                                  content: 'Are you sure you?',
                                  actions: [
                                    FlatButton(
                                      child: Text(
                                        'No',
                                        style: VCAppTheme.flatButton,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text(
                                        'Yes',
                                        style: VCAppTheme.flatButton,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    )
                                  ],
                                );
                              }).then((delete) {
                            if (delete) {
                              _imagesProvider.deleteManyImages(_selectedItems
                                  .keys
                                  .where((key) => _selectedItems[key] == true)
                                  .toList());

                              setState(() {
                                _isEditing = !_isEditing;
                              });
                            }
                          }).catchError((onError) {
                            print(onError.toString());
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
                        _selectedItems = {};
                      });
                    },
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
