import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PvpTournament {
  @JsonKey(name: 'tournament_id')
  int tournamentId;
  @JsonKey(name: 'tournament_name')
  String? tournamentName;
  @JsonKey(name: 'event_name')
  String? eventName;
  @JsonKey(name: 'event_date')
  String? eventDate;
  @JsonKey(name: 'tournament_country_code')
  String? countryCode;
  @JsonKey(name: 'p1_finish_position')
  int playerOneFinishPosition;
  @JsonKey(name: 'p2_finish_position')
  int playerTwoFinishPosition;

  PvpTournament({
    required this.tournamentId,
    required this.tournamentName,
    required this.eventName,
    required this.eventDate,
    required this.countryCode,
    required this.playerOneFinishPosition,
    required this.playerTwoFinishPosition,
  });

  factory PvpTournament.fromJson(Map<String, dynamic> json) =>
      _$PvpTournamentFromJson(json);

  Map<String, dynamic> toJson() => _$PvpTournamentToJson(this);
}

PvpTournament _$PvpTournamentFromJson(Map<String, dynamic> json) {
  return PvpTournament(
    tournamentId: int.parse(json['tournament_id']),
    tournamentName: json['tournament_name'] != '' ? json['tournament_name'] as String : 'None',
    eventName: json['event_name'] != '' ? json['event_name'] as String : 'None',
    eventDate: json['event_date'] as String,
    countryCode: json['tournament_country_code'] as String,
    playerOneFinishPosition: int.parse(json['p1_finish_position']),
    playerTwoFinishPosition: int.parse(json['p2_finish_position']),
  );
}

Map<String, dynamic> _$PvpTournamentToJson(PvpTournament instance) =>
    <String, dynamic>{
      'tournament_id': instance.tournamentId,
      'tournament_name': instance.tournamentName,
      'event_date': instance.eventDate,
      'event_name': instance.eventName,
      'tournament_country_code': instance.countryCode,
      'p1_finish_position': instance.playerOneFinishPosition,
      'p2_finish_position': instance.playerTwoFinishPosition,
    };
