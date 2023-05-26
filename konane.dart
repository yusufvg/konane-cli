// papamū

// TODO(yvangieson): do doc comments
// TODO(yvangieson): unit testing
// TODO(yvangieson): update file structure; split for organization
// TODO(yvangieson): maybe? create a coords class

class BoardModel {
  late List<List<SpaceState>> spaces;
  late Map<SpaceState, List<Space>> pieces;

  BoardModel([int size = 8]) {
    spaces = [];
    pieces = {SpaceState.Black: [], SpaceState.White: []};
    SpaceState nextState = SpaceState.Black;

    for (int i = 0; i < size; i++) {
      spaces.add([]);
      for (int j = 0; j < size; j++) {
        spaces[i].add(nextState);
        pieces[nextState]!.add(new Space(i, j, nextState));
        nextState =
            nextState == SpaceState.Black ? SpaceState.White : SpaceState.Black;
      }
    }
  }

  SpaceState getSpaceState(int r, int c) {
    if (!isValidCoordinate(r, c))
      throw ArgumentError('invalid coordinates: $r, $c');

    return spaces[r][c];
  }

  void setSpaceState(int r, int c, SpaceState state) {
    if (!isValidCoordinate(r, c))
      throw ArgumentError('invalid coordinates: $r, $c');

    SpaceState currentState = spaces[r][c];
    if (state == currentState) return;

    // removing a piece
    if ({SpaceState.Black, SpaceState.White}.contains(currentState)) {
      pieces[currentState] = pieces[currentState]!
          .where((space) => space.row != r || space.col != c)
          .toList();
    }

    // placing a piece
    if ({SpaceState.Black, SpaceState.White}.contains(state)) {
      pieces[state]!.add(new Space(r, c, state));
    }

    spaces[r][c] = state;
  }

  /** Checks whether the given player has any valid moves remaining */
  bool hasValidMoves(SpaceState player) {
    if (!{SpaceState.Black, SpaceState.White}.contains(player))
      throw ArgumentError('invalid player value: $player');

    SpaceState other =
        player == SpaceState.Black ? SpaceState.White : SpaceState.Black;

    return pieces[player]!.any((space) {
      int r = space.row, c = space.col;
      bool result = false;
      [
        [-1, 0],
        [1, 0],
        [0, -1],
        [0, 1]
      ].forEach((dir) {
        if (!result &&
            isValidCoordinate(r + 2 * dir[0], c + 2 * dir[1]) &&
            spaces[r + dir[0]][c + dir[1]] == other &&
            spaces[r + 2 * dir[0]][c + 2 * dir[1]] == SpaceState.Empty)
          result = true;
      });

      return result;
    });
  }

  bool isValidCoordinate(int r, int c) {
    return (r >= 0 && r < spaces.length) && (c >= 0 && c < spaces.length);
  }
}

class BoardController {
  BoardModel _boardModel;
  SpaceState _currentPlayer = SpaceState.Black;

  BoardController(this._boardModel) {}

  bool makeMove(int r0, int c0, int r1, int c1) {
    // invalid coordinates
    if (_boardModel.isValidCoordinate(r0, c0) &&
        _boardModel.isValidCoordinate(r1, c1)) {
      return false;
    }

    // illegal diagonal move
    if (r0 != r1 && c0 != c1) return false;

    // determine intermidiate spaces
    List<Space> intermidiate_spaces = [];
    if (r0 == r1) {
      if ((c1 - c0).abs() % 2 != 0) return false;

      int start, end;
      if (c1 > c0) {
        start = c0;
        end = c1;
      } else {
        start = c1;
        end = c0;
      }
      for (int i = start + 1; i < end; i += 2) {
        intermidiate_spaces.add(Space(r0, i, _boardModel.getSpaceState(r0, i)));
      }
    } else {
      if ((r1 - r0).abs() % 2 != 0) return false;

      int start, end;
      if (r1 > r0) {
        start = r0;
        end = r1;
      } else {
        start = r1;
        end = r0;
      }
      for (int i = start + 1; i < end; i += 2) {
        intermidiate_spaces.add(Space(i, c0, _boardModel.getSpaceState(i, c0)));
      }
    }

    // pieces in illegal state
    if (_boardModel.getSpaceState(r1, c1) != SpaceState.Empty ||
        _boardModel.getSpaceState(r0, c0) != _currentPlayer) return false;
    for (Space space in intermidiate_spaces) {
      if (space.state == SpaceState.Empty) return false;
    }

    // make the move
    _boardModel.setSpaceState(r0, c0, SpaceState.Empty);
    _boardModel.setSpaceState(r1, c1, _currentPlayer);
    for (Space space in intermidiate_spaces) {
      _boardModel.setSpaceState(space.row, space.col, SpaceState.Empty);
    }

    return true;
  }

  /** Checks whether or not the currently active player has any valid moves remaining */
  bool hasValidMoves() {
    return _boardModel.hasValidMoves(_currentPlayer);
  }
}

class BoardView {
  late BoardModel _boardModel;
  late BoardController _boardController;

  BoardView(this._boardModel) {
    _boardModel = new BoardModel();
    _boardController = new BoardController(_boardModel);
  }

  String printBoard() {
    StringBuffer buf = new StringBuffer();

    for (List<SpaceState> row in _boardModel.spaces) {
      for (SpaceState space in row) {
        switch (space) {
          case SpaceState.Black:
            buf.write('X ');
          case SpaceState.White:
            buf.write('O ');
          default:
            buf.write('  ');
        }
        buf.write('\n');
      }
    }

    return buf.toString();
  }
}

class Space {
  final int row;
  final int col;
  SpaceState state;

  Space(this.row, this.col, this.state);
}

enum SpaceState {
  Empty,
  Black,
  White,
}
