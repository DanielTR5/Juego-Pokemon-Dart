import 'package:mysql1/mysql1.dart';

class Database {
  static Future<MySqlConnection> _getServerConnection() async {
    final settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      // password: 'tu_contraseña',
    );
    try {
      return await MySqlConnection.connect(settings);
    } catch (e) {
      print('¡Error al conectar al servidor MySQL: $e ❌ ¡Asegúrate de que XAMPP esté activo!');
      rethrow;
    }
  }

  static Future<MySqlConnection> getConnection() async {
    final settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      // password: 'tu_contraseña',
      db: 'db_pokemon',
    );
    try {
      final conn = await MySqlConnection.connect(settings);
      print('¡Base de datos encontrada! 💾 ¡Listo para continuar...!');
      return conn;
    } catch (e) {
      print('Base de datos no encontrada. ❌ ¡Intentando crearla...');
      await _createDatabase();
      try {
        final conn = await MySqlConnection.connect(settings);
        print('¡Base de datos creada exitosamente! 💾 ¡Preparada para entrenadores!');
        await _createUsersTable(conn);
        return conn;
      } catch (e) {
        print('Error al conectar a la base de datos después de crearla: $e ❌ ¡Revisa tu servidor MySQL!');
        rethrow;
      }
    }
  }

  static Future<void> _createDatabase() async {
    final conn = await _getServerConnection();
    try {
      await conn.query('CREATE DATABASE IF NOT EXISTS db_pokemon');
      print('¡Base de datos db_pokemon creada! 💾');
    } catch (e) {
      print('¡Error al crear la base de datos: $e ❌ ¡Verifica los permisos del servidor o que XAMPP esté activo!');
      rethrow;
    } finally {
      await conn.close();
    }
  }

  static Future<void> _createUsersTable(MySqlConnection conn) async {
    await conn.query('''
      CREATE TABLE IF NOT EXISTS users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(50) NOT NULL UNIQUE,
        password VARCHAR(50) NOT NULL
      )
    ''');
    print('=== Éxito === ¡Tabla de usuarios creada! ✅ ¡Listo para registrar entrenadores!');
  }
}