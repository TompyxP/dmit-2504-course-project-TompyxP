// ignore_for_file: avoid_print, unused_local_variable, file_names

import 'dart:async';
import '../services/network.dart';

const apiKey = '';
const baseUrl = 'api.ifpapinball.com';

class IfpaService {

  Future getPlayerById(int playerId) async {

    Uri url = Uri(
      scheme: 'https',
      host: baseUrl,
      path: '/player/$playerId',
      query: 'api_key=$apiKey'
    );
    print('url: $url');
    NetworkService networkService = NetworkService(url);
    var data = await networkService.getData();
    print(data);
    return data;
  }

  Future searchPlayersByName(String queryString) async {
    Uri url = Uri(
      scheme: 'https',
      host: baseUrl,
      path: '/v1/player/search',
      query: 'api_key=$apiKey&q=$queryString'
    );

    print('url: $url');
    NetworkService networkService = NetworkService(url);
    var data = await networkService.getData();
    print(data);
    return data;
  }

  Future listTop10Players() async {
    Uri url = Uri(
      scheme: 'https',
      host: baseUrl,
      path: '/v1/rankings',
      query: 'api_key=$apiKey&count=10'
    );

    print('url: $url');
    NetworkService networkService = NetworkService(url);
    var data = await networkService.getData();
    print(data);
    return data;
  }

  Future comparePlayersById(int playerId1, int playerId2) async {
    Uri url = Uri(
      scheme: 'https',
      host: baseUrl,
      path: '/v1/pvp',
      query: 'api_key=$apiKey&p1=$playerId1&p2=$playerId2'
    );

    print('url: $url');
    NetworkService networkService = NetworkService(url);
    var data = await networkService.getData();
    print(data);
    return data;
  }
}
