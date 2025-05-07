import 'pokemon.dart';
import 'api_service.dart';

class Game {
  List<Pokemon> userPokemon = [];

  Future<void> seleccionarPokemon() async {
    userPokemon = await ApiService.getFirst50Pokemon();
    print('\nTus Pokémon: 🐕');
    for (var pokemon in userPokemon) {
      pokemon.mostrarInformacion();
    }
  }

  Future<void> iniciar() async {
    await seleccionarPokemon();
    print('\n¡Comienza la aventura! 🧙‍♂️🌌');
  }
}