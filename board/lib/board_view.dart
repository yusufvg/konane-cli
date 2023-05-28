import 'dart:io';
import 'package:board/src/board_utils.dart';

import 'board_controller.dart';
import 'board_model.dart';

// TODO(yvangieson): doc comments
// TODO(yvangieson): testing
class BoardView {
  late BoardModel _boardModel;
  late BoardController _boardController;

  static const Map<SpaceState, String> _stateToString = {
    SpaceState.black: '○',
    SpaceState.white: '●',
    SpaceState.empty: '_'
  };

  BoardView() {
    _boardModel = BoardModel();
    _boardController = BoardController(_boardModel);
  }

  BoardView.customModel(this._boardModel) {
    _boardController = BoardController(_boardModel);
  }

  void startGame() {
    print(
        'To begin the game, select two adjacent, non-edge pieces (one of each color) to remove.');
    bool retry = false;
    Coordinates first;
    Coordinates second;
    do {
      if (retry) {
        print('Those were not a valid pair of pieces, try again.');
      }

      print('Select the first piece to remove (format: r,c): ');
      List<int> fCoords =
          stdin.readLineSync()!.split(',').map((e) => int.parse(e)).toList();
      first = Coordinates(fCoords[0], fCoords[1]);
      print('Select the second piece to remove (format: r,c): ');
      List<int> sCoords =
          stdin.readLineSync()!.split(',').map((e) => int.parse(e)).toList();
      second = Coordinates(sCoords[0], sCoords[1]);

      retry = (first.row == 0 ||
              first.col == 0 ||
              first.row == _boardModel.size - 1 ||
              first.col == _boardModel.size - 1) ||
          (second.row == 0 ||
              second.col == 0 ||
              second.row == _boardModel.size - 1 ||
              second.col == _boardModel.size - 1) ||
          ((first.row - second.row).abs() + (first.col - second.col).abs() !=
              1);
    } while (retry);

    _boardModel.setSpaceState(first, SpaceState.empty);
    _boardModel.setSpaceState(second, SpaceState.empty);
  }

  void makeMove() {
    bool retry = false;
    do {
      if (retry) {
        print('That is not a valid move, try again.');
      }

      print('${_stateToString[_boardController.currentPlayer]!}\'s turn');
      print('Select a piece to move (format: r,c): ');
      List<int> oCoords =
          stdin.readLineSync()!.split(',').map((e) => int.parse(e)).toList();
      Coordinates origin = Coordinates(oCoords[0], oCoords[1]);

      print('Select a destination (format: r,c): ');
      List<int> dCoords =
          stdin.readLineSync()!.split(',').map((e) => int.parse(e)).toList();
      Coordinates dest = Coordinates(dCoords[0], dCoords[1]);

      retry = !_boardController.makeMove(origin, dest);
    } while (retry);
  }

  void printBoard() {
    StringBuffer buf = StringBuffer();

    List<List<String>> orderedBoard =
        List.generate(8, (_) => List.filled(8, ''));

    buf.write('   0 1 2 3 4 5 6 7  \n');
    buf.write(' ┌─────────────────┐\n');

    _boardModel.spaces.forEach((coords, space) {
      orderedBoard[coords.row][coords.col] = _stateToString[space]!;
    });

    int rowNum = 0;
    for (var row in orderedBoard) {
      buf.write('$rowNum| ');
      buf.writeAll(row, ' ');
      buf.write(' │\n');
      rowNum++;
    }

    buf.write(' └─────────────────┘\n');

    print(buf.toString());
  }

  bool checkForWinner() {
    if (_boardController.hasValidMoves()) {
      return false;
    } else {
      print(
          "${_stateToString[getOpponent(_boardController.currentPlayer)]} has won the game!");
      return true;
    }
  }
}
