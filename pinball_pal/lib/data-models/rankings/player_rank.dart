import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PlayerRank {
  @JsonKey(name: 'player_id')
  int playerId;
  @JsonKey(name: 'first_name')
  String firstName;
  @JsonKey(name: 'last_name')
  String lastName;
  @JsonKey(name: 'age')
  int age;
  @JsonKey(name: 'country_name')
  String countryName;
  @JsonKey(name: 'country_code')
  String countryCode;
  @JsonKey(name: 'state')
  String state;
  @JsonKey(name: 'city')
  String city;
  @JsonKey(name: 'wppr_points')
  double wpprPoints;
  @JsonKey(name: 'current_wppr_rank')
  int currentWpprRank;
  @JsonKey(name: 'last_month_rank')
  int lastMonthRank;
  @JsonKey(name: 'rating_value')
  double ratingValue;
  @JsonKey(name: 'efficiency_percent')
  double efficiencyPercent;
  @JsonKey(name: 'event_count')
  int eventCount;
  @JsonKey(name: 'best_finish')
  String bestFinishTournamentName;
  @JsonKey(name: 'best_finish_position')
  int bestFinishPosition;
  @JsonKey(name: 'best_tournament_id')
  int bestFinishTournamentId;

  PlayerRank({
    required this.playerId,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.countryName,
    required this.countryCode,
    required this.state,
    required this.city,
    required this.wpprPoints,
    required this.currentWpprRank,
    required this.lastMonthRank,
    required this.ratingValue,
    required this.efficiencyPercent,
    required this.eventCount,
    required this.bestFinishTournamentName,
    required this.bestFinishPosition,
    required this.bestFinishTournamentId,
  });

  factory PlayerRank.fromJson(Map<String, dynamic> json) =>
      _$PlayerRankFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerRankToJson(this);
}

PlayerRank _$PlayerRankFromJson(Map<String, dynamic> json) {
  return PlayerRank(
    playerId: int.parse(json['player_id']),
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    age: json['age'] as int,
    countryName: json['country_name'] as String,
    countryCode: json['country_code'] as String,
    state: json['state'] as String,
    city: json['city'] as String,
    wpprPoints: double.parse(json['wppr_points']),
    currentWpprRank: int.parse(json['current_wppr_rank']),
    lastMonthRank: int.parse(json['last_month_rank']),
    ratingValue: double.parse(json['rating_value']),
    efficiencyPercent: double.parse(json['efficiency_percent']),
    eventCount: int.parse(json['event_count']),
    bestFinishTournamentName: json['best_finish'] as String,
    bestFinishPosition: int.parse(json['best_finish_position']),
    bestFinishTournamentId: int.parse(json['best_tournament_id']),
  );
}

Map<String, dynamic> _$PlayerRankToJson(PlayerRank instance) =>
    <String, dynamic>{
      'player_id': instance.playerId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'age': instance.age,
      'country_name': instance.countryName,
      'country_code': instance.countryCode,
      'state': instance.state,
      'city': instance.city,
      'wppr_points': instance.wpprPoints,
      'current_wppr_rank': instance.currentWpprRank,
      'last_month_rank': instance.lastMonthRank,
      'rating_value': instance.ratingValue,
      'efficiency_percent': instance.efficiencyPercent,
      'event_count': instance.eventCount,
      'best_finish': instance.bestFinishTournamentName,
      'best_finish_position': instance.bestFinishPosition,
      'best_tournament_id': instance.bestFinishTournamentId,
    };
