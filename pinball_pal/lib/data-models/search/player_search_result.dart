import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PlayerSearchResult {
  @JsonKey(name: 'player_id')
  int playerId;
  @JsonKey(name: 'first_name')
  String firstName;
  @JsonKey(name: 'last_name')
  String lastName;
  @JsonKey(name: 'country_code')
  String countryCode;
  @JsonKey(name: 'country_name')
  String countryName;
  String city;
  String state;
  @JsonKey(name: 'wppr_rank')
  int wpprRank;

  PlayerSearchResult({
    required this.playerId,
    required this.firstName,
    required this.lastName,
    required this.countryCode,
    required this.countryName,
    required this.city,
    required this.state,
    required this.wpprRank,
  });

  factory PlayerSearchResult.fromJson(Map<String, dynamic> json) =>
      _$PlayerSearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerSearchResultToJson(this);
}

PlayerSearchResult _$PlayerSearchResultFromJson(Map<String, dynamic> json) {
  return PlayerSearchResult(
    playerId: int.parse(json['player_id']),
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    countryCode: json['country_code'] as String,
    countryName: json['country_name'] as String,
    city: json['city'] as String,
    state: json['state'] as String,
    wpprRank: int.parse(json['wppr_rank']),
  );
}

Map<String, dynamic> _$PlayerSearchResultToJson(PlayerSearchResult instance) =>
    <String, dynamic>{
      'player_id': instance.playerId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'country_code': instance.countryCode,
      'country_name': instance.countryName,
      'city': instance.city,
      'state': instance.state,
      'wppr_rank': instance.wpprRank,
    };
