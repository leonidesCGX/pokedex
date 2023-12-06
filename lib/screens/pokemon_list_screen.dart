import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_pokedex/widgets/cardList.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final ScrollController _scrollController = ScrollController();
  late TextEditingController _searchController = TextEditingController();
  List<dynamic> _pokemonList = [];
  List<dynamic> _displayedPokemon = [];
  bool _sortAscending = true;
  String _sortBy = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController.addListener(_scrollListener);
    fetchPokemonList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!_loading && _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMorePokemon();
    }
  }

  void fetchPokemonList() async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=1000'));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['results'] != null) {
        setState(() {
          _pokemonList = decoded['results'];
          _displayedPokemon = _pokemonList.take(18).toList();
        });
      }
    } else {
      throw Exception('Failed to load Pokémon');
    }
  }

  void _loadMorePokemon() async {
    if (!_loading) {
      setState(() {
        _loading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      int currentLength = _displayedPokemon.length;
      int newLength = currentLength + 9;
      if (newLength <= _pokemonList.length) {
        setState(() {
          _displayedPokemon.addAll(_pokemonList.getRange(currentLength, newLength));
          _loading = false;
        });
      } else {
        setState(() {
          _displayedPokemon.addAll(_pokemonList.getRange(currentLength, _pokemonList.length));
          _loading = false;
        });
      }
    }
  }

  void _sortPokemon(String sortBy) {
    setState(() {
      _sortBy = sortBy;
      if (_sortBy == 'Number') {
        _displayedPokemon.sort((a, b) => _sortAscending
            ? a['url'].toString().split('/').reversed.toList()[1].compareTo(b['url'].toString().split('/').reversed.toList()[1])
            : b['url'].toString().split('/').reversed.toList()[1].compareTo(a['url'].toString().split('/').reversed.toList()[1]));
      } else if (_sortBy == 'Name') {
        _displayedPokemon.sort((a, b) => _sortAscending
            ? a['name'].compareTo(b['name'])
            : b['name'].compareTo(a['name']));
      } else if (_sortBy == 'Search') {
        final searchText = _searchController.text.toLowerCase();
        _displayedPokemon = _pokemonList.where((pokemon) {
          final name = pokemon['name'].toString().toLowerCase();
          final number = pokemon['url'].toString().split('/').reversed.toList()[1].toLowerCase();

          return name.contains(searchText) || number.contains(searchText);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _sortBy = 'Search';
                        _sortPokemon(_sortBy);
                      });
                    },
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.redAccent.shade400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14.0),
                    ),
                    style: const TextStyle(
                        color: Colors.black),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showMenu(
                      context: context,
                      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                      items: <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'Number',
                          child: ListTile(
                            leading: Icon(_sortBy == 'Number'
                                ? Icons.check
                                : Icons.circle),
                            title: const Text('Order by Number'),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Name',
                          child: ListTile(
                            leading: Icon(
                              _sortBy == 'Name' ? Icons.check : Icons.circle,
                              color: Colors.black,
                            ),
                            title: const Text('Order by Name'),
                          ),
                        ),
                      ],
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          _sortAscending = _sortBy == value ? !_sortAscending : true;
                          _sortPokemon(value);
                        });
                      }
                    });
                  },
                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: _sortBy == ''
                          ? Icon(
                              Icons.sort,
                              color: Colors.redAccent.shade400,
                            )
                          : Icon(
                              _sortBy == 'Name'
                                  ? Icons.sort_by_alpha
                                  : Icons.numbers,
                              color: Colors.redAccent.shade400,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: buildCardList(_displayedPokemon, _scrollController),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
