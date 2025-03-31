import 'package:postgres/postgres.dart';

final connection = PostgreSQLConnection(
  'localhost',
  5432,
  'test1',
  username: 'postgres',
  password: 'abc123',
);

// CREATE (Insert a new user)
Future<void> createUser(String name, String dob, int weight, String email,
    int phone, String password) async {
  await connection.query(
    '''INSERT INTO users (user_name, user_dob, user_weight, user_email, user_phone_number, user_password) 
       VALUES (@name, @dob, @weight, @email, @phone, crypt(@password, gen_salt('bf'::text)))''',
    substitutionValues: {
      'name': name,
      'dob': dob,
      'weight': weight,
      'email': email,
      'phone': phone,
      'password': password,
    },
  );
  print('User created successfully ✅');
}

// READ (Get all users)
Future<void> getUsers() async {
  List<List<dynamic>> results = await connection.query('SELECT * FROM users');

  for (final row in results) {
    print('ID: ${row[0]}, Name: ${row[1]}, Email: ${row[4]}');
  }
}

// READ (Get user by ID)
Future<void> getUserById(int userId) async {
  List<List<dynamic>> results = await connection.query(
    'SELECT * FROM users WHERE user_ID = @userId',
    substitutionValues: {'userId': userId},
  );

  if (results.isEmpty) {
    print('User not found ❌');
  } else {
    final row = results.first;
    print('ID: ${row[0]}, Name: ${row[1]}, Email: ${row[4]}');
  }
}

// UPDATE (Modify user details)
Future<void> updateUser(
    int userId, String name, int weight, String email, int phone) async {
  int affectedRows = await connection.execute(
    '''UPDATE users SET user_name = @name, user_weight = @weight, 
       user_email = @email, user_phone_number = @phone WHERE user_ID = @userId''',
    substitutionValues: {
      'userId': userId,
      'name': name,
      'weight': weight,
      'email': email,
      'phone': phone,
    },
  );

  if (affectedRows > 0) {
    print('User updated successfully ✅');
  } else {
    print('User not found ❌');
  }
}

// DELETE (Remove user)
Future<void> deleteUser(int userId) async {
  int affectedRows = await connection.execute(
    'DELETE FROM users WHERE user_ID = @userId',
    substitutionValues: {'userId': userId},
  );

  if (affectedRows > 0) {
    print('User deleted successfully ✅');
  } else {
    print('User not found ❌');
  }
}

// MAIN FUNCTION
Future<void> main() async {
  try {
    await connection.open();
    print('Connected to PostgreSQL ✅');

    //await createUser('Alice Smith', '1995-07-22', 68, 'alice.smith@example.com', 9876543210, 'SecurePass!123');
    //await getUsers();
    await getUserById(1);
    // await updateUser(1, 'Alice Updated', 70, 'alice.updated@example.com', 1234567890);
    // await deleteUser(2);
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
