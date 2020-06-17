import 'package:flutter/material.dart';
import 'package:snek/constants.dart';
import 'settings_checkbox.dart';

/*
* Represents a toggle-able state in the settings menu,
* Builds a row with a text widget and an Icon which varies based on checkboxValue
* Function onChanged controls behavior on clicking box
*/
class MenuItem extends StatelessWidget {
  final String label;
  final Function onChanged;
  final bool checkboxValue;

  MenuItem({
    @required this.label,
    @required this.onChanged,
    @required this.checkboxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: kSettingsMenuTextStyle,
        ),
        SettingsCheckbox(
          value: checkboxValue,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
