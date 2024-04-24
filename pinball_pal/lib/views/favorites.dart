// ignore_for_file: todo, avoid_print, use_key_in_widget_constructors, avoid_function_literals_in_foreach_calls, use_build_context_synchronously, unused_local_variable, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinball_pal/data-models/player/player_model.dart';
import '../services/ifpa-service.dart';
import '../services/db-service.dart';
import './player.dart';

class FavoritesView extends StatefulWidget {
  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends State<FavoritesView> {
  final IfpaService ifpaService = IfpaService();
  final SQFliteDbService databaseService = SQFliteDbService();
  late Future<List<PlayerModel>> favoritePlayers;
  List<Map<String, dynamic>> dbPlayers = [];
  bool isReady = false;

  @override
  void initState() {
    getOrInitDatabaseAndDisplayAllPlayers();
    super.initState();
  }

  void getOrInitDatabaseAndDisplayAllPlayers() async {
    await databaseService.getOrCreateDatabaseHandle();
    dbPlayers = await databaseService.getAllFavoritePlayers();
    await databaseService.printAllFavoritePlayers();
    var apiPlayers = getAllFavoritePlayersFromApi();
    setState(() {
      favoritePlayers = apiPlayers;
      isReady = true;
    });
  }

  String getOrdinalSuffix(int i) {
    double j = i % 10, k = i % 100;
    if (j == 1 && k != 11) {
      return '${i}st';
    }
    if (j == 2 && k != 12) {
      return '${i}nd';
    }
    if (j == 3 && k != 13) {
      return '${i}rd';
    }
    return '${i}th';
  }

  Future<List<PlayerModel>> getAllFavoritePlayersFromApi() async {
    try {
      List<PlayerModel> playerModels = [];

      await Future.wait(dbPlayers.map((player) async {
        var apiPlayer =
            await ifpaService.getPlayerById(int.parse(player['playerId']));
        playerModels.add(PlayerModel.fromJson(apiPlayer));
      }));
      return Future.value(playerModels);
    } catch (e) {
      print('HomeView getAllFavoritePlayersFromApi catch: $e');
    }
    throw 'Error getting favorite players';
  }

  @override
  Widget build(BuildContext context) {
    if (isReady) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Your Favorites',
                style: const TextStyle(fontSize: 24),
              ),
              FutureBuilder<List<PlayerModel>>(
                  future: favoritePlayers,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, index) {
                                return Card(
                                    child: ListTile(
                                        title: Text(
                                          'Rank: ${getOrdinalSuffix(snapshot.data![index].playerStats.currentRank)}',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        subtitle: Text(
                                          'Name: ${snapshot.data![index].player.firstName} ${snapshot.data![index].player.lastName}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PlayerView(
                                                            playerId: snapshot
                                                                .data![index]
                                                                .player
                                                                .playerID),
                                                  ),
                                                );
                                              },
                                              child: Text('Stats'),
                                            ),
                                            const SizedBox(width: 10),
                                            ElevatedButton(
                                                onPressed: () {
                                                  removeFromFavorites(
                                                      snapshot.data![index]);
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  size: 20,
                                                )),
                                          ],
                                        )));
                              }));
                    } else if (dbPlayers.isEmpty) {
                      return Text('No favorites added yet!');
                    }
                    return const Center(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator()
                        ]));
                  }),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
        ),
        body: Center(
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Your Favorites',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> removeFromFavorites(PlayerModel player) async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                'Do you want to remove ${player.player.firstName} ${player.player.lastName} from your favorites?'),
            contentPadding: const EdgeInsets.all(5.0),
            actions: <Widget>[
              TextButton(
                child: const Text("Confirm"),
                onPressed: () async {
                  if (player.player.playerID != 0) {
                    try {
                      var dbPlayer = {'playerId': player.player.playerID};
                      await databaseService.deletePlayer(dbPlayer);
                      getOrInitDatabaseAndDisplayAllPlayers();
                    } catch (e) {
                      print('HomeView removePlayer catch: $e');
                    }
                  }
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }
}
