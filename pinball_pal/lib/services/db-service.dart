// ignore_for_file: todo, avoid_print, library_prefixes, avoid_function_literals_in_foreach_calls, file_names, unused_import

import 'package:path/path.dart' as pathPackage;
import 'package:sqflite/sqflite.dart' as sqflitePackage;

class SQFliteDbService {
  late sqflitePackage.Database? db;
  late String path;

  Future<void> getOrCreateDatabaseHandle() async {
    try {
      var dbPath = await sqflitePackage.getDatabasesPath();
      path = pathPackage.join(dbPath, 'favorite_players.db');
      db = await sqflitePackage.openDatabase(
        path,
        onCreate: (sqflitePackage.Database db1, int version) async {
          await db1.execute(
            "CREATE TABLE FavoritePlayers(playerId TEXT PRIMARY KEY)",
          );
        },
        version: 1,
      );
      print('db = $db');
    } catch (e) {
      print('SQFliteDbService getOrCreateDatabaseHandle: $e');
    }
  }

  Future<void> printAllFavoritePlayers() async {
    try {
      List<Map<String, dynamic>> players = await getAllFavoritePlayers();
      if (players.isEmpty) {
        print('No players in the database');
      } else {
        players.forEach((player) {
          print('Player: $player');
        });
      }
    } catch (e) {
      print('SQFliteDbService printAllFavoritePlayers: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllFavoritePlayers() async {
    try {
      final List<Map<String, dynamic>> players = await db!.query('FavoritePlayers');
      return players;
    } catch (e) {
      print('SQFliteDbService getAllFavoritePlayers: $e');
      return <Map<String, dynamic>>[];
    }
  }

  Future<void> deleteDb() async {
    try {
      await sqflitePackage.deleteDatabase(path);
      db = null;
    } catch (e) {
      print('SQFliteDbService deleteDb: $e');
    }
  }

  Future<void> insertPlayer(Map<String, dynamic> player) async {
    try {
      await db!.insert(
        'FavoritePlayers',
        player,
        conflictAlgorithm: sqflitePackage.ConflictAlgorithm.replace,
      );
    
    } catch (e) {
      print('SQFliteDbService insertPlayer: $e');
    }
  }

  Future<void> updatePlayer(Map<String, dynamic> player) async {
    try {
      await db!.update(
        'FavoritePlayers',
        player,
        where: 'playerId = ?',
        whereArgs: [player['playerId']],
      );
      
    } catch (e) {
      print('SQFliteDbService updatePlayer: $e');
    }
  }

  Future<void> deletePlayer(Map<String, dynamic> player) async {
    try {
      await db!.delete(
        'FavoritePlayers',
        where: 'playerId = ?',
        whereArgs: [player['playerId']],
      );
      
    } catch (e) {
      print('SQFliteDbService deletePlayer: $e');
    }
  }
}
