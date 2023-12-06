import 'dart:convert';

import 'package:flutter_pokedex/models/abilities.dart';
import 'package:flutter_pokedex/models/pokemon.dart';
import 'package:flutter_pokedex/models/stat.dart';
import 'package:flutter_pokedex/models/types.dart';
import 'package:http/http.dart' as http;

class PokemonService {
  Future<Pokemon> fetchPokemonData(String pokemonUrl) async {
    final response = await http.get(Uri.parse(pokemonUrl));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      // Extrae los datos del JSON y crea una instancia de Pokemon
      return Pokemon(
        id: jsonData['id'],
        name: jsonData['name'],
        weight: jsonData['weight'],
        height: jsonData['height'],
        abilities: Abilities.decodeJson(jsonData['abilities']),
        stats: Stat.decodeJson(jsonData['stats']),
        types: PokeTypes.decodeJson(jsonData['types'],)
      );
    } else {
      throw Exception('Failed to load Pokémon data');
    }
  }

  Future<PokemonDescription> fetchPokemonDescription(int indexUrl) async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$indexUrl'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return PokemonDescription(
        flavorText: jsonData['flavor_text_entries'][0]['flavor_text'],
        color: jsonData['color']['name'],
      );
    } else {
      throw Exception('Failed to load Pokémon description');
    }
  }
}
