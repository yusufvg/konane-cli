import 'package:board/board_controller.dart';
import 'package:board/board_model.dart';
import 'package:board/src/board_utils.dart';
import 'package:test/test.dart';
import 'board_test_utils.dart';

void main() {
  group('makeMove', () {
    late BoardModel model;
    late BoardController controller;

    setUp(() {
      model = BoardModel();
      controller = BoardController(model);
    });

    test('updates the current player after a succesful jump', () {
      setBoardState(
          model,
          'bw_-_-_-\n'
          'w-_-_-_-\n'
          '_-_w_-_w\n'
          '_-wbw-_b\n'
          '_-_w_-_w\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-wbw-_-\n');

      expect(controller.currentPlayer, equals(SpaceState.black));
      expect(controller.makeMove(Coordinates(0, 0), Coordinates(0, 2)), isTrue);
      expect(controller.currentPlayer, equals(SpaceState.white));
    });

    test('completes a horizontal single jump', () {
      setBoardState(
          model,
          'bw_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n');

      expect(model.pieces[SpaceState.white]!.length, 1);
      expect(model.pieces[SpaceState.black]!.length, 1);

      expect(controller.makeMove(Coordinates(0, 0), Coordinates(0, 2)), isTrue);

      expect(model.spaces[Coordinates(0, 0)], equals(SpaceState.empty));
      expect(model.spaces[Coordinates(0, 1)], equals(SpaceState.empty));
      expect(model.spaces[Coordinates(0, 2)], equals(SpaceState.black));

      expect(model.pieces[SpaceState.white]!.length, 0);
      expect(model.pieces[SpaceState.black]!.length, 1);
      expect(
          model.pieces[SpaceState.black]!
              .any((space) => space.coordinates == Coordinates(0, 2)),
          isTrue);
    });

    test('completes a horizontal double jump', () {
      setBoardState(
          model,
          'bw_w_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n');

      expect(model.pieces[SpaceState.white]!.length, 2);
      expect(model.pieces[SpaceState.black]!.length, 1);

      expect(controller.makeMove(Coordinates(0, 0), Coordinates(0, 4)), isTrue);

      expect(model.spaces[Coordinates(0, 0)], equals(SpaceState.empty));
      expect(model.spaces[Coordinates(0, 1)], equals(SpaceState.empty));
      expect(model.spaces[Coordinates(0, 3)], equals(SpaceState.empty));
      expect(model.spaces[Coordinates(0, 4)], equals(SpaceState.black));

      expect(model.pieces[SpaceState.white]!.length, 0);
      expect(model.pieces[SpaceState.black]!.length, 1);
      expect(
          model.pieces[SpaceState.black]!
              .any((space) => space.coordinates == Coordinates(0, 4)),
          isTrue);
    });

    test('completes a vertical single jump', () {
      setBoardState(
          model,
          'b-_-_-_-\n'
          'w-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n');

      expect(model.pieces[SpaceState.white]!.length, 1);
      expect(model.pieces[SpaceState.black]!.length, 1);

      expect(controller.makeMove(Coordinates(0, 0), Coordinates(2, 0)), isTrue);

      expect(model.spaces[Coordinates(0, 0)], equals(SpaceState.empty));
      expect(model.spaces[Coordinates(1, 0)], equals(SpaceState.empty));
      expect(model.spaces[Coordinates(2, 0)], equals(SpaceState.black));

      expect(model.pieces[SpaceState.white]!.length, 0);
      expect(model.pieces[SpaceState.black]!.length, 1);
      expect(
          model.pieces[SpaceState.black]!
              .any((space) => space.coordinates == Coordinates(2, 0)),
          isTrue);
    });

    test('completes a vertical double jump', () {
      setBoardState(
          model,
          'b-_-_-_-\n'
          'w-_-_-_-\n'
          '_-_-_-_-\n'
          'w-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n');

      expect(model.pieces[SpaceState.white]!.length, 2);
      expect(model.pieces[SpaceState.black]!.length, 1);

      expect(controller.makeMove(Coordinates(0, 0), Coordinates(4, 0)), isTrue);

      expect(model.spaces[Coordinates(0, 0)], equals(SpaceState.empty));
      expect(model.spaces[Coordinates(1, 0)], equals(SpaceState.empty));
      expect(model.spaces[Coordinates(3, 0)], equals(SpaceState.empty));
      expect(model.spaces[Coordinates(4, 0)], equals(SpaceState.black));

      expect(model.pieces[SpaceState.white]!.length, 0);
      expect(model.pieces[SpaceState.black]!.length, 1);
      expect(
          model.pieces[SpaceState.black]!
              .any((space) => space.coordinates == Coordinates(4, 0)),
          isTrue);
    });

    test('rejects a diagonal jump', () {
      setBoardState(
          model,
          'bw_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n');

      expect(model.pieces[SpaceState.white]!.length, 1);
      expect(model.pieces[SpaceState.black]!.length, 1);

      expect(
          controller.makeMove(Coordinates(0, 0), Coordinates(2, 2)), isFalse);

      expect(model.pieces[SpaceState.white]!.length, 1);
      expect(model.pieces[SpaceState.black]!.length, 1);
    });

    test('rejects a jump with an invalid distance (uneven)', () {
      setBoardState(
          model,
          'bw_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n');

      expect(model.pieces[SpaceState.white]!.length, 1);
      expect(model.pieces[SpaceState.black]!.length, 1);

      expect(
          controller.makeMove(Coordinates(0, 0), Coordinates(0, 3)), isFalse);

      expect(model.pieces[SpaceState.white]!.length, 1);
      expect(model.pieces[SpaceState.black]!.length, 1);
    });

    test('rejects invalid origin coordinates', () {
      setBoardState(
          model,
          'bw_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n');

      expect(model.pieces[SpaceState.white]!.length, 1);
      expect(model.pieces[SpaceState.black]!.length, 1);

      expect(
          controller.makeMove(Coordinates(-1, 0), Coordinates(0, 1)), isFalse);

      expect(model.pieces[SpaceState.white]!.length, 1);
      expect(model.pieces[SpaceState.black]!.length, 1);
    });

    test('rejects invalid dest coordinates', () {
      setBoardState(
          model,
          '_-_-_-bw\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n');

      expect(model.pieces[SpaceState.white]!.length, 1);
      expect(model.pieces[SpaceState.black]!.length, 1);

      expect(
          controller.makeMove(Coordinates(0, 6), Coordinates(0, 8)), isFalse);

      expect(model.pieces[SpaceState.white]!.length, 1);
      expect(model.pieces[SpaceState.black]!.length, 1);
    });

    test('rejects an occupied destination space', () {
      setBoardState(
          model,
          'bwb-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n');

      expect(model.pieces[SpaceState.white]!.length, 1);
      expect(model.pieces[SpaceState.black]!.length, 2);

      expect(
          controller.makeMove(Coordinates(0, 0), Coordinates(0, 2)), isFalse);

      expect(model.pieces[SpaceState.white]!.length, 1);
      expect(model.pieces[SpaceState.black]!.length, 2);
    });

    test('rejects an empty intermediate space', () {
      setBoardState(
          model,
          'b-_w_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n');

      expect(model.pieces[SpaceState.white]!.length, 1);
      expect(model.pieces[SpaceState.black]!.length, 1);

      expect(
          controller.makeMove(Coordinates(0, 0), Coordinates(0, 2)), isFalse);

      expect(model.pieces[SpaceState.white]!.length, 1);
      expect(model.pieces[SpaceState.black]!.length, 1);
    });
  });

  group('hasValidMoves', () {
    group('returns true', () {
      late BoardModel model;
      late BoardController controller;

      setUp(() {
        model = BoardModel();
        controller = BoardController(model);

        setBoardState(
            model,
            'bw_w_-_-\n'
            '_-_-_-_-\n'
            '_-_-_-_-\n'
            '_-_-_-_-\n'
            '_-_-_-_-\n'
            '_-_-_-_-\n'
            '_-_-_-_-\n'
            '_-_-_-_-\n');
      });

      test('for black when they have available moves', () {
        expect(controller.hasValidMoves(), isTrue);
      });

      test('for white when they have available moves', () {
        // make a move to set current player to white
        expect(
            controller.makeMove(Coordinates(0, 0), Coordinates(0, 2)), isTrue);

        expect(controller.hasValidMoves(), isTrue);
      });
    });

    group('returns false', () {
      late BoardModel model;
      late BoardController controller;

      setUp(() {
        model = BoardModel();
        controller = BoardController(model);
      });

      test('for black when they have no available moves', () {
        setBoardState(
            model,
            'bwb-_-_-\n'
            '_-_-_-_-\n'
            '_-_-_-_-\n'
            '_-_-_-_-\n'
            '_-_-_-_-\n'
            '_-_-_-_-\n'
            '_-_-_-_-\n'
            '_-_-_-_-\n');

        expect(controller.hasValidMoves(), isFalse);
      });

      test('for white when they have no available moves', () {
        setBoardState(
            model,
            'bwbw_-_-\n'
            '_-_-_-_-\n'
            '_-_-_-_-\n'
            '_-_-_-_-\n'
            '_-_-_-_-\n'
            '_-_-_-_-\n'
            '_-_-_-_-\n'
            '_-_-_-_-\n');

        // make a move to set current player to white
        expect(
            controller.makeMove(Coordinates(0, 2), Coordinates(0, 4)), isTrue);

        expect(controller.hasValidMoves(), isFalse);
      });
    });
  });
}
