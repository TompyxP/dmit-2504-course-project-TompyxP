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
  @JsonKey(name: 'profile_photo')
  String profilePhotoUrl;

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
    required this.profilePhotoUrl
  });

  factory PlayerMetadata.fromJson(Map<String, dynamic> json) =>
      _$PlayerMetadataViewFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerMetadataToJson(this);
}

PlayerMetadata _$PlayerMetadataViewFromJson(Map<String, dynamic> json) {
  return PlayerMetadata(
    playerID: int.parse(json['player_id']),
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    city: json['city'] as String,
    state: json['stateprov'] as String,
    countryCode: json['country_code'] as String,
    countryName: json['country_name'] as String,
    initials: json['initials'] as String,
    age: json['age'] == '' ? 0 : json['age'] as int,
    excludedFlag: bool.parse(json['excluded_flag']),
    isIFPARegistered: bool.parse(json['ifpa_registered']),
    profilePhotoUrl: json['profile_photo'] as String
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
      'profile_photo': instance.profilePhotoUrl
    };