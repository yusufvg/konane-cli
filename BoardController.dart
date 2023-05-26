import 'BoardModel.dart';
import 'KonaneUtils.dart';

class BoardController {
  BoardModel _boardModel;
  SpaceState _currentPlayer = SpaceState.Black;

  BoardController(this._boardModel) {}

  bool makeMove(Coordinates origin, Coordinates dest) {
    // invalid coordinates
    if (_boardModel.isValidCoordinate(origin) &&
        _boardModel.isValidCoordinate(dest)) {
      return false;
    }

    // illegal diagonal move
    if (origin.row != dest.row && origin.col != dest.col) return false;

    // determine intermidiate spaces
    List<Space> intermediate_spaces = [];
    if (origin.row == dest.row) {
      if ((dest.col - origin.col).abs() % 2 != 0) return false;

      int start, end;
      if (dest.col > origin.col) {
        start = origin.col;
        end = dest.col;
      } else {
        start = dest.col;
        end = origin.col;
      }
      for (int i = start + 1; i < end; i += 2) {
        Coordinates intermediate = new Coordinates(origin.row, i);
        intermediate_spaces
            .add(Space(intermediate, _boardModel.getSpaceState(intermediate)));
      }
    } else {
      if ((dest.row - origin.row).abs() % 2 != 0) return false;

      int start, end;
      if (dest.row > origin.row) {
        start = origin.row;
        end = dest.row;
      } else {
        start = dest.row;
        end = origin.row;
      }
      for (int i = start + 1; i < end; i += 2) {
        Coordinates intermediate = new Coordinates(i, origin.col);
        intermediate_spaces
            .add(Space(intermediate, _boardModel.getSpaceState(intermediate)));
      }
    }

    // pieces in illegal state
    if (_boardModel.getSpaceState(dest) != SpaceState.Empty ||
        _boardModel.getSpaceState(origin) != _currentPlayer) return false;
    for (Space space in intermediate_spaces) {
      if (space.state == SpaceState.Empty) return false;
    }

    // make the move
    _boardModel.setSpaceState(origin, SpaceState.Empty);
    _boardModel.setSpaceState(dest, _currentPlayer);
    for (Space space in intermediate_spaces) {
      _boardModel.setSpaceState(space.coordinates, SpaceState.Empty);
    }

    return true;
  }

  /** Checks whether or not the currently active player has any valid moves remaining */
  bool hasValidMoves() {
    return _boardModel.hasValidMoves(_currentPlayer);
  }
}
