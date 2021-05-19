class EnemyCardModifier {}

class CharacterCardModifier {
  final Map<CharacterClass, int> activeClasses =
      Map.fromEntries(CharacterClass.values.map((e) => MapEntry<CharacterClass, int>(e, 0)));
  final Map<CharacterType, int> activeTypes =
      Map.fromEntries(CharacterType.values.map((e) => MapEntry<CharacterType, int>(e, 0)));
}

enum CharacterClass {
  blah,
}

enum CharacterType {
  blah,
}

abstract class CharacterCard {
  final CharacterClass characterClass;
  final CharacterType characterType;

  CharacterCard({
    required this.characterClass,
    required this.characterType,
  });
}

class BasicCharacterCard extends CharacterCard {
  final int attack;
  final int diplomacy;

  BasicCharacterCard({
    required this.attack,
    required this.diplomacy,
    required CharacterClass characterClass,
    required CharacterType characterType,
  }) : super(characterClass: characterClass, characterType: characterType);
}

abstract class EnemyCard {
  bool _revealed = false;
  bool get revealed => _revealed;

  int armorRating({required EnemyCardModifier modifier}) {
    return 0;
  }

  EnemyCard kill() {
    _revealed = false;
    return this;
  }
}
