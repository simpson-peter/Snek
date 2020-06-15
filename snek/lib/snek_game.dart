import 'dart:ui';
import 'package:flutter/material.dart';
import 'components/snake.dart';
import 'main.dart';
import 'util/tile.dart';
import 'util/position.dart';
import 'package:flame/game/game.dart';

class SnekGame extends Game {
  //booleans to track snake direction
  bool playerGoingRight = false;
  bool playerGoingDown = true;

  Size screenSize;

  //records the length (in pixels) of the tiles which make up the game board
  double tileLength = 0;

  //records the numbers of tiles in the board's vertical and horizontal dimensions
  int numberOfHorizontalTiles = 20;
  int numberOfVerticalTiles = 0;

  //2D array to track the board state
  List<List<Tile>> board = [];
  Snake snake = Snake(initialPositions: []);

  Direction snakeDirection = Direction.down;

  bool firstRun = true;

  @override
  void render(Canvas canvas) {
    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint bgPaint = Paint();
    bgPaint.color = Colors.pink;
    canvas.drawRect(bgRect, bgPaint);

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
          tilePaint.color = Colors.black;
        }

        canvas.drawRect(tileRect, tilePaint);
      }
    }
  }

  @override
  void update(double t) {
    if (screenSize == null) {
      return;
    }
    if (firstRun) {
      firstRun = false;
      print('At Update');
      print('Height: ');
      print(screenSize.height);
      print('Width: ');
      print(screenSize.width);
      //calculate the tile dimensions assuming 20 horizontal square tiles
      tileLength = screenSize.width / numberOfHorizontalTiles;
      print('Tile Length: ' + tileLength.toString());
      //calculate the number of vertical tiles assuming the above tileLength
      numberOfVerticalTiles = (screenSize.height ~/ tileLength);
      print('Vert Tile #s: ' + numberOfVerticalTiles.toString());

      //initialize the board array
      for (int row = 0; row < numberOfVerticalTiles; row++) {
        List<Tile> newRow = [];

        for (int col = 0; col < numberOfHorizontalTiles; col++) {
          //add a new tile to the new row
          newRow.add(
            Tile(
                //calculate upper-left corner tile position in pixels
                hasSnake: (col == 3 && row <= 3),
                isApple: (col == 10 && row == 10),
                position: Position(
                  x: col * tileLength,
                  y: row * tileLength,
                ),
                tileRowColPosition: RowColPosition(
                  row: row,
                  col: col,
                )),
          );
          if (col == 3 && row <= 3) {
            snake.addTail(RowColPosition(row: row, col: col));
          }
        }
        board.add(newRow);
      }
    }

    RowColPosition nextTile = RowColPosition();
    Tile oldHead = board[snake.getHead().row][snake.getHead().col];

    if (snakeDirection == Direction.down) {
      nextTile.row = snake.getHead().row + 1;
      nextTile.col = snake.getHead().col;

      if (nextTile.row >= numberOfVerticalTiles) {
        nextTile.row = 0;
      }
    }
    snake.addHead(nextTile);

    board[snake.getTail().row][snake.getTail().col].hasSnake = false;
    board[nextTile.row][nextTile.col].hasSnake = true;

    snake.popTail();
  }

  @override
  void resize(Size size) {
    screenSize = size;
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
