import 'package:flutter_pokedex/models/stat.dart';

class Pokemon {
  final int id;
  final String name;
  final int weight;
  final int height;
  final List<dynamic> abilities;
  final List<Stat> stats;
  final List<dynamic> types;

  Pokemon({
    required this.id,
    required this.name,
    required this.weight,
    required this.height,
    required this.abilities,
    required this.stats,
    required this.types,
  });
}

class PokemonDescription {
  final String flavorText;
  final String color;

  PokemonDescription({
    required this.flavorText,
    required this.color,
  });
}
