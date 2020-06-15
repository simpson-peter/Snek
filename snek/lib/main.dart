import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'snek_game.dart';

enum Direction { up, down, left, right }

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //initialize flame Util object
  Util flameUtil = Util();
  //make app full screen, lock vertical orientation
  flameUtil.fullScreen();
  flameUtil.setOrientation(DeviceOrientation.portraitUp);

  SnekGame snekGame = SnekGame();
  runApp(SnekGameShell(snekGame: snekGame.widget));
}

class SnekGameShell extends StatefulWidget {
  Widget snekGame;
  int score = 0;
  SnekGameShell({@required this.snekGame});
  @override
  _SnekGameShellState createState() => _SnekGameShellState();
}

class _SnekGameShellState extends State<SnekGameShell> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: widget.snekGame,
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 10,
              width: double.infinity,
            )
          ],
        )
      ],
    );
  }
}

class ScoreBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
