import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/ocr_images.dart';

import 'home_page.dart';

import './pages/image_details_page.dart';

import 'vc_app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => OCRImages()),
      ],
      child: MaterialApp(
        title: 'VC Cam',
        theme: ThemeData(
          textTheme: VCAppTheme.textTheme,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
        routes: {
          ImageDetailsPage.pathName: (ctx) => ImageDetailsPage(),
        },
      ),
    );
  }
}
