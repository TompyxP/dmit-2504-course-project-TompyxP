import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PlayerStats {
  @JsonKey(name: 'current_wppr_rank')
  int currentRank;
  @JsonKey(name: 'last_month_rank')
  int lastMonthRank;
  @JsonKey(name: 'last_year_rank')
  int lastYearRank;
  @JsonKey(name: 'highest_rank')
  int highestRank;
  @JsonKey(name: 'highest_rank_date')
  DateTime highestRankDate;
  @JsonKey(name: 'current_wppr_points')
  double currentWPPRPoints;
  @JsonKey(name: 'best_finish')
  int bestFinish;
  @JsonKey(name: 'best_finish_count')
  int bestFinishCount;
  @JsonKey(name: 'average_finish')
  int averageFinish;
  @JsonKey(name: 'average_finish_last_year')
  int averageFinishLastYear;
  @JsonKey(name: 'total_events_all_time')
  int totalEventsAllTime;
  @JsonKey(name: 'total_active_events')
  int totalActiveEvents;
  @JsonKey(name: 'total_events_away')
  int totalEventsAway;
  @JsonKey(name: 'ratings_rank')
  int ratingsRank;
  @JsonKey(name: 'ratings_value')
  double ratingsValue;
  @JsonKey(name: 'years_active')
  int yearsActive;

  PlayerStats({
    required this.currentRank,
    required this.lastMonthRank,
    required this.lastYearRank,
    required this.highestRank,
    required this.highestRankDate,
    required this.currentWPPRPoints,
    required this.bestFinish,
    required this.bestFinishCount,
    required this.averageFinish,
    required this.averageFinishLastYear,
    required this.totalEventsAllTime,
    required this.totalActiveEvents,
    required this.totalEventsAway,
    required this.ratingsRank,
    required this.ratingsValue,
    required this.yearsActive,
  });

  factory PlayerStats.fromJson(Map<String, dynamic> json) =>
      _$PlayerStatsFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerStatsToJson(this);
}

PlayerStats _$PlayerStatsFromJson(Map<String, dynamic> json) {
  return PlayerStats(
    currentRank: int.parse(json['current_wppr_rank']),
    lastMonthRank: int.parse(json['last_month_rank']),
    lastYearRank: int.parse(json['last_year_rank']),
    highestRank: int.parse(json['highest_rank']),
    highestRankDate: DateTime.parse(json['highest_rank_date'] as String),
    currentWPPRPoints: double.parse(json['current_wppr_points']),
    bestFinish: int.parse(json['best_finish']),
    bestFinishCount: int.parse(json['best_finish_count']),
    averageFinish: int.parse(json['average_finish']),
    averageFinishLastYear: int.parse(json['average_finish_last_year']),
    totalEventsAllTime: int.parse(json['total_events_all_time']),
    totalActiveEvents: int.parse(json['total_active_events']),
    totalEventsAway: int.parse(json['total_events_away']),
    ratingsRank: int.parse(json['ratings_rank']),
    ratingsValue: double.parse(json['ratings_value']),
    yearsActive: int.parse(json['years_active']),
  );
}

Map<String, dynamic> _$PlayerStatsToJson(PlayerStats instance) =>
    <String, dynamic>{
      'current_wppr_rank': instance.currentRank,
      'last_month_rank': instance.lastMonthRank,
      'last_year_rank': instance.lastYearRank,
      'highest_rank': instance.highestRank,
      'highest_rank_date': instance.highestRankDate.toIso8601String(),
      'current_wppr_value': instance.currentWPPRPoints,
      'best_finish': instance.bestFinish,
      'best_finish_count': instance.bestFinishCount,
      'average_finish': instance.averageFinish,
      'average_finish_last_year': instance.averageFinishLastYear,
      'total_events_all_time': instance.totalEventsAllTime,
      'total_active_events': instance.totalActiveEvents,
      'total_events_away': instance.totalEventsAway,
      'ratings_rank': instance.ratingsRank,
      'ratings_value': instance.ratingsValue,
      'years_active': instance.yearsActive,
    };
