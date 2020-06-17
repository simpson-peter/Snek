import 'package:flutter/material.dart';
import 'loss_dialog.dart';
import 'package:snek/components/snek_game.dart';
import 'package:snek/components/scoreboard.dart';
import 'package:snek/util/settings.dart';
import 'settings_menu.dart';

/*
* The top-level class of the snek game, manages game activity, settings, GUI
*/
class SnekGameShell extends StatefulWidget {
  //initialize a settings object with all fields turned off
  static Settings defaultSettings = Settings();
  Settings settings = Settings();

  int score;
  SnekGame snekGame = SnekGame(defaultSettings);

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
      widget.snekGame = SnekGame(widget.settings);
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

      /*
      * Require that the player clicks the 'x' on the menu to navigate away
      * (prevents an incomplete settings object from being returned)
       */
      barrierDismissible: false,
      builder: (_) => SettingsMenu(
        oldSettings: widget.settings,
      ),
    );

    widget.snekGame.setSettings(widget.settings);

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
