import 'package:flutter/material.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'widgets/loss_dialog.dart';
import 'snek_game.dart';
import 'components/scoreboard.dart';

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
        ),
      ],
    );
  }
}
