import 'package:sembast/sembast.dart';
import '../models/story_model.dart';
import 'database_service.dart';

class StoryLocalDataSource {
  final DatabaseService _databaseService;

  StoryLocalDataSource(this._databaseService);

  // Save stories to local database
  Future<void> saveStories(String storeName, List<StoryModel> stories) async {
    final db = await _databaseService.database;
    final store = _databaseService.getStore(storeName);

    // Delete all existing records in this store
    await store.delete(db);

    // Save new stories (limit to first 20)
    final storiesToSave = stories.take(20).toList();
    
    for (int i = 0; i < storiesToSave.length; i++) {
      await store.record(i).put(db, storiesToSave[i].toJson());
    }
  }

  // Get stories from local database
  Future<List<StoryModel>> getStories(String storeName) async {
    final db = await _databaseService.database;
    final store = _databaseService.getStore(storeName);

    // Find all records
    final records = await store.find(db);

    // Convert to StoryModel list
    return records
        .map((record) => StoryModel.fromJson(record.value))
        .toList();
  }

  // Check if cached data exists
  Future<bool> hasCachedData(String storeName) async {
    final db = await _databaseService.database;
    final store = _databaseService.getStore(storeName);
    final count = await store.count(db);
    return count > 0;
  }

  // Clear specific store
  Future<void> clearStore(String storeName) async {
    final db = await _databaseService.database;
    final store = _databaseService.getStore(storeName);
    await store.delete(db);
  }

  // Get cached story count
  Future<int> getCachedStoryCount(String storeName) async {
    final db = await _databaseService.database;
    final store = _databaseService.getStore(storeName);
    return await store.count(db);
  }

  // Save single story
  Future<void> saveStory(String storeName, int index, StoryModel story) async {
    final db = await _databaseService.database;
    final store = _databaseService.getStore(storeName);
    await store.record(index).put(db, story.toJson());
  }

  // Get single story by index
  Future<StoryModel?> getStory(String storeName, int index) async {
    final db = await _databaseService.database;
    final store = _databaseService.getStore(storeName);
    final record = await store.record(index).get(db);
    
    if (record == null) return null;
    return StoryModel.fromJson(record);
  }
}