import 'package:flutter/material.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:snek/constants.dart';
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
    await showDialog(
      context: context,
      builder: (_) => LossDialog(
        score: score,
      ),
    );
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

class LossDialog extends StatelessWidget {
  final int score;

  LossDialog({this.score = -1});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          'R.I.P.',
          textAlign: TextAlign.center,
        ),
        titleTextStyle: kLossMenuTextStyle,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Final Score: ' + score.toString(),
              style: kLossMenuTextStyle.copyWith(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Restart?',
              style: kLossMenuTextStyle.copyWith(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
