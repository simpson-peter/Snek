import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:snek/constants.dart';
import 'package:snek/main.dart';
import 'package:snek/util/tile.dart';
import 'package:snek/util/position.dart';

class Board {
  //2D array to track the board state
  List<List<Tile>> board = [];

  int numberOfHorizontalTiles = kNumberOfHorizontalTiles;
  int numberOfVerticalTiles = 0;
  Direction snakeDirection = Direction.down;
  Size screenSize;
  double tileLength;
  bool acidMode = false;

  List<Color> acidColors;
  Set<Color> acidColorPalette = {
    Color(0xFFeeaf61),
    Color(0xFFfb9062),
    Color(0xFFee5d6c),
    Color(0xFFce4993),
    Color(0xFF6a0d83),
  };

  void setScreenSize(Size screenSize) {
    this.screenSize = screenSize;
  }

  void engageAcidMode() {
    acidMode = true;
    //populate acid colors
    Iterator<Color> paletteIt = acidColorPalette.iterator;
    for (int i = 0; i < numberOfVerticalTiles; i++) {}
  }

  void disengageAcidMode() {
    acidMode = false;
  }

  void render(Canvas canvas, Size screenSize) {
    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint bgPaint = Paint();
    bgPaint.color = Colors.black;
    canvas.drawRect(bgRect, bgPaint);
    double canvasDifferential = 0;

    //iterate through the game board and render each tile as a square,
    //color dependant on position contents.
    for (int row = 0; row < numberOfVerticalTiles; row++) {
      for (int col = 0; col < numberOfHorizontalTiles; col++) {
        Tile currentTile = board[row][col];

        //create the rectangle to represent the tile
        Rect tileRect = Rect.fromLTWH(
          currentTile.position.x,
          currentTile.position.y,
          tileLength,
          tileLength,
        );

        Paint tilePaint = Paint();
        if (currentTile.isApple) {
          tilePaint.color = Colors.green;
        } else if (currentTile.hasSnake) {
          tilePaint.color = Colors.white;
        } else {
          tilePaint.color = getTileColor(RowColPosition(row: row, col: col));
        }

        canvas.drawRect(tileRect, tilePaint);
      }
      if (row == numberOfVerticalTiles - 1) {
        canvasDifferential =
            screenSize.height - (tileLength * numberOfVerticalTiles);
      }
    }

    if (canvasDifferential != 0) {
      Rect bottomBorder = Rect.fromLTWH(
          0,
          screenSize.height - canvasDifferential,
          screenSize.width,
          canvasDifferential);

      Paint bottomBorderPaint = Paint();
      bottomBorderPaint.color = Colors.white;
      canvas.drawRect(bottomBorder, bottomBorderPaint);
    }
  }

  /*
  * Informs the board to invert the snake presencse variable for position
  * So, if the tile.hasSnake = true, then tile.hasSnake will = false afterwards, or vice versa
  */
  void flipSnakePresence(RowColPosition position) {
    //check if the requested position is out of bounds
    if (isPositionOutOfBounds(position)) {
      throw 'Exception: flipSnakePresencse called on out-of-bounds position';
    }

    board[position.row][position.col].hasSnake =
        !(board[position.row][position.col].hasSnake);
  }

  /*
  * Informs the board to invert the aple presencse variable for position
  * So, if the tile.isApple = true, then tile.isApple will = false afterwards, or vice versa
  */
  void flipApplePresencse(RowColPosition position) {
    //check if the requested position is out of bounds
    if (isPositionOutOfBounds(position)) {
      throw 'Exception: flipSnakePresencse called on out-of-bounds position';
    }

    board[position.row][position.col].isApple =
        !(board[position.row][position.col].isApple);
  }

  //Helper function the check whether a tile position is within the bounds of board
  bool isPositionOutOfBounds(RowColPosition position) {
    if (position == null) {
      return true;
    }

    return (position.row >= numberOfVerticalTiles ||
        position.row < 0 ||
        position.col < 0 ||
        position.col >= numberOfHorizontalTiles);
  }

  void update(double t) {}

  void initialize(Size screenSize) {
    this.screenSize = screenSize;
    //calculate the tile dimensions assuming 20 horizontal square tiles
    tileLength = screenSize.width / numberOfHorizontalTiles;
    //calculate the number of vertical tiles assuming the above tileLength
    numberOfVerticalTiles = (screenSize.height ~/ tileLength);

    //initialize the board array
    for (int row = 0; row < numberOfVerticalTiles; row++) {
      List<Tile> newRow = [];

      for (int col = 0; col < numberOfHorizontalTiles; col++) {
        //add a new tile to the new row
        newRow.add(
          Tile(
            //calculate upper-left corner tile position in pixels
            hasSnake: false,
            isApple: false,
            position: Position(
              x: col * tileLength,
              y: row * tileLength,
            ),
            tileRowColPosition: RowColPosition(
              row: row,
              col: col,
            ),
          ),
        );
      }
      board.add(newRow);
    }
  }

  Color getTileColor(RowColPosition position) {
    //if we're not in acid mode, the background is just black
    if (!acidMode) {
      return Colors.black;
    }
  }
}
