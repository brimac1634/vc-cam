import 'package:flutter/material.dart';

import '../vc_app_theme.dart';

class CustomBottomSheet extends StatelessWidget {
  final Widget child;
  CustomBottomSheet({@required this.child});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Wrap(children: [
        Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                color: VCAppTheme.white,
                borderRadius: BorderRadius.only(
                    topLeft: VCAppTheme.borderRadius,
                    topRight: VCAppTheme.borderRadius)),
            child: SafeArea(child: child))
      ]),
    );
  }
}
