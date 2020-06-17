import 'package:flutter/material.dart';
import 'package:Snek/constants.dart';
import 'package:Snek/widgets/settings_button.dart';

/*
* shows the score as a widget which stretches across as much of the horizontal axis
* as possible, score displayed in the center with a maximally long divider above
*/
class ScoreBoard extends StatelessWidget {
  final int score;
  final Function onSettingsPressed;

  ScoreBoard({
    @required this.score,
    @required this.onSettingsPressed,
  });

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SettingsButton(
                onPressed: onSettingsPressed,
                minWidth: 60,
                child: Icon(
                  Icons.settings,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              Text(
                score.toString(),
                style: kScoreTextStyle,
              ),

              //Here we have a second invisible Icon to center the score
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.settings,
                  size: 40,
                  color: Colors.black,
                ),
              ),
            ],
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
