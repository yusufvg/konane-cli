import 'dart:io';
import 'package:board/src/board_utils.dart';

import 'board_controller.dart';
import 'board_model.dart';

class BoardView {
  late BoardModel _boardModel;
  late BoardController _boardController;

  BoardView(this._boardModel) {
    _boardModel = BoardModel();
    _boardController = BoardController(_boardModel);
  }

  bool makeMove() {
    print('Select a piece to move (format: r,c): ');
    List<int> oCoords =
        stdin.readLineSync()!.split(',').map((e) => int.parse(e)).toList();
    Coordinates origin = Coordinates(oCoords[0], oCoords[1]);

    print('Select a destination (format: r,c): ');
    List<int> dCoords =
        stdin.readLineSync()!.split(',').map((e) => int.parse(e)).toList();
    Coordinates dest = Coordinates(dCoords[0], dCoords[1]);

    return _boardController.makeMove(origin, dest);
  }

  // TODO(yvangieson): reimplement for new map spaces
  String printBoard() {
    StringBuffer buf = StringBuffer();

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
