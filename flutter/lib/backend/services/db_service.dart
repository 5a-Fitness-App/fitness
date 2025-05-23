import 'package:postgres/postgres.dart';

// Singleton class for database operations
class DbService {
  // Private constructor for singleton pattern
  DbService._internal();

  // Singleton instance
  static final DbService _instance = DbService._internal();

  // Database connection object
  late final Connection connection;

  // Flag to track initialization status
  bool isInitialized = false;

  // Initializes the database connection
  Future<void> init(String host) async {
    if (isInitialized) return; // Skip if already initialized

    connection = await Connection.open(
      Endpoint(
        host: host, // TODO: change the host id in main.dart
        database:
            'testfitness', // TODO: change this to what you have named the database in psql
        username: 'jennydoan', // TODO: change this to your postgres username
        password: 'Elgado29#', // TODO: change this to your postgres password
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );
    isInitialized = true;
  }

  factory DbService() => _instance;

  // INSERT: Executes an insert query with parameters
  Future<void> insertQuery(String sql, Map<String, dynamic> values) async {
    await connection.execute(
      Sql.named(sql),
      parameters: values,
    );
  }

  // INSERT AND RETURN ID: Executes insert and returns the generated ID
  Future<int> insertAndReturnId(String sql, Map<String, dynamic> values) async {
    final result = await connection.execute(
      Sql.named(sql),
      parameters: values,
    );

    // Return the ID from the first row
    return result.first[0] as int;
  }

  // READ: Executes a select query and returns results
  Future<List<ResultRow>> readQuery(String sql,
      [Map<String, dynamic>? values]) async {
    final result = await connection.execute(
      Sql.named(sql),
      parameters: values ?? {},
    );

    return result.toList();
  }

  // UPDATE: Executes an update query and returns number of affected rows
  Future<int> updateQuery(String sql, Map<String, dynamic> values) async {
    final affected = await connection.execute(
      Sql.named(sql),
      parameters: values,
    );
    return affected.length;
  }

  // DELETE: Executes a delete query and returns number of affected rows
  Future<int> deleteQuery(String sql, Map<String, dynamic> values) async {
    final affected = await connection.execute(
      Sql.named(sql),
      parameters: values,
    );
    return affected.length;
  }
}

// Global instance of DbService
final dbService = DbService();
