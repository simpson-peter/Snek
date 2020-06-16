import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'snek_game.dart';
import 'components/scoreboard.dart';

enum Direction { up, down, left, right }

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //initialize flame Util object
  Util flameUtil = Util();
  //make app full screen, lock vertical orientation
  flameUtil.fullScreen();
  flameUtil.setOrientation(DeviceOrientation.portraitUp);

  //SnekGame snekGame = SnekGame();
  runApp(SnekGameShell());
}

class SnekGameShell extends StatefulWidget {
  SnekGame snekGame = SnekGame(
    onScore: () {},
  );
  int score = 0;
  SnekGameShell();
  @override
  _SnekGameShellState createState() => _SnekGameShellState();
}

class _SnekGameShellState extends State<SnekGameShell> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Column(
        children: <Widget>[
          Expanded(
            child: widget.snekGame.widget,
          ),
          ScoreBoard(
            score: widget.score,
          ),
        ],
      ),
    );
  }
}
