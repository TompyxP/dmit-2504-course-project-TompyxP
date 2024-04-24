// ignore_for_file: no_logic_in_create_state, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import '../data-models/player/player_model.dart';
import '../services/ifpa-service.dart';
import '../services/db-service.dart';
import './search.dart';

final formKey = GlobalKey<FormState>();
final TextEditingController textEditingController = TextEditingController();

class PlayerView extends StatefulWidget {
  final int playerId;

  const PlayerView({Key? key, required this.playerId}) : super(key: key);

  @override
  PlayerViewState createState() => PlayerViewState(playerId: playerId);
}

class PlayerViewState extends State<PlayerView> {
  final int playerId;
  final IfpaService ifpaService = IfpaService();
  final SQFliteDbService databaseService = SQFliteDbService();
  late Future<PlayerModel> player;

  PlayerViewState({Key? key, required this.playerId});

  @override
  void initState() {
    super.initState();
    getOrInitDatabase();
    player = getPlayerFromApi();
  }

  void getOrInitDatabase() async {
    await databaseService.getOrCreateDatabaseHandle();
  }

  Future<PlayerModel> getPlayerFromApi() async {
    try {
      var apiPlayer = await ifpaService.getPlayerById(playerId);
      return PlayerModel.fromJson(apiPlayer);
    } catch (e) {
      print('PlayerView getPlayerFromApi catch: $e');
    }
    throw 'Error getting player';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<PlayerModel>(
                future: player,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(
                            'Player ID: ${snapshot.data!.player.playerID}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Name: ${snapshot.data!.player.firstName} ${snapshot.data!.player.lastName}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'City: ${snapshot.data!.player.city == '' ? 'Unknown' : snapshot.data!.player.city}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'State: ${snapshot.data!.player.state == '' ? 'Unknown' : snapshot.data!.player.state}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Country: ${snapshot.data!.player.countryName}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Age: ${snapshot.data!.player.age == 0 ? 'Unknown' : snapshot.data!.player.age}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Current WPPR Rank: ${snapshot.data!.playerStats.currentRank}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Last Month Rank: ${snapshot.data!.playerStats.lastMonthRank}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Last Year Rank: ${snapshot.data!.playerStats.lastYearRank}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Highest Rank: ${snapshot.data!.playerStats.highestRank}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Highest Rank Date: ${snapshot.data!.playerStats.highestRankDate}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Current WPPR Points: ${snapshot.data!.playerStats.currentWPPRPoints}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          // Add more player stats as needed
                          ButtonBar(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  addToFavorites(snapshot.data!);
                                },
                                child: const Text('Add to Favorites'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchView(
                                          playerOneId:
                                              snapshot.data!.player.playerID,
                                          pvpSearch: true),
                                    ),
                                  );
                                },
                                child: const Text('Compare'),
                              ),
                            ],
                          )
                        ]));
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const Center(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator())
                      ]));
                }),
          ],
        ),
      ),
    );
  }

  Future<void> addToFavorites(PlayerModel player) async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                'Do you want to add ${player.player.firstName} ${player.player.lastName} to your favorites?'),
            contentPadding: const EdgeInsets.all(5.0),
            actions: <Widget>[
              TextButton(
                child: const Text("Confirm"),
                onPressed: () async {
                  if (player.player.playerID != 0) {
                    try {
                      var dbPlayer = {'playerId': player.player.playerID};
                      await databaseService.insertPlayer(dbPlayer);
                      await databaseService.printAllFavoritePlayers();
                    } catch (e) {
                      print('PlayerView addToFavorites catch: $e');
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
