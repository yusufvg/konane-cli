import 'src/board_utils.dart';

class BoardModel {
  late Map<Coordinates, SpaceState> spaces;
  late Map<SpaceState, List<Space>> pieces;

  late int _size;

  /// Initializes the model with a default board size of 8.
  ///
  /// The optional parameter [size] can be used to increase the size of the board.
  /// Throws an [ArgumentError] if the size is set to smaller than 8.
  BoardModel([int size = 8]) {
    if (size < 8) {
      throw ArgumentError('board size cannot be smaller than 8: $size');
    }

    _size = size;

    spaces = {};
    pieces = {SpaceState.black: [], SpaceState.white: []};

    for (int r = 0; r < size; r++) {
      SpaceState nextState = r % 2 == 0 ? SpaceState.black : SpaceState.white;
      for (int c = 0; c < size; c++) {
        Coordinates coords = Coordinates(r, c);
        spaces[coords] = nextState;
        pieces[nextState]!.add(Space(coords, nextState));
        nextState =
            nextState == SpaceState.black ? SpaceState.white : SpaceState.black;
      }
    }
  }

  int get size => _size;

  /// Retrieves the [SpaceState] at the given [Coordinates].
  ///
  /// Throws an [ArgumentError] if [coords] are invalid or missing in the board.
  SpaceState getSpaceState(Coordinates coords) {
    if (!isValidCoordinate(coords)) {
      throw ArgumentError('invalid coordinates: ${coords.row}, ${coords.col}');
    }

    return spaces.containsKey(coords)
        ? spaces[coords]!
        : throw ArgumentError(
            'coordinates not found in board: ${coords.row}, ${coords.col}');
  }

  /// Sets the [SpaceState] at the given [Coordinates].
  ///
  /// Throws an [ArgumentError] if coords are invalid or missing in the board.
  void setSpaceState(Coordinates coords, SpaceState state) {
    if (!isValidCoordinate(coords)) {
      throw ArgumentError('invalid coordinates: ${coords.row}, ${coords.col}');
    }

    SpaceState currentState = getSpaceState(coords);
    if (state == currentState) return;

    // removing a piece
    if ({SpaceState.black, SpaceState.white}.contains(currentState)) {
      pieces[currentState] = pieces[currentState]!
          .where((space) => space.coordinates != coords)
          .toList();
    }

    // placing a piece
    if ({SpaceState.black, SpaceState.white}.contains(state)) {
      pieces[state]!.add(Space(coords, state));
    }

    spaces[coords] = state;
  }

  /// Checks whether the given player has any valid moves remaining.
  ///
  /// Throws an [ArgumentError] if the [SpaceState] provided is empty.
  bool hasValidMoves(SpaceState player) {
    if (player == SpaceState.empty) {
      throw ArgumentError('invalid player value: $player');
    }

    SpaceState other =
        player == SpaceState.black ? SpaceState.white : SpaceState.black;

    return pieces[player]!.any((space) {
      Coordinates coords = space.coordinates;
      bool result = false;
      for (var dir in Direction.values) {
        if (!result &&
            isValidCoordinate(coords.translate(dir, 2)) &&
            spaces[coords.translate(dir, 1)] == other &&
            spaces[coords.translate(dir, 2)] == SpaceState.empty) result = true;
      }

      return result;
    });
  }

  /// Checks whether the given [Coordinates] are valid based on the current size of the board.
  ///
  /// Returns false for negative values or values outside the bounds of the board, and true otherwise.
  bool isValidCoordinate(Coordinates coords) {
    return (coords.row >= 0 && coords.row < _size) &&
        (coords.col >= 0 && coords.col < _size);
  }
}
