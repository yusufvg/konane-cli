import 'board_model.dart';
import 'src/board_utils.dart';

class BoardController {
  final BoardModel _boardModel;
  SpaceState _currentPlayer = SpaceState.black;

  BoardController(this._boardModel);

  SpaceState get currentPlayer {
    return SpaceState.values[_currentPlayer.index];
  }

  /// Attempts to have the current player move their piece from [origin] to [dest],
  /// capturing any opponent pieces jumped over en route.
  ///
  /// Returns false if the move is not legal (e.g. invalid coords, diagonal jump, destination occupied, etc.).
  /// Returns true if the move was successfully completed. In this case, the current player is updated to the opponent.
  bool makeMove(Coordinates origin, Coordinates dest) {
    // invalid coordinates
    if (!_boardModel.isValidCoordinate(origin) ||
        !_boardModel.isValidCoordinate(dest)) {
      return false;
    }

    // illegal diagonal move
    if (origin.row != dest.row && origin.col != dest.col) return false;

    // determine intermidiate spaces
    List<Space> intermediateSpaces = [];
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
        Coordinates intermediate = Coordinates(origin.row, i);
        intermediateSpaces
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
        Coordinates intermediate = Coordinates(i, origin.col);
        intermediateSpaces
            .add(Space(intermediate, _boardModel.getSpaceState(intermediate)));
      }
    }

    // pieces in illegal state
    if (_boardModel.getSpaceState(dest) != SpaceState.empty ||
        _boardModel.getSpaceState(origin) != _currentPlayer) return false;
    for (Space space in intermediateSpaces) {
      if (space.state == SpaceState.empty) return false;
    }

    // make the move
    _boardModel.setSpaceState(origin, SpaceState.empty);
    _boardModel.setSpaceState(dest, _currentPlayer);
    for (Space space in intermediateSpaces) {
      _boardModel.setSpaceState(space.coordinates, SpaceState.empty);
    }
    _currentPlayer = _currentPlayer == SpaceState.black
        ? SpaceState.white
        : SpaceState.black;

    return true;
  }

  /// Checks whether or not the currently active player has any valid moves remaining.
  bool hasValidMoves() {
    return _boardModel.hasValidMoves(_currentPlayer);
  }
}
