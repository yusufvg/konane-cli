import 'package:board/board_model.dart';
import 'package:board/src/board_utils.dart';

// Helpers.

void setBoardState(BoardModel model, String board) {
  int r = 0;
  for (String row in board.split('\n')) {
    int c = 0;
    for (String space in row.split('')) {
      SpaceState state;
      switch (space) {
        case 'b':
          state = SpaceState.black;
        case 'w':
          state = SpaceState.white;
        default:
          state = SpaceState.empty;
      }

      model.setSpaceState(Coordinates(r, c), state);
      c++;
    }
    r++;
  }
}
