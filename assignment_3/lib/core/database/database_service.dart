import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

part 'database_service.g.dart';

class DatabaseService {
  Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final dbPath = join(appDir.path, 'notes_app.db');
      return await databaseFactoryIo.openDatabase(dbPath);
    } catch (e) {
      // Fallback for platforms where getApplicationDocumentsDirectory is not available
      // This can happen on web or some Linux configurations
      print('Warning: Could not get documents directory, using memory database: $e');
      return await databaseFactoryMemory.openDatabase('notes_app.db');
    }
  }
  
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}

@riverpod
DatabaseService databaseService(Ref ref) {
  final service = DatabaseService();
  ref.onDispose(() => service.close());
  return service;
}