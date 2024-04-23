import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PlayerMetadata {
  @JsonKey(name: 'player_id')
  int playerID;
  @JsonKey(name: 'first_name')
  String firstName;
  @JsonKey(name: 'last_name')
  String lastName;
  @JsonKey(name: 'city')
  String city;
  @JsonKey(name: 'state')
  String state;
  @JsonKey(name: 'country_code')
  String countryCode;
  @JsonKey(name: 'country_name')
  String countryName;
  @JsonKey(name: 'initials')
  String initials;
  @JsonKey(name: 'age')
  int age;
  @JsonKey(name: 'excluded_flag')
  bool excludedFlag;
  @JsonKey(name: 'ifpa_registered')
  bool isIFPARegistered;

  PlayerMetadata({
    required this.playerID,
    required this.firstName,
    required this.lastName,
    required this.city,
    required this.state,
    required this.countryCode,
    required this.countryName,
    required this.initials,
    required this.age,
    required this.excludedFlag,
    required this.isIFPARegistered,
  });

  factory PlayerMetadata.fromJson(Map<String, dynamic> json) =>
      _$PlayerMetadataViewFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerMetadataToJson(this);
}

PlayerMetadata _$PlayerMetadataViewFromJson(Map<String, dynamic> json) {
  return PlayerMetadata(
    playerID: json['player_id'] as int,
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    city: json['city'] as String,
    state: json['state'] as String,
    countryCode: json['country_code'] as String,
    countryName: json['country_name'] as String,
    initials: json['initials'] as String,
    age: json['age'] as int,
    excludedFlag: json['excluded_flag'] as bool,
    isIFPARegistered: json['ifpa_registered'] as bool,
  );
}

Map<String, dynamic> _$PlayerMetadataToJson(PlayerMetadata instance) =>
    <String, dynamic>{
      'player_id': instance.playerID,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'city': instance.city,
      'state': instance.state,
      'country_code': instance.countryCode,
      'country_name': instance.countryName,
      'initials': instance.initials,
      'age': instance.age,
      'excluded_flag': instance.excludedFlag,
      'ifpa_registered': instance.isIFPARegistered,
    };