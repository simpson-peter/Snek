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
    return Card(
      shape: Border.all(
        width: 2,
        color: Colors.white,
      ),
      elevation: 0,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SettingsButton(
              onPressed: () {
                Navigator.pop(context, newSettings);
              },
              child: Icon(
                Icons.close,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'SETTINGS',
                  style: kSettingsMenuTextStyle,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    MenuItem(
                      label: 'GROOVY MODE',
                      //update the settings object to match the checkbox state
                      onChanged: () {
                        setState(() {
                          newSettings.isInGroovyMode =
                              !newSettings.isInGroovyMode;
                        });
                      },
                      checkboxValue: newSettings.isInGroovyMode,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      'warning: flashing colors',
                      style: kSettingsMenuTextStyle.copyWith(
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MenuItem(
                      label: 'TURBO MODE',
                      onChanged: () {
                        setState(() {
                          newSettings.isTurbo = !newSettings.isTurbo;
                        });
                      },
                      checkboxValue: newSettings.isTurbo,
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
