import 'package:postgres/postgres.dart';

final connection = PostgreSQLConnection(
  'localhost',
  5432,
  'test2',
  username: 'postgres',
  password: 'abc123',
);

// INSERT
Future<void> insertQuery(String query, Map<String, dynamic> dictionary) async {
  await connection.query(
    query,
    substitutionValues: dictionary,
  );
}

// READ
Future<List<List<dynamic>>> readQuery(String query) async {
  List<List<dynamic>> results = await connection.query(query);
  return Results;
}

// UPDATE
Future<void> updateQuery(String query, Map dictionary) async {
  int affectedRows = await connection.execute(
      query,
    substitutionValues: {
      dictionary
    },
  );
}

// DELETE
Future<Void> deleteQuery(String query, Map<String, dynamic> values) async {
  int affectedRows = await connection.execute(
    query,
    substitutionValues: values,
  );
}
