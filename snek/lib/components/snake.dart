import 'package:snek/util/position.dart';

class Snake {
  List<RowColPosition> _snakePositions;
  //snake position set for efficient membership testing
  Set<RowColPosition> _snakePositionsSet;
  int size;

  /*
  * Creates a snake with the positions listed in the initialPositions parameter
  * The snake's head will be the 0th element in initialPositions, the tail will
  * be the last element
  */
  Snake({List<RowColPosition> initialPositions}) {
    _snakePositions = initialPositions;
    _snakePositionsSet = initialPositions.toSet();
    size = initialPositions.length;
  }

  void popTail() {
    //do nothing if there is no snake
    if (size <= 0) {
      return;
      //otherwise remove the last element in snakePositions, update size
    } else {
      _snakePositionsSet.remove(getTail());
      _snakePositions.removeLast();
      size -= 1;
    }
  }

  //add a new head to the snake, update size accordingly
  void addHead(RowColPosition newHead) {
    _snakePositions.insert(0, newHead);
    _snakePositionsSet.add(newHead);
    size++;
  }

  void addTail(RowColPosition newTail) {
    _snakePositions.insert(size, newTail);
    _snakePositionsSet.add(newTail);
    size++;
  }

  void clear() {
    _snakePositions.clear();
    _snakePositionsSet.clear();
  }

  RowColPosition getHead() {
    if (size <= 0) {
      return null;
    } else {
      return _snakePositions[0];
    }
  }

  RowColPosition getTail() {
    if (size <= 0) {
      return null;
    } else {
      return _snakePositions[size - 1];
    }
  }

  //function which tests the membership of snake @ position
  bool isPositionInSnake(RowColPosition position) {
    return _snakePositionsSet.contains(position);
  }
}
