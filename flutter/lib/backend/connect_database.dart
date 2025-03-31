import 'package:postgres/postgres.dart';

//////////////////////////////////////////// still fixing
void main() async {
  final connection = PostgreSQLConnection(
    'localhost',
    5432,
    'test1',
    username: 'postgres',
    password: 'abc123',
  );

  try {
    await connection.open();
    print('Connected to PostgreSQL ✅');

    List<List<dynamic>> results = await connection.query('SELECT * FROM users');

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

// TODO : get friends' posts, order by date posted
// TODO: get own workouts, order by date posted
// TODO: insert new workout and activities
// TODO: count achievements
// TODO: count login streak
// TODO: get user profile information
