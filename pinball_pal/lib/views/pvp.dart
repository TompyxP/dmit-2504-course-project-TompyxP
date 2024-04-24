// ignore_for_file: no_logic_in_create_state, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pinball_pal/data-models/pvp/pvp_model.dart';
import 'package:pinball_pal/data-models/pvp/pvp_tournament.dart';
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                '${snapshot.data!.playerOneFirstName} ${snapshot.data!.playerOneLastName}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                '${snapshot.data!.playerTwoFirstName} ${snapshot.data!.playerTwoLastName}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                        return Column(
                                          children: [
                                            PvpCard(
                                                pvp:
                                                    snapshot.data!.pvp![index]),
                                            const SizedBox(height: 10),
                                          ],
                                        );
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

const darkColor = Color(0xFF49535C);

class PvpCard extends StatelessWidget {
  final PvpTournament pvp;

  const PvpCard({Key? key, required this.pvp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 3), // changes position of shadow
                )
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80,
                  child: Stack(
                    children: [
                      Container(
                        height: 60,
                        decoration: const BoxDecoration(
                          color: darkColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  top: 8,
                                ),
                                constraints: const BoxConstraints(
                                  maxWidth: 350,
                                ),
                                child: Text(
                                  pvp.tournamentName.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                  softWrap: true,
                                ),
                              ),
                              const SizedBox(height: 25),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12),
                      child: Text(
                        'Event: ${pvp.eventName}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: darkColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Date: \nCountry:    ',
                              style: buildMontserrat(
                                darkColor,
                              )),
                          const SizedBox(height: 16),
                          Text('P1 Finish: \nP2 Finish:',
                              style: buildMontserrat(
                                darkColor,
                              )),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pvp.eventDate.toString(),
                              style: buildMontserrat(
                                darkColor,
                              )),
                          Text(pvp.countryCode.toString(),
                              style: buildMontserrat(
                                darkColor,
                              )),
                          const SizedBox(height: 16),
                          Text(getOrdinalSuffix(pvp.playerOneFinishPosition),
                              style: buildMontserrat(
                                darkColor,
                              )),
                          Text(getOrdinalSuffix(pvp.playerTwoFinishPosition),
                              style: buildMontserrat(
                                darkColor,
                              )),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 8)
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle buildMontserrat(
    Color color, {
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: 14,
      color: color,
      fontWeight: fontWeight,
    );
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
}
