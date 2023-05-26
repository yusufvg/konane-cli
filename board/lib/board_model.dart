import 'src/board_utils.dart';

class BoardModel {
  late Map<Coordinates, SpaceState> spaces;
  late Map<SpaceState, List<Space>> pieces;

  BoardModel([int size = 8]) {
    spaces = {};
    pieces = {SpaceState.Black: [], SpaceState.White: []};
    SpaceState nextState = SpaceState.Black;

    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        Coordinates coords = new Coordinates(r, c);
        spaces[coords] = nextState;
        pieces[nextState]!.add(new Space(coords, nextState));
        nextState =
            nextState == SpaceState.Black ? SpaceState.White : SpaceState.Black;
      }
    }
  }

  SpaceState getSpaceState(Coordinates coords) {
    if (!isValidCoordinate(coords))
      throw ArgumentError('invalid coordinates: ${coords.row}, ${coords.col}');

    return spaces.containsKey(coords)
        ? spaces[coords]!
        : throw ArgumentError(
            'coordinates not found in board: ${coords.row}, ${coords.col}');
  }

  void setSpaceState(Coordinates coords, SpaceState state) {
    if (!isValidCoordinate(coords))
      throw ArgumentError('invalid coordinates: ${coords.row}, ${coords.col}');

    SpaceState currentState = spaces.containsKey(coords)
        ? spaces[coords]!
        : throw ArgumentError(
            'coordinates not found in board: ${coords.row}, ${coords.col}');
    if (state == currentState) return;

    // removing a piece
    if ({SpaceState.Black, SpaceState.White}.contains(currentState)) {
      pieces[currentState] = pieces[currentState]!
          .where((space) => space.coordinates != coords)
          .toList();
    }

    // placing a piece
    if ({SpaceState.Black, SpaceState.White}.contains(state)) {
      pieces[state]!.add(new Space(coords, state));
    }

    spaces[coords] = state;
  }

  /** Checks whether the given player has any valid moves remaining */
  bool hasValidMoves(SpaceState player) {
    if (!{SpaceState.Black, SpaceState.White}.contains(player))
      throw ArgumentError('invalid player value: $player');

    SpaceState other =
        player == SpaceState.Black ? SpaceState.White : SpaceState.Black;

    return pieces[player]!.any((space) {
      Coordinates coords = space.coordinates;
      bool result = false;
      Direction.values.forEach((dir) {
        if (!result &&
            isValidCoordinate(coords.translate(dir, 2)) &&
            spaces[coords.translate(dir, 1)] == other &&
            spaces[coords.translate(dir, 2)] == SpaceState.Empty) result = true;
      });

      return result;
    });
  }

  bool isValidCoordinate(Coordinates coords) {
    return (coords.row >= 0 && coords.row < spaces.length) &&
        (coords.col >= 0 && coords.col < spaces.length);
  }
}
