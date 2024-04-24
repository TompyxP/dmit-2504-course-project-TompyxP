// ignore_for_file: todo, avoid_print, use_key_in_widget_constructors, avoid_function_literals_in_foreach_calls, use_build_context_synchronously, unused_local_variable, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinball_pal/data-models/rankings/rankings.dart';
import '../services/ifpa-service.dart';
import '../services/db-service.dart';
import './player.dart';
import './search.dart';
import './favorites.dart';

class HomeView extends StatefulWidget {
  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  final IfpaService ifpaService = IfpaService();
  final SQFliteDbService databaseService = SQFliteDbService();
  late Future<Rankings> topPlayers;

  @override
  void initState() {
    super.initState();
    topPlayers = getTop10PlayersFromApi();
  }

  Future<Rankings> getTop10PlayersFromApi() async {
    try {
      var apiPlayers = await ifpaService.listTop10Players();
      return Rankings.fromJson(apiPlayers);
    } catch (e) {
      print('HomeView getTop10PlayersFromApi catch: $e');
    }
    throw 'Error getting top 10 players';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pinball Pal'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchView(),
                      ),
                    );
                  },
                  child: const Text('Search'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavoritesView(),
                      ),
                    );
                  },
                  child: const Text('Favorites'),
                ),
              ],
            ),
            Text(
              'Top 10 Players',
              style: const TextStyle(fontSize: 24),
            ),
            FutureBuilder<Rankings>(
                future: topPlayers,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.rankings.length,
                            itemBuilder: (BuildContext context, index) {
                              return Card(
                                  child: ListTile(
                                      title: Text(
                                        'Rank: ${getOrdinalSuffix(snapshot.data!.rankings[index].currentWpprRank)}',
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      subtitle: Text(
                                        'Name: ${snapshot.data!.rankings[index].firstName} ${snapshot.data!.rankings[index].lastName}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      trailing: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PlayerView(
                                                  playerId: snapshot
                                                      .data!
                                                      .rankings[index]
                                                      .playerId),
                                            ),
                                          );
                                        },
                                        child: Text('Stats'),
                                      )));
                            }));
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
}
