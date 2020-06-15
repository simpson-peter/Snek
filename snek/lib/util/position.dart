//represents an individual pixel position
class Position {
  double x;
  double y;

  Position({this.x, this.y});
}

class RowColPosition {
  int row;
  int col;

  RowColPosition({this.row, this.col});

  bool operator ==(rhs) {
    return (row == rhs.row && col == rhs.col);
  }
}
