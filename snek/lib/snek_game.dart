import 'dart:ui';
import 'package:flutter/material.dart';
import 'components/snake.dart';
import 'components/board.dart';
import 'main.dart';
import 'util/tile.dart';
import 'util/position.dart';
import 'package:flame/game/game.dart';

class SnekGame extends Game {
  //booleans to track snake direction
  bool playerGoingRight = false;
  bool playerGoingDown = true;

  Size screenSize;
  Board board = Board();
  Direction snakeDirection = Direction.down;

  bool firstRun = true;

  @override
  void render(Canvas canvas) {
    if (screenSize == null) {
    } else {
      board.render(canvas, screenSize);
    }
  }

  @override
  void update(double t) {
    if (screenSize == null) {
      return;
    }
    if (firstRun) {
      firstRun = false;
      board.initialize(screenSize);
      return;
    }

    board.update(t);
  }

  @override
  void resize(Size size) {
    screenSize = size;
    board.setScreenSize(size);
  }

  void assignNextApple() {
    // TODO: implement assignNextApple()
  }
}

//Game constructor, initializes key values regarding board size
//void initializer() {
//  print('At Initializer');
//  print('Height: ');
//  print(screenSize.height);
//  print('Width: ');
//  print(screenSize.width);
//  //calculate the tile dimensions assuming 20 horizontal square tiles
//  tileLength = screenSize.width / numberOfHorizontalTiles;
//  //calculate the number of vertical tiles assuming the above tileLength
//  numberOfVerticalTiles = (screenSize.height ~/ tileLength);
//
//  //initialize the board array
//  for (int row = 0; row < numberOfVerticalTiles; row++) {
//    List<Tile> newRow = [];
//
//    for (int col = 0; col < numberOfHorizontalTiles; col++) {
//      //add a new tile to the new row
//      newRow.add(Tile(
//        //calculate upper-left corner tile position in pixels
//          position: Position(
//            x: col * tileLength,
//            y: row * tileLength,
//          )));
//
//      //initialize snake if at appropriate coordinates
//      if (col == 3 && row <= 3) {
//        newRow[col].hasSnake = true;
//      }
//    }
//    board[row] = newRow;
//  }
//}
