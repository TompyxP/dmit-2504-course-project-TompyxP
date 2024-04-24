import 'package:json_annotation/json_annotation.dart';
import 'player_search_result.dart'; // Import PlayerSearchResult class

@JsonSerializable()
class SearchResultModel {

  @JsonKey(name: 'query')
  String query;
  @JsonKey(name: 'search')
  List<PlayerSearchResult> searchResults;

  SearchResultModel({
    required this.query,
    required this.searchResults,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultModelToJson(this);
}

SearchResultModel _$SearchResultModelFromJson(Map<String, dynamic> json) {
  return SearchResultModel(
    query: json['query'] as String,
    searchResults: (json['search'] as List<dynamic>)
        .map((e) => PlayerSearchResult.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SearchResultModelToJson(SearchResultModel instance) =>
    <String, dynamic>{
      'query': instance.query,
      'search': instance.searchResults.map((e) => e.toJson()).toList(),
    };
