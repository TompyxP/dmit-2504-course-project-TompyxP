import 'package:json_annotation/json_annotation.dart';
import 'player_rank.dart';

@JsonSerializable()
class Rankings {
  @JsonKey(name: 'total_count', fromJson: _intFromString)
  int totalCount;
  @JsonKey(name: 'sub_category')
  String subCategory;
  @JsonKey(name: 'rankings')
  List<PlayerRank> rankings;

  Rankings({
    required this.totalCount,
    required this.subCategory,
    required this.rankings,
  });

  factory Rankings.fromJson(Map<String, dynamic> json) =>
      _$RankingsFromJson(json);

  Map<String, dynamic> toJson() => _$RankingsToJson(this);

  static int _intFromString(String value) {
    return int.parse(value);
  }
}

Rankings _$RankingsFromJson(Map<String, dynamic> json) {
  return Rankings(
    totalCount: int.parse(json['total_count']),
    subCategory: json['sub_category'] as String,
    rankings: (json['rankings'] as List<dynamic>)
        .map((e) => PlayerRank.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$RankingsToJson(Rankings instance) => <String, dynamic>{
      'total_count': instance.totalCount,
      'sub_category': instance.subCategory,
      'rankings': instance.rankings.map((e) => e.toJson()).toList(),
    };
