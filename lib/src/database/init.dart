import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class DatabaseSQL {
  static const _databaseName = "makalam.db";
  static const _databaseVersion = 1;
  
  static const tblUser = "tbl_user";
  static const columnName = 'token';
  late final Database _db;

  Future <void> init() async {
    final documetsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documetsDirectory.path, _databaseName);
    _db = await openDatabase(  
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
      if (oldVersion == 1) {
        await db.execute('''
          CREATE TABLE $tblUser (
            id INTEGER PRIMARY KEY,
            token text NOT NULL
          )''');
      }}
    );
  }

  Future _onCreate(Database db, int version) async {
      await db.execute('''
        CREATE TABLE $tblUser (
        id INTEGER PRIMARY KEY,
        token text NOT NULL
        )''');
    }

  Future<int> insert(Map<String, dynamic> row) async{
      await _db.insert(tblUser, row);
      return 0;
    }

  Future<int> deleteAllRows() async {
      return await _db.delete(tblUser);
    }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
      return await _db.rawQuery('SELECT * FROM "tbl_user"');
    }
    
}