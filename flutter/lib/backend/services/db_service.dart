import 'package:postgres/postgres.dart';

class DbService {
  DbService._internal();
  static final DbService _instance = DbService._internal();

  late final Connection _connection;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    _connection = await Connection.open(
      Endpoint(
        host:
            '10.0.2.2', // TODO: '10.0.2.2' only works for android studio emulator, use 'localhost' for Xcode
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

  // INSERT
  Future<void> insertQuery(String sql, Map<String, dynamic> values) async {
    await _connection.execute(
      Sql.named(sql),
      parameters: values,
    );
  }

  // INSERT AND RETURN ID
  Future<int> insertAndReturnId(String sql, Map<String, dynamic> values) async {
    final result = await _connection.execute(
      Sql.named(sql),
      parameters: values,
    );

    // Return the ID from the first row
    return result.first[0] as int;
  }

  // READ
  Future<List<ResultRow>> readQuery(String sql,
      [Map<String, dynamic>? values]) async {
    final result = await _connection.execute(
      Sql.named(sql),
      parameters: values ?? {},
    );

    return result.toList();
  }

  // UPDATE
  Future<int> updateQuery(String sql, Map<String, dynamic> values) async {
    final affected = await _connection.execute(
      Sql.named(sql),
      parameters: values,
    );
    return affected.length;
  }

  // DELETE
  Future<int> deleteQuery(String sql, Map<String, dynamic> values) async {
    final affected = await _connection.execute(
      Sql.named(sql),
      parameters: values,
    );
    return affected.length;
  }
}

final dbService = DbService();
