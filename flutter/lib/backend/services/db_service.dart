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
        host: 'localhost',
        database: 'fitness',
        username: 'jennydoan',
        password: 'Elgado29#',
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

  // READ
  Future<List<ResultRow>> readQuery(String sql,
      [Map<String, dynamic>? values]) async {
    final result = await _connection.execute(
      Sql.named(sql),
      parameters: values ?? {},
    );
    print(result);
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
