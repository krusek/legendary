import 'package:flutter_test/flutter_test.dart';
import 'package:legendary/logic/board.dart';
import 'package:legendary/logic/card.dart';
import 'package:legendary/logic/player.dart';

Board createBoard({
  Iterable<Objective> objectives = const [],
  Location? location,
  Iterable<EnemyCard> hive = const [],
  Iterable<EnemyCard> hatchery = const [],
  Iterable<Strike> strikes = const [],
  Iterable<CharacterCard> sergeants = const [],
  Iterable<CharacterCard> hq = const [],
  Iterable<CharacterCard> barracks = const [],
  Iterable<Player> players = const [],
}) {
  return Board(
    objectives: objectives,
    location: location ?? Location(),
    hive: hive,
    hatchery: hatchery,
    strikes: strikes,
    sergeants: sergeants,
    hq: hq,
    barracks: barracks,
    players: players,
  );
}

void main() {
  group('test of the logic functionality of the board object', () {
    test('test player iteration', () {});
  });
}
