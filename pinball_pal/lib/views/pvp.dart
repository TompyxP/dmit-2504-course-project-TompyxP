// ignore_for_file: no_logic_in_create_state, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pinball_pal/data-models/pvp/pvp_model.dart';
import '../services/ifpa-service.dart';
import '../services/db-service.dart';

class PvpView extends StatefulWidget {
  final int playerOneId;
  final int playerTwoId;

  const PvpView(
      {Key? key, required this.playerOneId, required this.playerTwoId})
      : super(key: key);

  @override
  PvpViewState createState() =>
      PvpViewState(playerOneId: playerOneId, playerTwoId: playerTwoId);
}

class PvpViewState extends State<PvpView> {
  final int playerOneId;
  final int playerTwoId;
  final IfpaService ifpaService = IfpaService();
  final SQFliteDbService databaseService = SQFliteDbService();
  late Future<PvpModel> pvp;

  PvpViewState(
      {Key? key, required this.playerOneId, required this.playerTwoId});

  @override
  void initState() {
    super.initState();
    pvp = getPvpFromApi();
  }

  Future<PvpModel> getPvpFromApi() async {
    try {
      var apiPlayer =
          await ifpaService.comparePlayersById(playerOneId, playerTwoId);
      return PvpModel.fromJson(apiPlayer);
    } catch (e) {
      print('PvpView getPvpFromApi catch: $e');
    }
    throw 'Error getting pvp';
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
        title: const Text('Player vs Player'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<PvpModel>(
                future: pvp,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Player One',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                'Player Two',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Id: ${snapshot.data!.playerOneId}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Id: ${snapshot.data!.playerTwoId}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Name: ${snapshot.data!.playerOneFirstName} ${snapshot.data!.playerOneLastName}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Name: ${snapshot.data!.playerTwoFirstName} ${snapshot.data!.playerTwoLastName}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Country: ${snapshot.data!.playerOneCountryCode}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Country: ${snapshot.data!.playerTwoCountryCode}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                              child: snapshot.data!.pvp!.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: snapshot.data!.pvp!.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return Card(
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                              ListTile(
                                                title: Text(
                                                    'Tournament: ${snapshot.data!.pvp![index].tournamentName}',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                subtitle: Text(
                                                    'Event: ${snapshot.data!.pvp![index].eventName}'),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                      'Date: ${snapshot.data!.pvp![index].eventDate}'),
                                                  Text(
                                                      'Country: ${snapshot.data!.pvp![index].countryCode}'),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  Text(
                                                      'P1 Finish: ${getOrdinalSuffix(snapshot.data!.pvp![index].playerOneFinishPosition)}'),
                                                  Text(
                                                      'P2 Finish: ${getOrdinalSuffix(snapshot.data!.pvp![index].playerTwoFinishPosition)}'),
                                                ],
                                              ),
                                            ]));
                                      })
                                  : const Center(
                                      child: Text(
                                        'No tournament history found',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ))
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
}
