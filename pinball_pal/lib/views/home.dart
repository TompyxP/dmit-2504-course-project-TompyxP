// ignore_for_file: todo, avoid_print, use_key_in_widget_constructors, avoid_function_literals_in_foreach_calls, use_build_context_synchronously, unused_local_variable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:async';
import '../services/ifpa-service.dart';
import '../services/db-service.dart';

class HomeView extends StatefulWidget {
  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  final IfpaService ifpaService = IfpaService();
  final SQFliteDbService databaseService = SQFliteDbService();
  List<Map<String, dynamic>> topPlayers = [];
  String stockSymbol = "";

  @override
  void initState() {
    super.initState();
    getTop10PlayersFromApi();
  }

  void getTop10PlayersFromApi() async {
    try {
        var top10Players = await ifpaService.listTop10Players();
        for (var player in top10Players) {
          var playerData = {
            'player_id': player['symbol'],
            'name': player['name'],
            'price': player['price']
          };
        }
        topPlayers = await databaseService.getAllStocksFromDb();
        await databaseService.printAllStocksInDbToConsole();
        setState(() {});
    } catch (e) {
      print('HomeView getTop10PlayersFromApi catch: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Ticker'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text(
                'Delete All Records and Db',
              ),
              onPressed: () async {
                await databaseService.deleteDb();
                await databaseService.getOrCreateDatabaseHandle();
                topPlayers = await databaseService.getAllStocksFromDb();
                await databaseService.printAllStocksInDbToConsole();
                setState(() {});
              },
            ),
            ElevatedButton(
              child: const Text(
                'Add Stock',
              ),
              onPressed: () {
                inputStock();
              },
            ),
            Expanded(
              //TODO: Replace this Text child with a ListView.builder
              child: ListView.builder(
                itemCount: topPlayers.length, 
                itemBuilder: (BuildContext context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      'Symbol: ${topPlayers[index]['symbol']}',
                      style: const TextStyle(fontSize: 30),
                    ),
                    subtitle: Text(
                      'Name: ${topPlayers[index]['name']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: Text(
                      'Price: \$${topPlayers[index]['price']} USD',
                      style: const TextStyle(fontSize: 16),
                    ),
                  )
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  Future<void> inputStock() async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Input Stock Symbol'),
            contentPadding: const EdgeInsets.all(5.0),
            content: TextField(
              decoration: const InputDecoration(hintText: "Symbol"),
              onChanged: (String value) {
                stockSymbol = value;
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Add Stock"),
                onPressed: () async {
                  if (stockSymbol.isNotEmpty) {
                    print('User entered Symbol: $stockSymbol');
                    var symbol = stockSymbol;
                    var companyName = '';
                    var price = 0.0;
                    try {
                      //TODO:
                      //Inside of this try,
                      //get the company data with
                      //stockService.getCompanyInfo,
                      //then get the stock data with
                      //stockService.getQuote,
                      //but remember you must use await,
                      //then if it is not null,
                      //dig out the symbol, companyName, and latestPrice,
                      //then create a new object of
                      //type Stock and add it to
                      //the database by calling
                      //databaseService.insertStock,
                      //then get all the stocks from
                      //the database with
                      //databaseService.getAllStocksFromDb and
                      //attach them to stockList,
                      //then print all stocks to the console and,
                      //finally call setstate at the end.
                      var companyData = await ifpaService.getCompanyInfo(symbol);
                      var stockData = await ifpaService.getQuote(symbol);

                      symbol = companyData['Symbol'];
                      companyName = companyData['Name'];
                      price = double.parse(stockData['Global Quote']['05. price']);

                      var formattedPrice = price.toStringAsFixed(2);

                      if (companyData != null && stockData != null) {
                        var stock = {
                          'symbol': symbol,
                          'name': companyName,
                          'price': formattedPrice
                        };
                        await databaseService.insertStock(stock);
                        topPlayers = await databaseService.getAllStocksFromDb();
                        await databaseService.printAllStocksInDbToConsole();
                        setState(() {});
                      }
                    } catch (e) {
                      print('HomeView inputStock catch: $e');
                    }
                  }
                  stockSymbol = "";
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
