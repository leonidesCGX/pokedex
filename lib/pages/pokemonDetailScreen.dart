import 'package:flutter/material.dart';
import 'package:flutter_pokedex/models/pokemon.dart';
import 'package:flutter_pokedex/services/pokemonService.dart';
import 'package:flutter_pokedex/widgets/buildStatBar.dart';
import 'package:flutter_pokedex/widgets/detailCard.dart';

class PokemonDetailsScreen extends StatefulWidget {
  final String pokemonUrl;
  final int indexUrl;

  const PokemonDetailsScreen({
    Key? key,
    required this.pokemonUrl,
    required this.indexUrl,
  }) : super(key: key);

  @override
  _PokemonDetailsScreenState createState() => _PokemonDetailsScreenState();
}

class _PokemonDetailsScreenState extends State<PokemonDetailsScreen> {
  final PokemonService pokemonService = PokemonService();
  Color colorSeleccionado = Colors.black;
  late Pokemon pokemon;
  late PokemonDescription pokemonDescription;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPokemonData();
  }

  // bug : #A7B723, Dark: #75574C, Dragon: #7037FF, Electric: #F9CF30, Fairy: #E69EAC, Fighting: #C12239, Fire: #F57D31, Flying: #A891EC, Ghost: #70559B, Normal: #AAA67F, Grass: #74CB48, Ground: #DEC16B, Ice: #9AD6DF, Poison: #A43E9E, Psychic: #FB5584, Rock: #B69E31, Steel: #B7B9D0, Water: #6493EB
  Color getColorFromType(String colorString) {
    switch (colorString.toLowerCase()) {
      case 'bug':
        return const Color(0xFFA7B723);
      case 'dark':
        return const Color(0xFF75574C);
      case 'dragon':
        return const Color(0xFF7037FF);
      case 'electric':
        return const Color(0xFFF9CF30);
      case 'fairy':
        return const Color(0xFFE69EAC);
      case 'fighting':
        return const Color(0xFFC12239);
      case 'fire':
        return const Color(0xFFF57D31);
      case 'flying':
        return const Color(0xFFA891EC);
      case 'ghost':
        return const Color(0xFF70559B);
      case 'normal':
        return const Color(0xFFAAA67F);
      case 'grass':
        return const Color(0xFF74CB48);
      case 'ground':
        return const Color(0xFFDEC16B);
      case 'ice':
        return const Color(0xFF9AD6DF);
      case 'poison':
        return const Color(0xFFA43E9E);
      case 'psychic':
        return const Color(0xFFFB5584);
      case 'rock':
        return const Color(0xFFB69E31);
      case 'steel':
        return const Color(0xFFB7B9D0);
      case 'water':
        return const Color(0xFF6493EB);
      default:
        return Colors.black;
    }
  }

  Future<void> fetchPokemonData() async {
    try {
      pokemon = await pokemonService.fetchPokemonData(widget.pokemonUrl);
      pokemonDescription =
          await pokemonService.fetchPokemonDescription(widget.indexUrl);
      setState(() {
        colorSeleccionado = getColorFromType(pokemon.types[0].name);
        isLoading = false;
      });
    } catch (e) {
      print(e);
      // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: colorSeleccionado,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pokemon.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ' #${pokemon.id}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        body: Container(
          color: colorSeleccionado,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 200,
                  color: colorSeleccionado,
                  child: Image.network(
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.id}.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: pokemon.types
                                  .map(
                                    (type) => Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      color: colorSeleccionado,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          type.name,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'About',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorSeleccionado,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: buildDetailCard(
                                label: 'Weight',
                                value: '${pokemon.weight}',
                              ),
                            ),
                            Expanded(
                              child: buildDetailCard(
                                label: 'Height',
                                value: '${pokemon.height}',
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: buildAbilityCard(pokemon.abilities),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Container(
                          height: 120,
                          width: double.infinity,
                          alignment: Alignment
                              .center, // Alinea el texto al centro si es necesario
                          child: Text(
                            pokemonDescription.flavorText,
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Base Stats:',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorSeleccionado,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildStatBar(
                                    'HP',
                                    pokemon.stats
                                        .firstWhere((s) => s.name == 'hp')
                                        .value,
                                    colorSeleccionado,
                                  ),
                                  buildStatBar(
                                    'ATK',
                                    pokemon.stats
                                        .firstWhere((s) => s.name == 'attack')
                                        .value,
                                    colorSeleccionado,
                                  ),
                                  buildStatBar(
                                    'DEF',
                                    pokemon.stats
                                        .firstWhere((s) => s.name == 'defense')
                                        .value,
                                    colorSeleccionado,
                                  ),
                                  buildStatBar(
                                    'SATK',
                                    pokemon.stats
                                        .firstWhere(
                                            (s) => s.name == 'special-attack')
                                        .value,
                                    colorSeleccionado,
                                  ),
                                  buildStatBar(
                                    'SDEF',
                                    pokemon.stats
                                        .firstWhere(
                                            (s) => s.name == 'special-defense')
                                        .value,
                                    colorSeleccionado,
                                  ),
                                  buildStatBar(
                                    'SPD',
                                    pokemon.stats
                                        .firstWhere((s) => s.name == 'speed')
                                        .value,
                                    colorSeleccionado,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
