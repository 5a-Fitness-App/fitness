import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/backend/services/db_service.dart';
import 'package:postgres/postgres.dart';

void main() {
  late DbService dbService;
  const testHost = 'localhost'; // or your test database host

  setUpAll(() async {
    dbService = DbService();
    await dbService.init(testHost);
  });

  // Close after all tests
  tearDownAll(() async {
    if (dbService.isInitialized) {
      await dbService.connection.close();
    }
  });

  // Clean tables before each test
  setUp(() async {
    await dbService.connection.execute('DROP TABLE IF EXISTS test_table');
  });

  test('Successful database connection', () async {
    try {
      // Verify connection is established
      expect(dbService.isInitialized, isTrue);

      print('✅ Successfully connected to database at $testHost');
    } catch (e) {
      fail('Failed to connect to database: $e');
    }
  });

  test('Successful readQuery() method', () async {
    try {
      final result = await dbService.readQuery('SELECT 1 as test_value');

      expect(result, isA<List<ResultRow>>());

      List<Map<String, dynamic>> resultMap =
          result.map((row) => {'test_value': row[0]}).toList();

      expect(resultMap.first['test_value'], 1);

      print('✅ Simple readQuery executed successfully');
    } catch (e) {
      fail('Failed to execute readQuery method(): $e');
    }
  });

  test('Successful updateQuery() method', () async {
    try {
      await dbService.connection.execute('''
      CREATE TABLE IF NOT EXISTS test_table (
        id SERIAL PRIMARY KEY,
        name TEXT,
        value INTEGER
      )
    ''');
      await dbService.connection.execute(
        '''INSERT INTO test_table (name, value) VALUES ('test', 123)''',
      );

      final affectedRows = await dbService.updateQuery(
        'UPDATE test_table SET value = @newValue WHERE name = @name RETURNING *',
        {'newValue': 456, 'name': 'test'},
      );

      expect(affectedRows, greaterThan(0));

      // Verify the update
      final result = await dbService.connection
          .execute('''SELECT value FROM test_table WHERE name = 'test';''');

      expect(result.first[0], 456);
      print('✅ Update query executed successfully');
    } catch (e) {
      fail('Failed to execute updateQuery method(): $e');
    }
  });

  test('Successful insertQuery() method', () async {
    try {
      await dbService.connection.execute('''
      CREATE TABLE IF NOT EXISTS test_table (
        id SERIAL PRIMARY KEY,
        name TEXT,
        value INTEGER
      )
    ''');
      await dbService.insertQuery(
          '''INSERT INTO test_table (name, value) VALUES (@test, @value)''',
          {'test': 'test', 'value': 123});

      // Verify the update
      final result = await dbService.connection
          .execute('''SELECT value FROM test_table WHERE name = 'test';''');

      expect(result.first[0], 123);

      print('✅ Insert query executed successfully');
    } catch (e) {
      fail('Failed to execute insertQuery method(): $e');
    }
  });

  test('Successful insertAndReturnId() method', () async {
    try {
      await dbService.connection.execute('''
      CREATE TABLE IF NOT EXISTS test_table (
        id SERIAL PRIMARY KEY,
        name TEXT,
        value INTEGER
      )
    ''');

      final testId = await dbService.insertAndReturnId(
          '''INSERT INTO test_table (name, value) VALUES (@test, @value) RETURNING id''',
          {'test': 'test', 'value': 123});

      expect(testId, 1);

      // Verify the update
      final result = await dbService.connection
          .execute('''SELECT value FROM test_table WHERE name = 'test';''');

      expect(result.first[0], 123);

      print('✅ Insert and return id query executed successfully');
    } catch (e) {
      fail('Failed to execute insertAndReturnId method(): $e');
    }
  });

  test('Successful deleteQuery() method', () async {
    try {
      await dbService.connection.execute('''
      CREATE TABLE IF NOT EXISTS test_table (
        id SERIAL PRIMARY KEY,
        name TEXT,
        value INTEGER
      )
    ''');

      await dbService.connection.execute(
        '''INSERT INTO test_table (name, value) VALUES ('test', 123)''',
      );

      // Execute deletion
      final affectedRows = await dbService.deleteQuery(
        'DELETE FROM test_table WHERE name = @name RETURNING *',
        {'name': 'test'},
      );

      // Verify that one row was deleted
      expect(affectedRows, 1);

      print('✅ Delete query executed successfully');
    } catch (e) {
      fail('Failed to execute deleteQuery method(): $e');
    }
  });
}
