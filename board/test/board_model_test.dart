import 'package:board/board_model.dart';
import 'package:board/src/board_utils.dart';
import 'package:test/test.dart';
import 'board_test_utils.dart';

void main() {
  group('getSpaceState', () {
    late BoardModel model;

    setUp(() => model = BoardModel());

    test('correctly retrieves initial space states', () {
      expect(model.getSpaceState(Coordinates(0, 0)), equals(SpaceState.black));
      expect(model.getSpaceState(Coordinates(0, 1)), equals(SpaceState.white));
    });

    test('throws an error for invalid coordinates', () {
      expect(
          () => model.getSpaceState(Coordinates(-1, 5)), throwsArgumentError);
      expect(
          () => model.getSpaceState(Coordinates(5, -1)), throwsArgumentError);
      expect(() => model.getSpaceState(Coordinates(8, 5)), throwsArgumentError);
      expect(() => model.getSpaceState(Coordinates(5, 8)), throwsArgumentError);
    });

    test('throws an error for a missing space', () {
      model.spaces.remove(Coordinates(0, 0));
      expect(() => model.getSpaceState(Coordinates(0, 0)), throwsArgumentError);
    });
  });

  group('setSpaceState', () {
    late BoardModel model;

    setUp(() => model = BoardModel());

    test('correctly updates the state of valid coordinates', () {
      Coordinates coords = Coordinates(0, 0);

      model.setSpaceState(coords, SpaceState.empty);
      expect(model.getSpaceState(coords), equals(SpaceState.empty));
    });

    test('removes a piece from the player set if a space is set to empty', () {
      Coordinates bCoords = Coordinates(0, 0);
      Coordinates wCoords = Coordinates(0, 1);

      model.setSpaceState(bCoords, SpaceState.empty);
      model.setSpaceState(wCoords, SpaceState.empty);

      expect(model.pieces[SpaceState.black]!.length, 31);
      expect(model.pieces[SpaceState.white]!.length, 31);
      expect(
          model.pieces[SpaceState.black]!
              .any((space) => space.coordinates == bCoords),
          isFalse);
      expect(
          model.pieces[SpaceState.white]!
              .any((space) => space.coordinates == wCoords),
          isFalse);
    });

    test('adds a piece to the player set if a space is set to non-empty', () {
      setBoardState(
          model,
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n');

      Coordinates bCoords = Coordinates(0, 0);
      Coordinates wCoords = Coordinates(0, 1);

      model.setSpaceState(bCoords, SpaceState.black);
      model.setSpaceState(wCoords, SpaceState.white);

      expect(model.pieces[SpaceState.black]!.length, 1);
      expect(model.pieces[SpaceState.white]!.length, 1);
      expect(
          model.pieces[SpaceState.black]!
              .any((space) => space.coordinates == bCoords),
          isTrue);
      expect(
          model.pieces[SpaceState.white]!
              .any((space) => space.coordinates == wCoords),
          isTrue);
    });

    test('throws an error for invalid coordinates', () {
      expect(() => model.setSpaceState(Coordinates(-1, 5), SpaceState.empty),
          throwsArgumentError);
      expect(() => model.setSpaceState(Coordinates(5, -1), SpaceState.empty),
          throwsArgumentError);
      expect(() => model.setSpaceState(Coordinates(8, 5), SpaceState.empty),
          throwsArgumentError);
      expect(() => model.setSpaceState(Coordinates(5, 8), SpaceState.empty),
          throwsArgumentError);
    });

    test('throws an error for a missing space', () {
      model.spaces.remove(Coordinates(0, 0));
      expect(() => model.setSpaceState(Coordinates(0, 0), SpaceState.empty),
          throwsArgumentError);
    });
  });

  group('hasValidMoves', () {
    late BoardModel model;

    setUp(() => model = BoardModel());

    test('returns false on a completely full board for both players', () {
      expect(model.hasValidMoves(SpaceState.black), isFalse);
      expect(model.hasValidMoves(SpaceState.white), isFalse);
    });

    test('returns false on a completely empty board for both players', () {
      setBoardState(
          model,
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n');

      expect(model.hasValidMoves(SpaceState.black), isFalse);
      expect(model.hasValidMoves(SpaceState.white), isFalse);
    });

    test('handles cases where only black has valid moves', () {
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

      expect(model.hasValidMoves(SpaceState.black), isTrue);
      expect(model.hasValidMoves(SpaceState.white), isFalse);
    });

    test('handles cases where only white has valid moves', () {
      setBoardState(
          model,
          '_-_-_-bw\n'
          '_-_-_-_b\n'
          '_-b-_-_-\n'
          '_bwb_-_b\n'
          '_-b-_-_w\n'
          '_-_-_-_b\n'
          '_-_-_-_-\n'
          '_-_bwb_-\n');

      expect(model.hasValidMoves(SpaceState.black), isFalse);
      expect(model.hasValidMoves(SpaceState.white), isTrue);
    });

    test('handles cases where both players have valid moves', () {
      setBoardState(
          model,
          'bw_-_w_-\n'
          '_-_-_b_-\n'
          '_wb-_w_-\n'
          '_-wb_-_-\n'
          '_-_-_-_-\n'
          '_-_bwb_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n');

      expect(model.hasValidMoves(SpaceState.black), isTrue);
      expect(model.hasValidMoves(SpaceState.white), isTrue);
    });
  });

  group('isValidCoordinate', () {
    late BoardModel model;
    setUp(() => model = BoardModel());

    test('accepts valid coordinates', () {
      expect(model.isValidCoordinate(Coordinates(0, 0)), isTrue);
      expect(model.isValidCoordinate(Coordinates(7, 7)), isTrue);
      expect(model.isValidCoordinate(Coordinates(3, 6)), isTrue);
    });

    test('rejects negative coordinates', () {
      expect(model.isValidCoordinate(Coordinates(-1, 0)), isFalse);
      expect(model.isValidCoordinate(Coordinates(0, -1)), isFalse);
      expect(model.isValidCoordinate(Coordinates(-1, -1)), isFalse);
    });

    test('rejects coordinates past the bounds of the board', () {
      expect(model.isValidCoordinate(Coordinates(8, 0)), isFalse);
      expect(model.isValidCoordinate(Coordinates(0, 8)), isFalse);
      expect(model.isValidCoordinate(Coordinates(8, 8)), isFalse);
    });
  });
}
