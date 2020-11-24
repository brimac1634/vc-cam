import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static const ocrImages = 'ocr_images';
  static const stringBlocks = 'string_blocks';

  static Future<void> insert(String table, Map<String, Object> data) async {
    final dbPath = await sql.getDatabasesPath();
    final sqlDb = await sql.openDatabase(
      path.join(dbPath, 'vccam.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE $ocrImages(id TEXT PRIMARY KEY, image_url TEXT, created_at TIMESTAMP, edited_at TIMESTAMP) CREATE TABLE $stringBlocks(id TEXT PRIMARY KEY, text TEXT, edited_text Text, left REAL, top REAL, right REAL, bottom REAL, is_user_created INTEGER)');
      },
    );

    await sqlDb.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }
}
