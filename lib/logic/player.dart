import 'dart:collection';
import 'dart:math';

import 'package:legendary/logic/card.dart';
import 'package:legendary/logic/discard_collection.dart';

final handCount = 6;

class Player {
  final DiscardCollection<CharacterCard> deck;
  final List<CharacterCard> hand = List.empty();
  final int totalHealth;
  int health;
  bool get dead => health <= 0;

  Player({required Iterable<CharacterCard> deck, required this.totalHealth})
      : this.deck = DiscardCollection(initial: deck),
        this.health = totalHealth;

  void nextHand() {
    deck.discard(hand);
    hand.removeWhere((element) => true);

    hand.addAll(deck.draw(handCount));
  }

  void strike(Strike strike) {
    health = max(0, health - strike.count);
  }
}
