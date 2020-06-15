import 'dart:math';
import 'dart:ui';
import 'package:flame/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'components/snake.dart';
import 'components/board.dart';
import 'main.dart';
import 'util/position.dart';
import 'package:flame/game/game.dart';

class SnekGame extends Game with PanDetector {
  Snake snake = Snake(initialPositions: []);
  Board board = Board();
  Size screenSize;
  Direction snakeDirection = Direction.down;
  double timeSinceLastUpdate = 0;
  double stepTime = 0.2;

  //Random number generator to generate apple positions, seed with the time
  Random rand = Random(DateTime.now().millisecondsSinceEpoch);

  List<RowColPosition> initialSnakePositions = [
    RowColPosition(row: 0, col: 3),
    RowColPosition(row: 1, col: 3),
    RowColPosition(row: 2, col: 3)
  ];
  RowColPosition applePosition = RowColPosition(row: 10, col: 3);

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
    timeSinceLastUpdate += t;

    //do nothing if we have not yet recieved a screenSize
    if (screenSize == null) {
      return;
    }
    //initialize if we're on the first run
    if (firstRun) {
      firstRun = false;
      initialize();
      return;
    }

    if (timeSinceLastUpdate >= stepTime) {
      timeSinceLastUpdate = 0;
      moveSnake();
      board.update(t);
    }
  }

  /*
  * Method to handle drag events, which potentially entail shifting snake direction
  * Note that the snake is not allowed to exactly reverse its currently direction
  * (as that would instantly end the game)
  */

  @override
  void onPanEnd(DragEndDetails details) {
    Velocity velocity = details.velocity;
    double xVelocity = velocity.pixelsPerSecond.dx;
    double yVelocity = velocity.pixelsPerSecond.dy;
    //bool to track whether the drag was primarily horizontally oriented
    bool isHorizontal = false;

    //check raw magnitude of directional velocities to determine if this was primarily
    //a horizontal or vertical drag (defaults to vertical if they're exactly identical)
    if (xVelocity.abs() > yVelocity.abs()) {
      isHorizontal = true;
    }

    //note,

    //handle horizontal drag cases
    if (isHorizontal) {
      //a negative x velocity indicates a leftward drag
      if (xVelocity < 0) {
        if (snakeDirection != Direction.right) {
          snakeDirection = Direction.left;
        }
      }
      //a positive x velocity indicates a rightward drag
      else {
        if (snakeDirection != Direction.left) {
          snakeDirection = Direction.right;
        }
      }
    }
    //handle vertical drag cases
    else {
      //a negative y velocity indicates an upwards drag
      if (yVelocity < 0) {
        if (snakeDirection != Direction.down) {
          snakeDirection = Direction.up;
        }
      }
      //a positive y velocity indicates a downwards drag
      else {
        if (snakeDirection != Direction.up) {
          snakeDirection = Direction.down;
        }
      }
    }
  }

  void initialize() {
    //initialize the board
    board.initialize(screenSize);

    //initialize the snake
    for (RowColPosition position in initialSnakePositions) {
      snake.addHead(position);
      board.flipSnakePresence(position);
    }

    //initialize the apple
    board.flipApplePresencse(applePosition);
  }

  //adjusts the snake to reflect a one-tile shift in snakeDirection, then
  //updates board tiles accordingly
  void moveSnake() {
    RowColPosition nextHeadPos = RowColPosition();
    RowColPosition oldHeadPos = snake.getHead();

    //update head position
    //handle downward motion case
    if (snakeDirection == Direction.down) {
      nextHeadPos.row = oldHeadPos.row + 1;
      nextHeadPos.col = oldHeadPos.col;

      //account for bottom-to-top wraparound
      if (nextHeadPos.row >= board.numberOfVerticalTiles) {
        nextHeadPos.row = 0;
      }
    }
    //handle upward motion case
    else if (snakeDirection == Direction.up) {
      nextHeadPos.row = oldHeadPos.row - 1;
      nextHeadPos.col = oldHeadPos.col;

      //account for bottom-to-top wraparound
      if (nextHeadPos.row < 0) {
        nextHeadPos.row = board.numberOfVerticalTiles - 1;
      }
    }
    //handle rightward motion case
    else if (snakeDirection == Direction.right) {
      nextHeadPos.row = oldHeadPos.row;
      nextHeadPos.col = oldHeadPos.col + 1;

      //account for right-to-left wraparound
      if (nextHeadPos.col >= board.numberOfHorizontalTiles) {
        nextHeadPos.col = 0;
      }
    }
    //handle leftward motion case
    else {
      nextHeadPos.row = oldHeadPos.row;
      nextHeadPos.col = oldHeadPos.col - 1;

      //account for right-to-left wraparound
      if (nextHeadPos.col < 0) {
        nextHeadPos.col = board.numberOfHorizontalTiles - 1;
      }
    }

    //inform snake of updated head position
    snake.addHead(nextHeadPos);

    //check to see if the snake his hit the apple
    if (applePosition == snake.getHead()) {
      //if so, deallocate that square as the apple, and make it a part of the snake
      board.flipApplePresencse(snake.getHead());
      board.flipSnakePresence(snake.getHead());

      //generate a new apple position
      newApple();

      //tell the board to render the new apple
      board.flipApplePresencse(applePosition);

      //we can finish here since we're not removing the tail
      return;
    }

    //inform board that the old tail should no longer be rendered

    board.flipSnakePresence(snake.getTail());
    //tell board to render new snake head
    board.flipSnakePresence(snake.getHead());

    //update snake tail position
    snake.popTail();
  }

  //assumes there is no longer a valid apple on the board, and creates a new one
  void newApple() {
    //do not generate a new apple if the snake now takes up the entire board
    //(will result in an infinite loop otherwise)
    if (snake.size >=
        (board.numberOfHorizontalTiles * board.numberOfHorizontalTiles)) {
      applePosition = null;
      return;
    }

    int rowCoordinate = rand.nextInt(board.numberOfVerticalTiles);
    int colCoordinate = rand.nextInt(board.numberOfHorizontalTiles);

    //if the newly-generated apple conflicts with the snake, get a new position
    if (snake.isPositionInSnake(
        RowColPosition(row: rowCoordinate, col: colCoordinate))) {
      newApple();
    }
    //otherwise set the apple to that position
    else {
      applePosition = RowColPosition(row: rowCoordinate, col: colCoordinate);
    }
  }

  @override
  void resize(Size size) {
    screenSize = size;
    board.setScreenSize(size);
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
