import 'package:flutter/material.dart';

//black material button with no splash/highlight used for settings menu navigation
class SettingsButton extends StatelessWidget {
  final Function onPressed;
  final Widget child;
  final double minWidth;

  SettingsButton({
    @required this.onPressed,
    this.child,
    this.minWidth = 0,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        highlightColor: Colors.black,
        splashColor: Colors.black,
        highlightElevation: 0,
        onPressed: onPressed,
        minWidth: minWidth,
        padding: EdgeInsets.all(0),
        child: child);
  }
}
