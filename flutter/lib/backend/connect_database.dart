import 'package:postgres/postgres.dart';

final connection = PostgreSQLConnection(
  'localhost',
  5432,
  'test1',
  username: 'postgres',
  password: 'abc123',
);

Future<void> createUser(String name, String dob, int weight, String email,
    int phone, String password) async {
  // ✅ Change phone to int
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

Future<void> getUsers() async {
  List<List<dynamic>> results = await connection.query('SELECT * FROM users');

  for (final row in results) {
    print('ID: ${row[0]}, Name: ${row[1]}, Email: ${row[4]}');
  }
}

Future<void> main() async {
  try {
    await connection.open();
    print('Connected to PostgreSQL ✅');

    // ✅ Example: Create a user
    // await createUser('John Doe', '1992-04-12', 75, 'john.doe@example.com',
    //     1234567891, 'MySecurePass!123');
    await getUsers();
  } catch (e) {
    print('Error connecting to PostgreSQL ❌: $e');
  } finally {
    // Close connection only after all queries are done
    await connection.close();
    print('Connection closed 🔒');
  }
}

