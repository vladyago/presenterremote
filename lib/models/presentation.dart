import 'package:json_annotation/json_annotation.dart';
import 'package:presenterremote/models/group.dart';

part 'presentation.g.dart';

@JsonSerializable()
class Presentation {
  final PresentationId id;
  final List<Group> groups;
  final bool has_timeline;
  final String presentation_path;
  final String destination;

  Presentation(this.id, this.groups, this.has_timeline, this.presentation_path,
      this.destination);

  factory Presentation.fromJson(Map<String, dynamic> json) =>
      _$PresentationFromJson(json);
  Map<String, dynamic> toJson() => _$PresentationToJson(this);
}

@JsonSerializable()
class PresentationId {
  final String uuid;
  final String name;
  final int index;

  PresentationId(this.uuid, this.name, this.index);

  factory PresentationId.fromJson(Map<String, dynamic> json) =>
      _$PresentationIdFromJson(json);
  Map<String, dynamic> toJson() => _$PresentationIdToJson(this);
}
