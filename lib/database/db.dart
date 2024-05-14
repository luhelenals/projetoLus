import 'package:projeto/models/despesa.dart';
import 'package:projeto/repositories/gastomes_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DB {
  DB._();
  static final DB getInstance = DB._();
  static Database? _database;

  Future<Database> get database async {
    return _database ??= await initDatabase();
  }

  static get() async {
    return await DB.getInstance.database;
  }

  initDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), 'banco.db'),
        version: 1, onCreate: (db, versao) async {
      await db.execute(gastos);
    });
  }

  setupGastos(db) {
    for (Despesa despesa in GastoMensalRepository.setupGastos()) {
      db.insert('gastos', {
        'nome': despesa.descricao,
        'mes': despesa.data,
        'valor': despesa.valor,
        'categroia': despesa.categoria,
      });
    }
  }

  String get gastos => '''
  CREATE TABLE gastos(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    mes DATE,
    nome TEXT,
    valor DOUBLE,
    categoria TEXT,
  );
''';
}
