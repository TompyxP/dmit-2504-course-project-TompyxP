import 'package:json_annotation/json_annotation.dart';
import 'package:pinball_pal/data-models/pvp/pvp_tournament.dart';

@JsonSerializable()
class PvpModel {
  @JsonKey(name: 'p1_player_id')
  int playerOneId;
  @JsonKey(name: 'p2_player_id')
  int playerTwoId;
  @JsonKey(name: 'p1_first_name')
  String playerOneFirstName;
  @JsonKey(name: 'p1_last_name')
  String playerOneLastName;
  @JsonKey(name: 'p2_first_name')
  String playerTwoFirstName;
  @JsonKey(name: 'p2_last_name')
  String playerTwoLastName;
  @JsonKey(name: 'p1_country_code')
  String playerOneCountryCode;
  @JsonKey(name: 'p2_country_code')
  String playerTwoCountryCode;
  @JsonKey(name: 'pvp')
  List<PvpTournament>? pvp;

  PvpModel({
    required this.playerOneId,
    required this.playerTwoId,
    required this.playerOneFirstName,
    required this.playerOneLastName,
    required this.playerTwoFirstName,
    required this.playerTwoLastName,
    required this.playerOneCountryCode,
    required this.playerTwoCountryCode,
    required this.pvp,
  });

  factory PvpModel.fromJson(Map<String, dynamic> json) =>
      _$PvpModelFromJson(json);

  Map<String, dynamic> toJson() => _$PvpModelToJson(this);
}

PvpModel _$PvpModelFromJson(Map<String, dynamic> json) {
  return PvpModel(
    playerOneId: json['p1_player_id'] is String ? int.parse(json['p1_player_id']) : json['p1_player_id'],
    playerTwoId: json['p2_player_id'] is String ? int.parse(json['p2_player_id']) : json['p2_player_id'],
    playerOneFirstName: json['p1_first_name'] as String,
    playerOneLastName: json['p1_last_name'] as String,
    playerTwoFirstName: json['p2_first_name'] as String,
    playerTwoLastName: json['p2_last_name'] as String,
    playerOneCountryCode: json['p1_country_code'] as String,
    playerTwoCountryCode: json['p2_country_code'] as String,
    pvp: json['pvp'] != null ? (json['pvp'] as List<dynamic>)
        .map((e) => PvpTournament.fromJson(e as Map<String, dynamic>))
        .toList() : [],
  );
}

Map<String, dynamic> _$PvpModelToJson(PvpModel instance) => <String, dynamic>{
      'p1_player_id': instance.playerOneId,
      'p2_player_id': instance.playerTwoId,
      'p1_first_name': instance.playerOneFirstName,
      'p1_last_name': instance.playerOneLastName,
      'p2_first_name': instance.playerTwoFirstName,
      'p2_last_name': instance.playerTwoLastName,
      'p1_country_code': instance.playerOneCountryCode,
      'p2_country_code': instance.playerTwoCountryCode,
      'pvp': instance.pvp != null ? instance.pvp!.map((e) => e.toJson()).toList() : [],
    };