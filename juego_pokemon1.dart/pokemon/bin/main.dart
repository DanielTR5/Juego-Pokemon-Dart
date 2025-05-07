import 'dart:io';
import 'api_service.dart';
import 'login.dart';
import 'pokemon.dart';
void main() async {
  
  print('=== Bienvenido al Mundo Pokémon === 🧞🐦‍⬛🦝');
  print('¡Prepárate para convertirte en el mejor entrenador Pokemon! 🙋‍♂️');

  
  bool salir = false;
  while (!salir) {
    
    print('\n=== Menú Principal === 👋');
    print('1. Login 🧑‍💻');
    print('2. Registrarse 🖋️');
    print('3. Salir 🚷');
    stdout.write('Selecciona una opción: ');

    
    String? opcion = stdin.readLineSync();

    
    switch (opcion) {
      case '1': 
        print('\n¡Preparándote para iniciar sesión! 🧑‍💻');
        String? username = await Login.promptLogin();
        if (username != null) {
          await _mostrarMenuJuego(username); 
        }
        break;
      case '2': 
        print('\n¡Vamos a crear tu cuenta! 🧑‍💻');
        await Login.promptRegister();
        break;
      case '3': 
        print('\n¡Saliendo del juego! ¡Vuelve pronto! 👋🚷');
        salir = true;
        break;
      default: 
        print('\n¡Opción no válida! ❌ Por favor, elige 1, 2 o 3.');
        break;
    }
  }
}


Future<void> _mostrarMenuJuego(String username) async {
  bool salir = false;
  while (!salir) {
    
    print('\n=== Menú del Juego === 🌟');
    print('1. Jugar 🧙‍♂️');
    print('2. Ver los 50 primeros Pokémon 🐕');
    print('3. Mostrar Pokémon legendarios 🧬');
    print('4. Salir 🚷');
    stdout.write('Selecciona una opción, $username: ');

    
    String? opcion = stdin.readLineSync();

    
    switch (opcion) {
      case '1': 
        print('\n¡Preparándote para formar tu equipo Pokémon, $username! 🐒');
        await _seleccionarPokemonUsuario(username);
        break;
      case '2':
        print('\n¡Obteniendo los 50 primeros Pokémon! 🐕');
        try {
          final pokemonList = await ApiService.getFirst50Pokemon();
          print('\n=== Lista de los 50 primeros Pokémon === 🐕');
          for (var pokemon in pokemonList) {
            pokemon.mostrarInformacion();
          }
        } catch (e) {
          print('No se pudieron obtener los Pokémon: $e ❌ ¡Asegúrate de estar conectado a Internet!');
        }
        break;
      case '3':
        print('\n¡Obteniendo los Pokémon legendarios! 🧬');
        try {
          final legendaryPokemon = await ApiService.getLegendaryPokemon();
          if (legendaryPokemon.isEmpty) {
            print('¡No se encontraron Pokémon legendarios! ❌ ¡Inténtalo de nuevo más tarde!');
          } else {
            print('\n=== Lista de Pokémon Legendarios === 🧬');
            for (var pokemon in legendaryPokemon) {
              pokemon.mostrarInformacion();
            }
          }
        } catch (e) {
          print('No se pudieron obtener los Pokémon legendarios: $e ❌ ¡Asegúrate de estar conectado a Internet!');
        }
        break;
      case '4':
        print('\n¡Volviendo al menú principal! 🚷');
        salir = true;
        break;
      default:
        print('\n¡Opción no válida! ❌ Por favor, elige 1, 2, 3 o 4.');
        break;
    }
  }
}

Future<void> _seleccionarPokemonUsuario(String username) async {
  final List<Pokemon> equipoPokemon = [];
  print('\n¡Es hora de elegir tu equipo, $username! 💪 Escribe los nombres de 3 Pokémon (uno por uno).');
  print('Ejemplo: 🦒Bulbasaur, 🐭 Pikachu, 🐢 Squirtle, 🐉 Charizard, 🦆 Psyduck, 🐍 Ekans, 🐱 Meowth, 🐸 Bulbasaur, 🦇 Zubat, 🐧 Piplup, 🦎 Charmander, 🐦 Pidgey, 🐙 Tentacool');

  for (int i = 1; i <= 3; i++) {
    stdout.write('Ingresa el nombre del Pokémon #$i: ');
    String? nombre = stdin.readLineSync();

    if (nombre == null || nombre.trim().isEmpty) {
      print('¡El nombre no puede estar vacío! ❌ ¡Inténtalo de nuevo, $username!');
      i--;
      continue;
    }

    try {
      final pokemon = await ApiService.getPokemonByName(nombre.trim());
      equipoPokemon.add(pokemon);
      print('¡${pokemon.name} se ha unido a tu equipo! 🔥🌟');
    } catch (e) {
      print('¡No se encontró el Pokémon "$nombre"! ❌ ¡Asegúrate de escribir el nombre correctamente, $username!');
      i--; 
      continue;
    }
  }

  print('\n=== ¡Tu equipo Pokémon está listo, $username! === ⚡');
  print('Tus Pokémon:');
  for (var pokemon in equipoPokemon) {
    pokemon.mostrarInformacion();
  }

  
  print('\n=== ¡Bienvenido a tu aventura Pokémon, $username! === ⚡🌟');
  print('¡Has formado un equipo increíble $username!🔥');
  print('En el vasto mundo Pokémon, te esperan batallas épicas, amistades inseparables y desafíos legendarios.');
  print('Prepárate para explorar, combatir y convertirte en una leyenda... ¡Tu viaje comienza ahora! 🌌');
  print('\n=== Mantenimiento === ¡El Juego se encuentra en mantenimiento...!¡El juego se cerrará en 10 segundos! ⏳');
  for (int i = 10; i >= 1; i--) {
    print('=== Cuenta Regresiva === $i...');
    await Future.delayed(Duration(seconds: 1));
  }
  print('=== Despedida === ¡Hora de partir! ¡Vuelve pronto, $username! Hecho por Daniel Torres Rey 🙌');
  exit(0);
}