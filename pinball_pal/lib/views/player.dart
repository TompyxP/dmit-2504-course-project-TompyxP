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
                          PlayerCard(player: snapshot.data!),
                          const SizedBox(height: 10),
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

const darkColor = Color(0xFF49535C);

class PlayerCard extends StatelessWidget {
  final PlayerModel player;

  const PlayerCard({Key? key, required this.player}) : super(key: key);

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
                  spreadRadius: 5,
                  blurRadius: 7,
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
                  height: 150,
                  child: Stack(
                    children: [
                      ClipPath(
                        clipper: AvatarClipper(),
                        child: Container(
                          height: 100,
                          decoration: const BoxDecoration(
                            color: darkColor,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 11,
                        top: 50,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  player.player.profilePhotoUrl != ''
                                      ? player.player.profilePhotoUrl
                                      : 'https://i.stack.imgur.com/l60Hf.png'),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${player.player.firstName} ${player.player.lastName}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Rank: ${getOrdinalSuffix(player.playerStats.currentRank)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: darkColor,
                                  ),
                                ),
                                const SizedBox(height: 8)
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 5,
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\nPlayer ID: \nCountry: \nState/Province:       \nCity: \nAge:',
                            style: buildMontserrat(
                              darkColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Highest Rank: \nHighest Rank Date: \n',
                            style: buildMontserrat(
                              darkColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            player.player.playerID.toString(),
                            style: buildMontserrat(
                              darkColor,
                            ),
                          ),
                          Text(
                            player.player.countryName,
                            style: buildMontserrat(
                              darkColor,
                            ),
                          ),
                          Text(
                            player.player.state != ''
                                ? player.player.state
                                : 'N/A',
                            style: buildMontserrat(
                              darkColor,
                            ),
                          ),
                          Text(
                            player.player.city != ''
                                ? player.player.city
                                : 'N/A',
                            style: buildMontserrat(
                              darkColor,
                            ),
                          ),
                          Text(
                            player.player.age != 0
                                ? player.player.age.toString()
                                : 'N/A',
                            style: buildMontserrat(
                              darkColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            getOrdinalSuffix(player.playerStats.highestRank),
                            style: buildMontserrat(
                              darkColor,
                            ),
                          ),
                          Text(
                            player.playerStats.highestRankDate,
                            style: buildMontserrat(
                              darkColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            player.playerStats.totalEventsAllTime.toString(),
                            style: buildMontserrat(
                              const Color(0xFF000000),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Total Events',
                            style: buildMontserrat(darkColor),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                        child: VerticalDivider(
                          color: Color(0xFF9A9A9A),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            player.playerStats.currentWPPRPoints.toString(),
                            style: buildMontserrat(
                              const Color(0xFF000000),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'WPPR Points',
                            style: buildMontserrat(darkColor),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                        child: VerticalDivider(
                          color: Color(0xFF9A9A9A),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            getOrdinalSuffix(player.playerStats.averageFinish),
                            style: buildMontserrat(
                              const Color(0xFF000000),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Average Finish',
                            style: buildMontserrat(darkColor),
                          )
                        ],
                      ),
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

class AvatarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height)
      ..lineTo(8, size.height)
      ..arcToPoint(Offset(114, size.height), radius: Radius.circular(1))
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
