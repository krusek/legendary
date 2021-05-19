import 'dart:collection';

import 'package:legendary/logic/card.dart';
import 'package:legendary/logic/discard_collection.dart';

final handCount = 6;

class Player {
  final DiscardCollection<CharacterCard> deck;
  final List<CharacterCard> hand = List.empty();

  Player({required Iterable<CharacterCard> deck}) : this.deck = DiscardCollection(initial: deck);

  void nextHand() {
    deck.discard(hand);
    hand.removeWhere((element) => true);

    hand.addAll(deck.draw(handCount));
  }
}
