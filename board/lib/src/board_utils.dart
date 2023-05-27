class Space {
  late Coordinates _coordinates;
  SpaceState state;

  Space(this._coordinates, this.state);

  Space.rawCoords(int row, int col, this.state) {
    _coordinates = Coordinates(row, col);
  }

  Coordinates get coordinates {
    return Coordinates.copy(_coordinates);
  }

  @override
  bool operator ==(Object other) =>
      other is Space &&
      other.state == state &&
      other.coordinates == coordinates;

  @override
  int get hashCode => state.hashCode + coordinates.hashCode;
}

enum SpaceState {
  empty,
  black,
  white,
}

enum Direction {
  up,
  down,
  left,
  right,
}

class Coordinates {
  late int row;
  late int col;

  Coordinates(this.row, this.col);

  Coordinates.copy(Coordinates other) {
    row = other.row;
    col = other.col;
  }

  @override
  bool operator ==(Object other) =>
      other is Coordinates && other.row == row && other.col == col;

  @override
  int get hashCode => row.hashCode + col.hashCode;

  Coordinates translate(Direction dir, int val) {
    Coordinates dest = Coordinates.copy(this);

    switch (dir) {
      case Direction.up:
        dest.row -= val;
      case Direction.down:
        dest.row += val;
      case Direction.left:
        dest.col -= val;
      case Direction.right:
        dest.col += val;
    }

    return dest;
  }
}
