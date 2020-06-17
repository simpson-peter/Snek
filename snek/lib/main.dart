import 'package:flutter/material.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:snek/constants.dart';
import 'widgets/loss_dialog.dart';
import 'snek_game.dart';
import 'components/scoreboard.dart';
import 'util/settings.dart';
import 'widgets/settings_button.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //initialize flame Util object
  Util flameUtil = Util();
  //make app full screen, lock vertical orientation
  flameUtil.fullScreen();
  flameUtil.setOrientation(DeviceOrientation.portraitUp);

  //SnekGame snekGame = SnekGame();
  runApp(MaterialApp(home: SnekGameShell()));
}

class SnekGameShell extends StatefulWidget {
  int score;
  SnekGame snekGame = SnekGame();

  //initialize a settings object with all fields turned off
  Settings settings = Settings();

  @override
  _SnekGameShellState createState() => _SnekGameShellState();
}

class _SnekGameShellState extends State<SnekGameShell> {
  _SnekGameShellState() {
    score = 0;
  }

  int score;

  void incrementScore() {
    setState(() {
      score++;
    });
  }

  //Function which handles the game once an end-condition has been reached (user lost)
  void restart() async {
    //pause the game so that multiple dialogs are not generated
    widget.snekGame.pause();

    //show the dialog, wait for the user to tap out of it
    await showDialog(
      context: context,
      builder: (_) => LossDialog(
        score: score,
      ),
    );

    //once the use has left the loss dialog, start a new game from a fresh game object
    setState(() {
      score = 0;
      widget.snekGame = SnekGame();
    });
  }

  //Function which handles the behavior of the rest of the app while the user is in the settings menu
  void onSettingsPressed() async {
    //pause the game while the user is in settings
    widget.snekGame.pause();

    /*
    * Display the settings menu,
    * then receive the updated settings object from the settings menu
    */
    widget.settings = await showDialog(
      context: context,
      builder: (_) => SettingsMenu(
        settings: widget.settings,
      ),
    );

    print('Settings returned, is groovy mode engaged? ' +
        widget.settings.isInGroovyMode.toString());

    widget.snekGame.resume();
  }

  @override
  Widget build(BuildContext context) {
    widget.snekGame.setOnScore(incrementScore);
    widget.snekGame.setOnRestart(restart);
    return Column(
      children: <Widget>[
        Expanded(
          child: widget.snekGame.widget,
        ),
        ScoreBoard(
          score: score,
          onSettingsPressed: onSettingsPressed,
        ),
      ],
    );
  }
}

class SettingsMenu extends StatefulWidget {
  Settings settings;

  SettingsMenu({@required this.settings});

  @override
  _SettingsMenuState createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SettingsButton(
              onPressed: () {
                Navigator.pop(context, widget.settings);
              },
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
            Text(
              'Settings',
              style: kSettingsMenuTextStyle,
            ),
            /*MenuItem(
              label: 'Strange Mode',
              onChanged: (bool checked) {},
            ),*/
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String label;
  final Function onChanged;

  MenuItem({@required this.label, @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: kSettingsMenuTextStyle,
        ),
        Checkbox(
          onChanged: onChanged,
        ),
      ],
    );
  }
}
