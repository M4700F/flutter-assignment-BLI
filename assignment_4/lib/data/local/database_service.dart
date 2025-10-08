import 'dart:async';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_memory.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  // Store names for different story types
  static const String topStoriesStore = 'top_stories';
  static const String bestStoriesStore = 'best_stories';
  static const String newStoriesStore = 'new_stories';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // For simplicity, use memory database for all platforms
    // This avoids platform-specific file system issues
    return await databaseFactoryMemory.openDatabase('hacker_news.db');
  }

  // Get store based on story type
  StoreRef<int, Map<String, dynamic>> getStore(String storeName) {
    return intMapStoreFactory.store(storeName);
  }

  // Close database
  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  // Clear all data
  Future<void> clearAllData() async {
    final db = await database;
    await getStore(topStoriesStore).delete(db);
    await getStore(bestStoriesStore).delete(db);
    await getStore(newStoriesStore).delete(db);
  }
}