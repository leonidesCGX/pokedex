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

  Color _getColorFromString(String colorString) {
    switch (colorString) {
      case 'black':
        return Colors.black;
      case 'blue':
        return Colors.blue;
      case 'brown':
        return Colors.brown;
      case 'gray':
        return Colors.grey;
      case 'green':
        return Colors.green;
      case 'pink':
        return Colors.pink;
      case 'purple':
        return Colors.purple;
      case 'red':
        return Colors.red;
      case 'white':
        return Colors.grey;
      case 'yellow':
        return Colors.yellow;
      case 'gold':
        return Colors.amber;
      case 'silver':
        return Colors.grey;
      case 'orange':
        return Colors.orange;
      case 'violet':
        return Colors.purpleAccent;
      case 'cyan':
        return Colors.cyan;
      case 'teal':
        return Colors.teal;
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
        colorSeleccionado = _getColorFromString(pokemonDescription.color);
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 200,
                  color: colorSeleccionado,
                  child: Image.network(
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.id}.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                        padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                        child: Row(
                          textDirection: TextDirection.ltr,
                          children: [
                            Expanded(
                                child: Text(
                                  pokemonDescription.flavorText,
                                  style: const TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                            ),
                          ],
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
