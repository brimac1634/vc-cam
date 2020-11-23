import 'package:flutter/material.dart';

import '../vc_app_theme.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  CustomAlertDialog(
      {@required this.title, @required this.content, @required this.actions});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      child: Center(
        child: Container(
          width: 290,
          height: 210,
          padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 24),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: VCAppTheme.white,
            borderRadius: BorderRadius.all(Radius.circular(24.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(children: [
                Text(
                  title,
                  style: VCAppTheme.headline,
                  textAlign: TextAlign.left,
                ),
                Spacer()
              ]),
              Container(child: Text(content, style: VCAppTheme.title)),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: actions,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
