import 'package:snek/util/position.dart';

class Snake {
  List<RowColPosition> _snakePositions;
  int size;

  /*
  * Creates a snake with the positions listed in the initialPositions parameter
  * The snake's head will be the 0th element in initialPositions, the tail will
  * be the last element
  */
  Snake({List<RowColPosition> initialPositions}) {
    _snakePositions = initialPositions;
    size = initialPositions.length;
  }

  void popTail() {
    //do nothing if there is no snake
    if (size <= 0) {
      return;
      //otherwise remove the last element in snakePositions, update size
    } else {
      _snakePositions.removeLast();
      size -= 1;
    }
  }

  //add a new head to the snake, update size accordingly
  void addHead(RowColPosition newHead) {
    _snakePositions.insert(0, newHead);
    size++;
  }

  void addTail(RowColPosition newTail) {
    _snakePositions.insert(size, newTail);
    size++;
  }

  void clear() {
    _snakePositions.clear();
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
}
