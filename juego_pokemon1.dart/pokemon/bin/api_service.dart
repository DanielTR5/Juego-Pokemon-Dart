import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pokemon.dart';

class ApiService {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  static Future<Pokemon> getPokemon(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pokemon/$id'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final name = data['name'];
        final stats = data['stats'];
        final health = stats[0]['base_stat'];
        final attack = stats[1]['base_stat'];
        final defense = stats[2]['base_stat']; 
        final speed = stats[5]['base_stat'];
        final types = data['types'];
        final type1 = types[0]['type']['name'];
        final type2 = types.length > 1 ? types[1]['type']['name'] : null;
        return Pokemon(
          id: id,
          name: name,
          health: health,
          type1: type1,
          type2: type2,
          attack: attack,
          defense: defense,
          speed: speed,
        );
      } else {
        throw Exception('Error HTTP ${response.statusCode} al obtener el Pokémon con ID $id');
      }
    } catch (e) {
      print('¡Ups! Error al procesar el Pokémon con ID $id: $e ❌');
      rethrow;
    }
  }

  static Future<Pokemon> getPokemonByName(String name) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pokemon/${name.toLowerCase()}'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final id = data['id'];
        final name = data['name'];
        final stats = data['stats'];
        final health = stats[0]['base_stat'];
        final attack = stats[1]['base_stat'];
        final defense = stats[2]['base_stat'];
        final speed = stats[5]['base_stat'];
        final types = data['types'];
        final type1 = types[0]['type']['name'];
        final type2 = types.length > 1 ? types[1]['type']['name'] : null;
        return Pokemon(
          id: id,
          name: name,
          health: health,
          type1: type1,
          type2: type2,
          attack: attack,
          defense: defense,
          speed: speed,
        );
      } else {
        throw Exception('Error HTTP ${response.statusCode} al obtener el Pokémon $name');
      }
    } catch (e) {
      print('¡Ups! Error al procesar el Pokémon $name: $e ❌');
      rethrow;
    }
  }

  static Future<List<Pokemon>> getFirst50Pokemon() async {
    final List<Pokemon> pokemonList = [];
    final futures = <Future<Pokemon>>[];
    for (int id = 1; id <= 50; id++) {
      futures.add(getPokemon(id));
    }
    pokemonList.addAll(await Future.wait(futures));
    return pokemonList;
  }

  static Future<List<Pokemon>> getLegendaryPokemon() async {
    final List<Pokemon> legendaryPokemon = [];
    int offset = 0;
    const limit = 100;
    bool hasMore = true;
    while (hasMore) {
      final response = await http.get(Uri.parse('$baseUrl/pokemon-species?offset=$offset&limit=$limit'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final speciesList = data['results'] as List;
        final futures = <Future<Pokemon?>>[];
        for (var species in speciesList) {
          final speciesUrl = species['url'];
          futures.add(_getSpeciesDetails(speciesUrl));
        }
        final results = await Future.wait(futures);
        for (var pokemon in results) {
          if (pokemon != null) {
            legendaryPokemon.add(pokemon);
          }
        }
        hasMore = data['next'] != null;
        offset += limit;
      } else {
        throw Exception('Error HTTP ${response.statusCode} al obtener especies de Pokémon');
      }
    }
    return legendaryPokemon;
  }

  static Future<Pokemon?> _getSpeciesDetails(String speciesUrl) async {
    try {
      final speciesResponse = await http.get(Uri.parse(speciesUrl));
      if (speciesResponse.statusCode == 200) {
        final speciesData = jsonDecode(speciesResponse.body);
        if (speciesData['is_legendary'] == true) {
          final id = speciesData['id'];
          return await getPokemon(id);
        }
      } else {
        throw Exception('Error HTTP ${speciesResponse.statusCode} al obtener detalles de la especie');
      }
    } catch (e) {
      print('¡Ups! Error al procesar detalles de la especie: $e ❌');
      return null;
    }
    return null;
  }
}