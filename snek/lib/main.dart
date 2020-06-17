import 'package:flutter/material.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'widgets/snake_game_shell.dart';

void main() {
  //ensure that our util demands have taken been established before the game is run
  WidgetsFlutterBinding.ensureInitialized();

  //initialize flame Util object
  Util flameUtil = Util();
  //make app full screen, lock vertical orientation
  flameUtil.fullScreen();
  flameUtil.setOrientation(DeviceOrientation.portraitUp);

  //Run the game shell
  runApp(MaterialApp(home: SnekGameShell()));
}
