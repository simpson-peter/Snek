import 'package:flutter/material.dart';
import 'package:snek/constants.dart';

/*
* shows the score as a widget which stretches across as much of the horizontal axis
* as possible, score displayed in the center with a maximally long divider above
*/
class ScoreBoard extends StatelessWidget {
  final int score;

  ScoreBoard({@required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            color: Colors.white,
            child: SizedBox(
              height: 2,
              width: double.infinity,
            ),
          ),
          Text(
            score.toString(),
            style: kScoreTextStyle,
          ),
          SizedBox(
            height: 20,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
