import 'dart:math';
import 'dart:ui';
import 'package:flame/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'snake.dart';
import 'package:Snek/util/settings.dart';
import 'board.dart';
import '../util/position.dart';
import 'package:flame/game/game.dart';
import '../constants.dart';

class SnekGame extends Game with PanDetector {
  //Snake object which store's the snake's positions on the board
  Snake _snake = Snake(initialPositions: []);

  //Board object tracks individual tile states and is responsible for rendering them
  Board _board = Board();

  //Flame widget which tracks the screen size
  Size screenSize;

  //Enum (see declaration in constants.dart) which tracks the snake's head travel direction
  Direction _snakeDirection = Direction.down;

  //double which is updated by the update() function, and controls how often we update the game state
  double _timeSinceLastUpdate = 0;

  //Callback functions which can notify external widgets when a score or restart event is triggered
  Function onScore;
  Function onRestart;

  //value to track previous stepTime when game is paused
  double _oldStepTime = kStepTime;

  //double which tracks how long to wait between game state updates
  double _stepTime = kStepTime;

  //Random number generator to generate apple positions, seed with the time
  Random _rand = Random(DateTime.now().millisecondsSinceEpoch);

  //bool which represents whether or not the game is in acid mode
  bool _groovyMode = false;

  /*
  * List which is used to initialize the snake's positions
  * Should be contiguous, with the desired head position as the last element
  */
  List<RowColPosition> _initialSnakePositions = [
    RowColPosition(row: 0, col: 3),
    RowColPosition(row: 1, col: 3),
    RowColPosition(row: 2, col: 3),

    //uncomment for a longer initial snake--useful for testing purposes
    /*
    RowColPosition(row: 3, col: 3),
    RowColPosition(row: 4, col: 3),
    RowColPosition(row: 5, col: 3),
    RowColPosition(row: 6, col: 3),
    RowColPosition(row: 7, col: 3),
     */
  ];

  RowColPosition _applePosition = RowColPosition(row: 10, col: 5);

  bool firstRun = true;

  //constructor, accepts a Settings object to build game in line with existing user specs
  SnekGame(Settings settings) {
    setSettings(settings);
  }

  void setSettings(Settings settings) {
    setGroovyMode(settings.isInGroovyMode);
    setSpeed(settings.isTurbo);
  }

  //function to pause the game by setting the step time to infinity
  void pause() {
    _stepTime = double.infinity;
  }

  //Function which alters whether or not the game is in groovy mode
  void setGroovyMode(bool isGroovyModeEngaged) {
    _groovyMode = isGroovyModeEngaged;
    _board.setGroovyMode(isGroovyModeEngaged);
  }

  void setSpeed(bool isInTurboMode) {
    if (isInTurboMode) {
      print('Turbo Engaged');
      _stepTime = kStepTime / 3;
      _oldStepTime = _stepTime;
    } else {
      _oldStepTime = kStepTime;
      _stepTime = kStepTime;
    }
  }

  //resumes regular game updates by setting the steptime back to the original value
  void resume() {
    _stepTime = _oldStepTime;
  }

  @override
  void render(Canvas canvas) {
    if (screenSize == null) {
    } else {
      _board.render(canvas, screenSize);
    }
  }

  @override
  void update(double t) {
    _timeSinceLastUpdate += t;

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

    if (_timeSinceLastUpdate >= _stepTime) {
      _timeSinceLastUpdate = 0;
      _moveSnake();
      _board.update(t);
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
        if (_snakeDirection != Direction.right) {
          _snakeDirection = Direction.left;
        }
      }
      //a positive x velocity indicates a rightward drag
      else {
        if (_snakeDirection != Direction.left) {
          _snakeDirection = Direction.right;
        }
      }
    }
    //handle vertical drag cases
    else {
      //a negative y velocity indicates an upwards drag
      if (yVelocity < 0) {
        if (_snakeDirection != Direction.down) {
          _snakeDirection = Direction.up;
        }
      }
      //a positive y velocity indicates a downwards drag
      else {
        if (_snakeDirection != Direction.up) {
          _snakeDirection = Direction.down;
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
    _board.initialize(screenSize);

    //initialize the snake
    for (RowColPosition position in _initialSnakePositions) {
      _snake.addHead(position);
      _board.flipSnakePresence(position);
    }

    //initialize the apple
    _board.flipApplePresencse(_applePosition);
  }

  //adjusts the snake to reflect a one-tile shift in snakeDirection, then
  //updates board tiles accordingly
  void _moveSnake() {
    RowColPosition nextHeadPos = RowColPosition();
    RowColPosition oldHeadPos = _snake.getHead();

    //update head position
    //handle downward motion case
    if (_snakeDirection == Direction.down) {
      nextHeadPos.row = oldHeadPos.row + 1;
      nextHeadPos.col = oldHeadPos.col;

      //account for bottom-to-top wraparound
      if (nextHeadPos.row >= _board.numberOfVerticalTiles) {
        nextHeadPos.row = 0;
      }
    }
    //handle upward motion case
    else if (_snakeDirection == Direction.up) {
      nextHeadPos.row = oldHeadPos.row - 1;
      nextHeadPos.col = oldHeadPos.col;

      //account for bottom-to-top wraparound
      if (nextHeadPos.row < 0) {
        nextHeadPos.row = _board.numberOfVerticalTiles - 1;
      }
    }
    //handle rightward motion case
    else if (_snakeDirection == Direction.right) {
      nextHeadPos.row = oldHeadPos.row;
      nextHeadPos.col = oldHeadPos.col + 1;

      //account for right-to-left wraparound
      if (nextHeadPos.col >= _board.numberOfHorizontalTiles) {
        nextHeadPos.col = 0;
      }
    }
    //handle leftward motion case
    else {
      nextHeadPos.row = oldHeadPos.row;
      nextHeadPos.col = oldHeadPos.col - 1;

      //account for right-to-left wraparound
      if (nextHeadPos.col < 0) {
        nextHeadPos.col = _board.numberOfHorizontalTiles - 1;
      }
    }

    //check to see if the snake has hit itself (game end condition)
    if (_snake.isPositionInSnake(nextHeadPos)) {
      onRestart();
    }

    //inform snake of updated head position
    _snake.addHead(nextHeadPos);

    //check to see if the snake his hit the apple
    if (_applePosition == _snake.getHead()) {
      //if so, deallocate that square as the apple, and make it a part of the snake
      _board.flipApplePresencse(_snake.getHead());
      _board.flipSnakePresence(_snake.getHead());

      //call callback passed in as a parameter to adjust score
      onScore();

      //generate a new apple position
      _newApple();

      //tell the board to render the new apple
      _board.flipApplePresencse(_applePosition);

      //we can finish here since we're not removing the tail
      return;
    }

    //inform board that the old tail should no longer be rendered

    _board.flipSnakePresence(_snake.getTail());
    //tell board to render new snake head
    _board.flipSnakePresence(_snake.getHead());

    //update snake tail position
    _snake.popTail();
  }

  //assumes there is no longer a valid apple on the board, and creates a new one
  void _newApple() {
    //do not generate a new apple if the snake now takes up the entire board
    //(will result in an infinite loop otherwise)
    if (_snake.size >=
        (_board.numberOfHorizontalTiles * _board.numberOfHorizontalTiles)) {
      _applePosition = null;
      return;
    }

    int rowCoordinate = _rand.nextInt(_board.numberOfVerticalTiles);
    int colCoordinate = _rand.nextInt(_board.numberOfHorizontalTiles);

    //re-generate the apple if it's outside of the safe area
    if (rowCoordinate <= 3) {
      _newApple();
    }
    //if the newly-generated apple conflicts with the snake, get a new position
    else if (_snake.isPositionInSnake(
        RowColPosition(row: rowCoordinate, col: colCoordinate))) {
      _newApple();
    }
    //otherwise set the apple to that position
    else {
      _applePosition = RowColPosition(row: rowCoordinate, col: colCoordinate);
    }
  }

  //Function called by Flame to set canvas size
  @override
  void resize(Size size) {
    screenSize = size;
    _board.setScreenSize(size);
  }
}
