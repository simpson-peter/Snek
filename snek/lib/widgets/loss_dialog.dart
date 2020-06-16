import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants.dart';

/*
* Widget which presents an expanded alert on game loss, and allows for taps anywhere
* on the screen to dismiss the dialog
*/
class LossDialog extends StatelessWidget {
  //this widget receives score as a final, and thus is re-built on every loss
  final int score;
  LossDialog({this.score = -1});

  @override
  Widget build(BuildContext context) {
    /*
    * The AlertDialog already allows for dialog dismissal due to taps outside the dialog,
    * but here it is surrounded by a GestureDector so dismissal can occur through tapping on
    * the dialog as well
    */
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Column(
        children: <Widget>[
          AlertDialog(
            elevation: 0,
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
                  'FINAL SCORE: ' + score.toString(),
                  style: kLossMenuTextStyle.copyWith(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'RESTART?',
                  style: kLossMenuTextStyle.copyWith(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
