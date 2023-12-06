import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../pages/pokemonDetailScreen.dart';

Widget buildCardList(List<dynamic> pokemonList, ScrollController scrollController) {
  return GridView.builder(
    controller: scrollController,
    itemCount: pokemonList.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
    ),
    itemBuilder: (BuildContext context, int index) {
      var pokemonNumber = pokemonList[index]['url']
          .split("https://pokeapi.co/api/v2/pokemon/")[1]
          .split("/")[0];
      return GestureDetector( 
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PokemonDetailsScreen(pokemonUrl: pokemonList[index]['url'], indexUrl: index+1),
            ),
          );
        },
        child: Card(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonNumber.png',
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        pokemonList[index]['name'],
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    '#$pokemonNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
