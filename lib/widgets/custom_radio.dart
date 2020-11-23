import 'package:flutter/material.dart';

import '../vc_app_theme.dart';

class CustomRadio extends StatelessWidget {
  final bool isSelected;

  CustomRadio({@required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: VCAppTheme.dark_grey),
        shape: BoxShape.circle,
        color: isSelected ? VCAppTheme.specialBlue : Colors.transparent,
        gradient: LinearGradient(colors: [
          VCAppTheme.nearlyDarkBlue,
          Color(0xff6A88E5),
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
    );
  }
}
