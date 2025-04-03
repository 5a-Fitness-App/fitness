import 'package:postgres/postgres.dart';

final connection = PostgreSQLConnection(
  'localhost',
  5432,
  'test2',
  username: 'postgres',
  password: 'abc123',
);

String currentQuery = 'SELECT * from users';
// 8. Create a Workout Post
// 12. View Friends' Workouts
String viewFriendsWorkouts =
    '''SELECT w.workout_ID, w.user_ID, u.user_name, w.workout_title, w.workout_date_time, w.workout_duration, w.workout_calories_burnt 
  FROM workouts w
  JOIN friends f ON (w.user_ID = f.friend_ID OR w.user_ID = f.user_ID)
  JOIN users u ON w.user_ID = u.user_ID
  WHERE f.user_ID = 1  -- Replace with logged-in user's ID
  ORDER BY w.workout_date_time DESC;''';

// READ (Get all users)
Future<List<List<dynamic>>> readQuery(query) async {
  List<List<dynamic>> results = await connection.query(query);
  return results;
}

Future<void> main() async {
  try {
    await connection.open();
    print('Connected to PostgreSQL ✅');

    var bob = await readQuery(viewFriendsWorkouts);
    print(bob);
  } catch (e) {
    print('Error connecting to PostgreSQL ❌: $e');
  } finally {
    await connection.close();
    print('Connection closed 🔒');
  }
}
