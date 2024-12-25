import 'dart:collection';
import 'dart:html';

import 'package:legendary/logic/card.dart';

import 'discard_collection.dart';
import 'player.dart';

class Board {
  final Queue<Objective> objectives;
  final TheComplex complex = TheComplex();

  final DiscardCollection<EnemyCard> hive;
  final Queue<EnemyCard> hatchery;

  final Location location;
  final List<EnemyCard> combatZone = List.empty();
  final List<CharacterCard> operations = List.empty();

  final DiscardCollection<Strike> strikes;

  final Queue<CharacterCard> sergeants;
  final DiscardCollection<CharacterCard> barracks;
  final List<CharacterCard> hq;

  final DiscardCollection<Player> players;
  final List<Player> deadPlayers = List.empty(growable: true);
  int _currentPlayer = 0;

  Board({
    required Iterable objectives,
    required this.location,
    required Iterable<EnemyCard> hive,
    required Iterable<EnemyCard> hatchery,
    required Iterable<Strike> strikes,
    required Iterable<CharacterCard> sergeants,
    required Iterable<CharacterCard> hq,
    required Iterable<CharacterCard> barracks,
    required Iterable<Player> players,
  })   : this.objectives = Queue.from(objectives),
        this.hive = DiscardCollection(initial: hive),
        this.hatchery = Queue.from(hatchery),
        this.strikes = DiscardCollection(initial: strikes),
        this.sergeants = Queue.from(sergeants),
        this.barracks = DiscardCollection(initial: barracks),
        this.hq = List.from(hq),
        this.players = DiscardCollection(initial: players),
        assert(players.isNotEmpty);

  void nextPlayer() {
    final player = players.draw(1).first;
    players.discard([player]);
  }

  Player get currentPlayer => players.topCard;

  void enemyAttackPhase() {
    final Player player = currentPlayer;
    for (final enemy in combatZone) {
      int count = enemy.attackCount;
      final strike = strikes.draw(count);
      for (final s in strike) {
        player.strike(s);
        Strike past = s;
        while (past.drawAgain) {
          past = strikes.draw(1).first;
          player.strike(past);
          strikes.discard([past]);
        }
      }
      strikes.discard(strike);
    }
    if (player.dead) {
      print('player $_currentPlayer has died');
      deadPlayers.addAll(players.draw(1));
    }
  }
}

abstract class ComplexRoom {
  EnemyCard? card;

  bool get blocked => false;
  bool get empty => card == null;
  int get scanCost;
}

class Location {}

class Objective {}

class StandardRoom extends ComplexRoom {
  final int scanCost;
  StandardRoom(int index) : scanCost = (index / 2).floor() + 2;
}

class TheComplex {
  final List<ComplexRoom> rooms;
  TheComplex({int length = 5}) : rooms = List.generate(length, (index) => StandardRoom(index));

  List<EnemyCard> add({required EnemyCard card}) {
    EnemyCard movingCard = card;
    for (int ix = rooms.length - 1; ix >= 0; ix--) {
      EnemyCard? current = rooms[ix].card;
      if (current == null) {
        rooms[ix].card = card;
        return [];
      } else if (rooms[ix].blocked) {
        continue;
      } else {
        rooms[ix].card = movingCard;
        movingCard = current;
      }
    }
    return [movingCard];
  }
}

/*
 * Objective
 * The Complex:
 *  Airlock - 2
 *  Med-Lab - 2
 *  Weapons Locker - 3
 *  Power Station - 3
 *  Ventilation Shaft - 4
 * 
 * Some cards, when revealed, stay in the same place in the complex and block that room. (room.blocked == true)
 * Some cards, when revealed, move cards to operations. (EnemyCard card.reveal(game: game))
 * Some cards, when revealed, do something and then disappear. (card.reveal(game: game) => null)
 * Some cards can be attached to a room and modify revealed characters there.
 * Some cards can only be attacked based on which room they are in.
 * Some cards can only be attacked based on the status of surrounding rooms.
 * 
 * Hive
 * Hatchery
 * Dead Enemies
 * 
 * Location
 * Combat Zone
 * Operations
 * Strikes
 * Discarded Strikes
 * Discarded Hazards / Events
 * 
 * Sergeants
 * HQ
 * Barracks
 * Dead Characters
*/
