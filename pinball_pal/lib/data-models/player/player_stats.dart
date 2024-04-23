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
  @JsonKey(name: 'current_wppr_value')
  double currentWPPRValue;
  @JsonKey(name: 'wppr_points_all_time')
  double allTimeWPPRPoints;
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
  @JsonKey(name: 'efficiency_rank')
  int efficiencyRank;
  @JsonKey(name: 'efficiency_value')
  double efficiencyValue;

  PlayerStats({
    required this.currentRank,
    required this.lastMonthRank,
    required this.lastYearRank,
    required this.highestRank,
    required this.highestRankDate,
    required this.currentWPPRValue,
    required this.allTimeWPPRPoints,
    required this.bestFinish,
    required this.bestFinishCount,
    required this.averageFinish,
    required this.averageFinishLastYear,
    required this.totalEventsAllTime,
    required this.totalActiveEvents,
    required this.totalEventsAway,
    required this.ratingsRank,
    required this.ratingsValue,
    required this.efficiencyRank,
    required this.efficiencyValue,
  });

  factory PlayerStats.fromJson(Map<String, dynamic> json) =>
      _$PlayerStatsFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerStatsToJson(this);
}

PlayerStats _$PlayerStatsFromJson(Map<String, dynamic> json) {
  return PlayerStats(
    currentRank: json['current_wppr_rank'] as int,
    lastMonthRank: json['last_month_rank'] as int,
    lastYearRank: json['last_year_rank'] as int,
    highestRank: json['highest_rank'] as int,
    highestRankDate: DateTime.parse(json['highest_rank_date'] as String),
    currentWPPRValue: json['current_wppr_value'] as double,
    allTimeWPPRPoints: json['wppr_points_all_time'] as double,
    bestFinish: json['best_finish'] as int,
    bestFinishCount: json['best_finish_count'] as int,
    averageFinish: json['average_finish'] as int,
    averageFinishLastYear: json['average_finish_last_year'] as int,
    totalEventsAllTime: json['total_events_all_time'] as int,
    totalActiveEvents: json['total_active_events'] as int,
    totalEventsAway: json['total_events_away'] as int,
    ratingsRank: json['ratings_rank'] as int,
    ratingsValue: json['ratings_value'] as double,
    efficiencyRank: json['efficiency_rank'] as int,
    efficiencyValue: json['efficiency_value'] as double,
  );
}

Map<String, dynamic> _$PlayerStatsToJson(PlayerStats instance) =>
    <String, dynamic>{
      'current_wppr_rank': instance.currentRank,
      'last_month_rank': instance.lastMonthRank,
      'last_year_rank': instance.lastYearRank,
      'highest_rank': instance.highestRank,
      'highest_rank_date': instance.highestRankDate.toIso8601String(),
      'current_wppr_value': instance.currentWPPRValue,
      'wppr_points_all_time': instance.allTimeWPPRPoints,
      'best_finish': instance.bestFinish,
      'best_finish_count': instance.bestFinishCount,
      'average_finish': instance.averageFinish,
      'average_finish_last_year': instance.averageFinishLastYear,
      'total_events_all_time': instance.totalEventsAllTime,
      'total_active_events': instance.totalActiveEvents,
      'total_events_away': instance.totalEventsAway,
      'ratings_rank': instance.ratingsRank,
      'ratings_value': instance.ratingsValue,
      'efficiency_rank': instance.efficiencyRank,
      'efficiency_value': instance.efficiencyValue,
    };
