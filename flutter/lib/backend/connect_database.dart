import 'package:postgres/postgres.dart';

//////////////////////////////////////////// still fixing
void main() async {
  final connection = PostgreSQLConnection(
    'localhost',
    5432,
    'my_database',
    username: 'postgres',
    password: 'your_password',
  );

  try {
    await connection.open();
    print('Connected to PostgreSQL ✅');

    List<List<dynamic>> results =
        await connection.query('SELECT * FROM my_table');

    for (final row in results) {
      print(row);
    }
  } catch (e) {
    print('Error connecting to PostgreSQL ❌: $e');
  } finally {
    await connection.close();
    print('Connection closed 🔒');
  }
}
