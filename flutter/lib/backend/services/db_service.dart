import 'package:postgres/postgres.dart';

// Singleton class for database operations
class DbService {
  // Private constructor for singleton pattern
  DbService._internal();

  // Singleton instance
  static final DbService _instance = DbService._internal();

  // Database connection object
  late final Connection _connection;

  // Flag to track initialization status
  bool _isInitialized = false;

  // Initializes the database connection
  Future<void> init() async {
    if (_isInitialized) return; // Skip if already initialized

    _connection = await Connection.open(
      Endpoint(
        host:
            '192.168.0.29', // TODO: '10.0.2.2' only works for android studio emulator, use 'localhost' for Xcode
        database:
            'testfitness', // TODO: change this to what you have named the database in psql
        username: 'jennydoan', // TODO: change this to your postgres username
        password: 'Elgado29#', // TODO: change this to your postgres password
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );
    _isInitialized = true;
  }

  factory DbService() => _instance;

  // INSERT: Executes an insert query with parameters
  Future<void> insertQuery(String sql, Map<String, dynamic> values) async {
    await _connection.execute(
      Sql.named(sql),
      parameters: values,
    );
  }

  // INSERT AND RETURN ID: Executes insert and returns the generated ID
  Future<int> insertAndReturnId(String sql, Map<String, dynamic> values) async {
    final result = await _connection.execute(
      Sql.named(sql),
      parameters: values,
    );

    // Return the ID from the first row
    return result.first[0] as int;
  }

  // READ: Executes a select query and returns results
  Future<List<ResultRow>> readQuery(String sql,
      [Map<String, dynamic>? values]) async {
    final result = await _connection.execute(
      Sql.named(sql),
      parameters: values ?? {},
    );

    return result.toList();
  }

  // UPDATE: Executes an update query and returns number of affected rows
  Future<int> updateQuery(String sql, Map<String, dynamic> values) async {
    final affected = await _connection.execute(
      Sql.named(sql),
      parameters: values,
    );
    return affected.length;
  }

  // DELETE: Executes a delete query and returns number of affected rows
  Future<int> deleteQuery(String sql, Map<String, dynamic> values) async {
    final affected = await _connection.execute(
      Sql.named(sql),
      parameters: values,
    );
    return affected.length;
  }
}

// Global instance of DbService
final dbService = DbService();
