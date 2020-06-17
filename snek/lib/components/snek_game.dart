import 'dart:math';
import 'dart:ui';
import 'package:flame/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'snake.dart';
import 'package:snek/util/settings.dart';
import 'board.dart';
import '../util/position.dart';
import 'package:flame/game/game.dart';
import '../constants.dart';

class SnekGame extends Game with PanDetector {
  //Snake object which store's the snake's positions on the board
  Snake snake = Snake(initialPositions: []);

  //Board object tracks individual tile states and is responsible for rendering them
  Board board = Board();

  //Flame widget which tracks the screen size
  Size screenSize;

  //Enum (see declaration in constants.dart) which tracks the snake's head travel direction
  Direction snakeDirection = Direction.down;

  //double which is updated by the update() function, and controls how often we update the game state
  double timeSinceLastUpdate = 0;

  Function onScore;
  Function onRestart;

  //value to track previous stepTime when game is paused
  double oldStepTime = kStepTime;

  //double which tracks how long to wait between game state updates
  double stepTime = kStepTime;

  //Random number generator to generate apple positions, seed with the time
  Random rand = Random(DateTime.now().millisecondsSinceEpoch);

  //bool which represents whether or not the game is in acid mode
  bool groovyMode = false;

  //constructor, accepts a Settings object to build game in line with existing user specs
  SnekGame(Settings settings) {
    setSettings(settings);
  }

  void setSettings(Settings settings) {
    setGroovyMode(settings.isInGroovyMode);
    setSpeed(settings.isTurbo);
  }

  /*
  * List which is used to initialize the snake's positions
  * Should be contiguous, with the desired head position as the last element
  */
  List<RowColPosition> initialSnakePositions = [
    RowColPosition(row: 0, col: 3),
    RowColPosition(row: 1, col: 3),
    RowColPosition(row: 2, col: 3),
    RowColPosition(row: 3, col: 3),
    RowColPosition(row: 4, col: 3),
    RowColPosition(row: 5, col: 3),
    RowColPosition(row: 6, col: 3),
    RowColPosition(row: 7, col: 3),
  ];
  RowColPosition applePosition = RowColPosition(row: 10, col: 5);

  bool firstRun = true;

  //function to pause the game by setting the step time to infinity
  void pause() {
    stepTime = double.infinity;
  }

  //Function which alters whether or not the game is in groovy mode
  void setGroovyMode(bool isGroovyModeEngaged) {
    groovyMode = isGroovyModeEngaged;
    board.setGroovyMode(isGroovyModeEngaged);
  }

  void setSpeed(bool isInTurboMode) {
    if (isInTurboMode) {
      print('Turbo Engaged');
      stepTime = kStepTime / 3;
      oldStepTime = stepTime;
    } else {
      oldStepTime = kStepTime;
      stepTime = kStepTime;
    }
  }

  //resumes regular game updates by setting the steptime back to the original value
  void resume() {
    stepTime = oldStepTime;
  }

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

    //do nothing if we have not yet received a screenSize
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

  void setOnScore(Function onScore) {
    this.onScore = onScore;
  }

  void setOnRestart(Function onRestart) {
    this.onRestart = onRestart;
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

    //check to see if the snake has hit itself (game end condition)
    if (snake.isPositionInSnake(nextHeadPos)) {
      onRestart();
    }

    //inform snake of updated head position
    snake.addHead(nextHeadPos);

    //check to see if the snake his hit the apple
    if (applePosition == snake.getHead()) {
      //if so, deallocate that square as the apple, and make it a part of the snake
      board.flipApplePresencse(snake.getHead());
      board.flipSnakePresence(snake.getHead());

      //call callback passed in as a parameter to adjust score
      onScore();

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

    //re-generate the apple if it's outside of the safe area
    if (rowCoordinate <= 3) {
      newApple();
    }
    //if the newly-generated apple conflicts with the snake, get a new position
    else if (snake.isPositionInSnake(
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
