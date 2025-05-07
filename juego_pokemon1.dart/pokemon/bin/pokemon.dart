class Pokemon {
  final int id;
  final String name;
  final int health;
  final String type1;
  final String? type2;
  final int attack;
  final int defense;
  final int speed;

  Pokemon({
    required this.id,
    required this.name,
    required this.health,
    required this.type1,
    this.type2,
    required this.attack,
    required this.defense,
    required this.speed,
  });

  void mostrarInformacion() {
    if (type2 != null) {
      print('=== Pokémon === ID: $id, Nombre: $name, Salud: $health, Tipo 1: $type1, Tipo 2: $type2, Ataque: $attack, Defensa: $defense, Velocidad: $speed');
    } else {
      print('=== Pokémon === ID: $id, Nombre: $name, Salud: $health, Tipo: $type1, Ataque: $attack, Defensa: $defense, Velocidad: $speed');
    }
  }
}