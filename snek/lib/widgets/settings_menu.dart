import 'package:flutter/material.dart';
import 'settings_button.dart';
import 'package:snek/constants.dart';
import 'package:snek/util/settings.dart';
import 'menu_item.dart';

/*
* Builds the settings menu, which derives its initial values from oldSettings,
* and then pushes a new settings object reflecting the new settings values upon close
*/
class SettingsMenu extends StatefulWidget {
  final Settings oldSettings;

  SettingsMenu({@required this.oldSettings});

  @override
  _SettingsMenuState createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  Settings newSettings;

  @override
  Widget build(BuildContext context) {
    //transfer settings data to initialize menu
    newSettings = widget.oldSettings;
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Card(
        elevation: 0,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SettingsButton(
              onPressed: () {
                Navigator.pop(context, newSettings);
              },
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
            Text(
              'SETTINGS',
              style: kSettingsMenuTextStyle,
            ),
            MenuItem(
              label: 'GROOVY MODE',
              //update the settings object to match the checkbox state
              onChanged: () {
                setState(() {
                  newSettings.isInGroovyMode = !newSettings.isInGroovyMode;
                });
              },
              checkboxValue: newSettings.isInGroovyMode,
            ),
          ],
        ),
      ),
    );
  }
}
