class Space {
  late Coordinates coordinates;
  SpaceState state;

  Space(this.coordinates, this.state);

  Space.rawCoords(int row, int col, this.state) {
    this.coordinates = new Coordinates(row, col);
  }

  @override
  bool operator ==(Object other) =>
      other is Space &&
      other.state == this.state &&
      other.coordinates == this.coordinates;

  @override
  int get hashCode => state.hashCode + coordinates.hashCode;
}

enum SpaceState {
  Empty,
  Black,
  White,
}

enum Direction {
  Up,
  Down,
  Left,
  Right,
}

class Coordinates {
  int row;
  int col;

  Coordinates(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      other is Coordinates && other.row == this.row && other.col == this.col;

  @override
  int get hashCode => row.hashCode + col.hashCode;

  Coordinates translate(Direction dir, int val) {
    switch (dir) {
      case Direction.Up:
        row -= val;
      case Direction.Down:
        row += val;
      case Direction.Left:
        col -= val;
      case Direction.Right:
        col += val;
    }

    return this;
  }
}
