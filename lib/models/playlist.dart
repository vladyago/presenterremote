import 'package:json_annotation/json_annotation.dart';
import 'package:presenterremote/models/color.dart';

part 'playlist.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class PlaylistTreeNode {
  final PlaylistId id;
  final String fieldType;
  final List<PlaylistTreeNode> children;

  PlaylistTreeNode(this.id, this.fieldType, this.children);

  factory PlaylistTreeNode.fromJson(Map<String, dynamic> json) =>
      _$PlaylistTreeNodeFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistTreeNodeToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Playlist {
  final PlaylistId id;
  final List<PlaylistItem> items;

  Playlist(this.id, this.items);

  factory Playlist.fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class PlaylistItem {
  final PlaylistId id;
  final String type;
  final bool isHidden;
  final bool isPco;
  final ProColor? headerColor;
  final int? duration;
  final PresentationInfo? presentationInfo;

  PlaylistItem(
      {required this.id,
      required this.type,
      required this.isHidden,
      required this.isPco,
      this.headerColor,
      this.duration,
      this.presentationInfo});

  factory PlaylistItem.fromJson(Map<String, dynamic> json) =>
      _$PlaylistItemFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistItemToJson(this);
}

///todo: consolidate into one type across models
@JsonSerializable()
class PlaylistId {
  final String uuid;
  final String name;
  final int index;

  PlaylistId({required this.uuid, required this.name, required this.index});

  factory PlaylistId.fromJson(Map<String, dynamic> json) =>
      _$PlaylistIdFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistIdToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PresentationInfo {
  final String presentationUuid;
  final String arrangementName;

  PresentationInfo(
      {required this.presentationUuid, required this.arrangementName});

  factory PresentationInfo.fromJson(Map<String, dynamic> json) =>
      _$PresentationInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PresentationInfoToJson(this);
}
