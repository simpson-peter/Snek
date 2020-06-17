import 'package:flutter/material.dart';

//represents a clickable checkbox that returns either a checked or unchecked white box
class SettingsCheckbox extends StatelessWidget {
  final bool value;
  final Function onChanged;

  SettingsCheckbox({@required this.value, @required this.onChanged});

  Widget getIcon() {
    if (value == true) {
      return Icon(
        Icons.check_box,
        color: Colors.white,
      );
    } else {
      return Icon(
        Icons.check_box_outline_blank,
        color: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged,
      child: getIcon(),
    );
  }
}
