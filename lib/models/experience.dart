import 'package:json_annotation/json_annotation.dart';

part 'experience.g.dart';

/// Portfolio experience synchronized with the Django REST Framework API.
@JsonSerializable(fieldRename: FieldRename.snake)
class Experience {
  const Experience({
    this.id,
    required this.title,
    required this.description,
    required this.position,
    this.thumbnail = '',
    required this.startedAt,
    this.endedAt,
  });

  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;
  final String title;
  final String description;
  final String position;
  @JsonKey(defaultValue: '')
  final String thumbnail;
  final String startedAt;
  final String? endedAt;
  @JsonKey(includeToJson: false, defaultValue: 0)
  bool get isOngoing => endedAt == null || endedAt!.isEmpty;

  Map<String, dynamic> toJson() => _$ExperienceToJson(this);
}
