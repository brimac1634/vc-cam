import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static const ocrImages = 'ocr_images';
  static const stringBlocks = 'string_blocks';

  static const tableOCRImages = """
  CREATE TABLE IF NOT EXISTS $ocrImages (
        id TEXT PRIMARY KEY,
        image_url TEXT, 
        created_at TIMESTAMP, 
        edited_at TIMESTAMP
      );""";

  static const tableStringBlocks = """
  CREATE TABLE IF NOT EXISTS $stringBlocks (
        id TEXT PRIMARY key,
        ocr_image TEXT, 
        text TEXT, 
        edited_text TEXT, 
        left REAL, 
        top REAL, 
        right REAL, 
        bottom REAL, 
        is_user_created INTEGER
      );""";

  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(path.join(dbPath, 'vccam.db'),
        onCreate: (db, version) async {
      try {
        await db.execute(tableOCRImages);
        return db.execute(tableStringBlocks);
      } catch (error) {
        print(error.toString());
      }
    }, version: 2);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String query) async {
    final db = await DBHelper.database();
    return db.query(query);
  }
}
