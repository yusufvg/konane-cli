// Runs the game
import 'package:board/board_view.dart';

void main() {
  BoardView view = BoardView();

  view.printBoard();
  view.startGame();

  while (!view.checkForWinner()) {
    view.printBoard();
    view.makeMove();
  }

  view.printBoard();
}
