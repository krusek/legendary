import 'dart:collection';

class DiscardCollection<T> {
  final Queue<T> _collection;
  final List<T> _discard = List.empty(growable: true);

  DiscardCollection({required Iterable<T> initial}) : _collection = Queue.from(initial);

  bool get empty => _collection.length + _discard.length == 0;

  void discard(Iterable<T> cards) {
    _discard.addAll(cards);
  }

  Iterable<T> draw(int count) sync* {
    for (int ix = 0; ix < count; ix++) {
      yield _drawCard();
    }
  }

  T _drawCard() {
    assert(_collection.isNotEmpty || _discard.isNotEmpty);
    if (_collection.length == 0) {
      _shuffleDiscard();
    }
    assert(_collection.isNotEmpty);
    return _collection.removeFirst();
  }

  void _shuffleDiscard() {
    _discard.shuffle();
    _collection.addAll(_discard);
    _discard.removeWhere((element) => true);
  }
}
