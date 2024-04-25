// ignore_for_file: todo, avoid_print, use_key_in_widget_constructors, avoid_function_literals_in_foreach_calls, use_build_context_synchronously, unused_local_variable, prefer_const_constructors, no_logic_in_create_state

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinball_pal/data-models/search/search_result_model.dart';
import '../services/ifpa-service.dart';
import '../services/db-service.dart';
import './player.dart';
import './pvp.dart';

final formKey = GlobalKey<FormState>();
final TextEditingController textEditingController = TextEditingController();
String? searchQuery;

class SearchView extends StatefulWidget {
  final bool pvpSearch;
  final int playerOneId;

  const SearchView({Key? key, this.pvpSearch = false, this.playerOneId = 0}) : super(key: key);

  @override
  SearchViewState createState() => SearchViewState(pvpSearch: pvpSearch, playerOneId: playerOneId);
}

class SearchViewState extends State<SearchView> {
  final int playerOneId;
  final bool pvpSearch;
  final IfpaService ifpaService = IfpaService();
  final SQFliteDbService databaseService = SQFliteDbService();
  late Future<SearchResultModel> searchResults;

  SearchViewState({Key? key, this.playerOneId = 0, this.pvpSearch = false});

  @override
  void initState() {
    super.initState();
    searchResults = getSearchResults();
  }

  Future<SearchResultModel> getSearchResults() async {
    try {
      if (searchQuery == null || searchQuery!.isEmpty) {
        return SearchResultModel(query: '', searchResults: []);
      }

      var apiResults = await ifpaService.searchPlayersByName(searchQuery!);
      return SearchResultModel.fromJson(apiResults);
    } catch (e) {
      print('HomeView getSearchResults catch: $e');
    }
    throw 'Error getting search results';
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
        title: Text(pvpSearch && playerOneId != 0 ? 'Compare' : 'Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
            key: formKey,
            child: 
            Row(children: [
              Expanded(child: 
                  TextFormField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      label: Text('Search for a player'),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      searchQuery = value;
                    },
                  ),
              ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.only(
                                      top: 5, bottom: 5, left: 20, right: 20))),
                          onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              formKey.currentState!.save();
                              setState(() {
                                searchQuery = textEditingController.text;
                                searchResults = getSearchResults();
                              });
                          },
                          child: Text('Submit'),
                        ),
                      ))
                ],
              )
            ),
            FutureBuilder<SearchResultModel>(
                future: searchResults,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.searchResults.length,
                            itemBuilder: (BuildContext context, index) {
                              return Card(
                                  child: ListTile(
                                      title: Text(
                                        'Rank: ${getOrdinalSuffix(snapshot.data!.searchResults[index].wpprRank)}',
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      subtitle: Text(
                                        'Name: ${snapshot.data!.searchResults[index].firstName} ${snapshot.data!.searchResults[index].lastName}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      trailing: ElevatedButton(
                                        onPressed: () {
                                          if (playerOneId != 0 && pvpSearch) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => PvpView(
                                                    playerOneId: playerOneId,
                                                    playerTwoId: snapshot
                                                        .data!
                                                        .searchResults[index]
                                                        .playerId),
                                              ),
                                            );
                                          } else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => PlayerView(
                                                    playerId: snapshot
                                                        .data!
                                                        .searchResults[index]
                                                        .playerId),
                                              ),
                                            );
                                          }
                                        },
                                        child: Text(pvpSearch && playerOneId != 0 ? 'Compare' : 'Stats'),
                                      )));
                            }));
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return Text('Please enter a search query');
                }),
          ],
        ),
      )
    );
  }
}