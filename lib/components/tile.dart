import '../util/position.dart';

//represents the tiles, comprised of many pixels in a square, which comprise the game board
class Tile {
  //records the pixel coordinates of the upper-left corner of the tile in the larger screen
  Position position;

  //records the relative position of the tile in the board array
  RowColPosition tileRowColPosition;

  bool hasSnake;
  bool isApple;

  Tile({this.position, this.hasSnake, this.isApple, this.tileRowColPosition});
}
