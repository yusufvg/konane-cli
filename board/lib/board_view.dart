import 'board_controller.dart';
import 'board_model.dart';

class BoardView {
  late BoardModel _boardModel;
  late BoardController _boardController;

  BoardView(this._boardModel) {
    _boardModel = new BoardModel();
    _boardController = new BoardController(_boardModel);
  }

  // TODO(yvangieson): reimplement for new map spaces
  String printBoard() {
    StringBuffer buf = new StringBuffer();

    // for (List<SpaceState> row in _boardModel.spaces) {
    //   for (SpaceState space in row) {
    //     switch (space) {
    //       case SpaceState.Black:
    //         buf.write('X ');
    //       case SpaceState.White:
    //         buf.write('O ');
    //       default:
    //         buf.write('  ');
    //     }
    //     buf.write('\n');
    //   }
    // }

    return buf.toString();
  }
}
