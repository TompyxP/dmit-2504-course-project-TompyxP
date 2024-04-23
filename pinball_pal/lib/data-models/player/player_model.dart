import 'package:json_annotation/json_annotation.dart';
import 'player_metadata.dart';
import 'player_stats.dart';

@JsonSerializable()
class PlayerModel {
  @JsonKey(name: 'player')
  PlayerMetadata player;
  @JsonKey(name: 'player_stats')
  PlayerStats playerStats;

  PlayerModel({
    required this.player,
    required this.playerStats,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerModelToJson(this);
}

PlayerModel _$PlayerModelFromJson(Map<String, dynamic> json) {
  return PlayerModel(
    player: PlayerMetadata.fromJson(json['player'][0] as Map<String, dynamic>),
    playerStats: PlayerStats.fromJson(json['player'][0]['player_stats'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PlayerModelToJson(PlayerModel instance) =>
    <String, dynamic>{
      'player': instance.player.toJson(),
      'player_stats': instance.playerStats.toJson()
    };
