import 'package:sqflite/sqlite_api.dart';
import './barang.dart';
import '../db/database_helper.dart';

class CRUD {
  static const todoTable = 'barang';
  static const id = 'id';
  static const nama = 'nama';
  static const harga = 'harga';
  static const barcode = 'barcode';
  AccessDatabase dbHelper = new AccessDatabase();
  Future<int> insert(Barang todo) async {
    Database db = await dbHelper.initDb();
    final sql = '''INSERT INTO ${CRUD.todoTable}
    (
    
      ${CRUD.nama},
      ${CRUD.harga},
      ${CRUD.barcode}
    )
    VALUES (?,?,?)''';
    List<dynamic> params = [todo.nama, todo.harga, todo.barcode];
    final result = await db.rawInsert(sql, params);
    return result;
  }

  Future<int> delete(Barang todo) async {
    Database db = await dbHelper.initDb();
    final sql = '''DELETE FROM ${CRUD.todoTable}
    WHERE ${CRUD.id} = ?
    ''';
    List<dynamic> params = [todo.id];
    final result = await db.rawDelete(sql, params);
    return result;
  }

  Future<List<Barang>> getBarangList() async {
    Database db = await dbHelper.initDb();
    final sql = '''SELECT * FROM ${CRUD.todoTable}''';
    final data = await db.rawQuery(sql);
    List<Barang> todos = List();
    for (final node in data) {
      final todo = Barang.fromMap(node);
      todos.add(todo);
    }
    return todos;
  }

  Future<int> update(Barang todo) async {
    Database db = await dbHelper.initDb();
    int count = await db
        .update('barang', todo.toMap(), where: 'id=?', whereArgs: [todo.id]);
    return count;
  }

  Future<List<Barang>> cariBarang(String nama, String barcode) async {
    Database db = await dbHelper.initDb();
    if (nama == null) {
      final data =
          await db.query("barang", where: "barcode = ?", whereArgs: [barcode]);
      print(data);
      List<Barang> items = List();
      for (final item in data) {
        final isi = Barang.fromMap(item);
        items.add(isi);
      }
      return items;
    } else {
      final data = await db
          .query("barang", where: "nama LIKE ?", whereArgs: ['%$nama%']);
      print(data);
      List<Barang> items = List();
      for (final item in data) {
        final isi = Barang.fromMap(item);
        items.add(isi);
      }
      return items;
    }
  }
}
