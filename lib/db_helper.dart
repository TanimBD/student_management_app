import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('students.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE students ( 
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      name TEXT NOT NULL,
      email TEXT NOT NULL,
      phone TEXT NOT NULL,
      location TEXT NOT NULL
    )
    ''');
  }

  Future<List<Student>> getStudents() async {
    final db = await instance.database;
    final result = await db.query('students');
    return result.map((json) => Student.fromJson(json)).toList();
  }

  Future<int> addStudent(Student student) async {
    final db = await instance.database;
    return await db.insert('students', student.toJson());
  }

  Future<int> updateStudent(Student student) async {
    final db = await instance.database;
    return await db.update(
      'students',
      student.toJson(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future<int> deleteStudent(int id) async {
    final db = await instance.database;
    return await db.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class Student {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String location;

  Student({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'location': location,
  };

  static Student fromJson(Map<String, Object?> json) => Student(
    id: json['id'] as int?,
    name: json['name'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    location: json['location'] as String,
  );
}
