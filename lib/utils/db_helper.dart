import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static const ocrImages = 'ocr_images';
  static const stringBlocks = 'string_blocks';

  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(path.join(dbPath, 'vccam.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE $ocrImages(id TEXT PRIMARY KEY, image_url TEXT, created_at TIMESTAMP, edited_at TIMESTAMP) CREATE TABLE $stringBlocks(id TEXT PRIMARY KEY, ocr_image TEXT, text TEXT, edited_text Text, left REAL, top REAL, right REAL, bottom REAL, is_user_created INTEGER)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }
}
