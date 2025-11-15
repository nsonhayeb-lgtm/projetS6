import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'note.dart'; 


class NotesDatabase {
  
  static final NotesDatabase _instance = NotesDatabase._internal();
  factory NotesDatabase() => _instance;
  
  NotesDatabase._internal();

  static Database? _database;
  static const String tableName = 'notes';

  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  
  Future<Database> _initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'notes_database.db');

    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  
  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titre TEXT,
        contenu TEXT,
        dateCreation INTEGER
      )
    ''');
  }

  // CREATE: Insérer une nouvelle note
  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert(
      tableName,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // READ: Récupérer toutes les notes
  Future<List<Note>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: 'dateCreation DESC', 
    );

    // Si la liste est vide, retournez une liste vide pour éviter les erreurs.
    if (maps.isEmpty) {
      return [];
    }

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  // UPDATE: Mettre à jour une note existante
  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      tableName,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // DELETE: Supprimer une note
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

 
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null; 
  }
}