import 'dart:io';
import 'database.dart';

class Login {
  static Future<String?> promptLogin() async {
    bool isAuthenticated = false;
    String? username;
    while (!isAuthenticated) {
      stdout.write(' Ingresa tu nombre de usuario: ✅ ');
      username = stdin.readLineSync() ?? '';
      stdout.write(' Ingresa tu contraseña secreta: 🔐 ');
      String password = stdin.readLineSync() ?? '';
      if (username.isEmpty || password.isEmpty) {
        print('¡Oye! El nombre de usuario y la contraseña no pueden estar vacíos. ❌ ¡Inténtalo de nuevo!');
        continue;
      }
      isAuthenticated = await authenticateUser(username, password);
      if (isAuthenticated) {
        print('¡Login exitoso! ¡Prepárate para la aventura Pokémon, $username! ✅✅');
        return username;
      } else {
        print('Usuario o contraseña incorrectos. ❌ ¡Verifica tus datos e inténtalo de nuevo!');
      }
    }
    return null;
  }

  static Future<bool> promptRegister() async {
    stdout.write('Ingresa un nombre de usuario único: ✅ ');
    String username = stdin.readLineSync() ?? '';
    stdout.write('Crea una contraseña: 🔑 ');
    String password = stdin.readLineSync() ?? '';
    stdout.write('Confirma tu contraseña: 🔑 ');
    String confirmPassword = stdin.readLineSync() ?? '';
    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      print('¡Oye! El nombre de usuario y las contraseñas no pueden estar vacías. ❌ ¡Inténtalo de nuevo!');
      return false;
    }
    if (password != confirmPassword) {
      print('¡Las contraseñas no coinciden! ❌ ¡Asegúrate de escribir la misma contraseña!');
      return false;
    }
    final conn = await Database.getConnection();
    final checkResult = await conn.query(
      'SELECT * FROM users WHERE username = ?',
      [username],
    );
    if (checkResult.isNotEmpty) {
      print('¡Ese nombre de usuario ya está en uso! ❌ ¡Elige otro y vuelve a intentarlo!');
      await conn.close();
      return false;
    }
    await conn.query(
      'INSERT INTO users (username, password) VALUES (?, ?)',
      [username, password],
    );
    print('¡Registro exitoso! Ahora puedes iniciar sesión, $username. ✅✅');
    await conn.close();
    return true;
  }

  static Future<bool> authenticateUser(String username, String password) async {
    final conn = await Database.getConnection();
    final result = await conn.query(
      'SELECT * FROM users WHERE username = ? AND password = ?',
      [username, password],
    );
    await conn.close();
    return result.isNotEmpty;
  }
}