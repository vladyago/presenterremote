// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistTreeNode _$PlaylistTreeNodeFromJson(Map<String, dynamic> json) =>
    PlaylistTreeNode(
      PlaylistId.fromJson(json['id'] as Map<String, dynamic>),
      json['field_type'] as String,
      (json['children'] as List<dynamic>)
          .map((e) => PlaylistTreeNode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlaylistTreeNodeToJson(PlaylistTreeNode instance) =>
    <String, dynamic>{
      'id': instance.id.toJson(),
      'field_type': instance.fieldType,
      'children': instance.children.map((e) => e.toJson()).toList(),
    };

Playlist _$PlaylistFromJson(Map<String, dynamic> json) => Playlist(
      PlaylistId.fromJson(json['id'] as Map<String, dynamic>),
      (json['items'] as List<dynamic>)
          .map((e) => PlaylistItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlaylistToJson(Playlist instance) => <String, dynamic>{
      'id': instance.id.toJson(),
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

PlaylistItem _$PlaylistItemFromJson(Map<String, dynamic> json) => PlaylistItem(
      id: PlaylistId.fromJson(json['id'] as Map<String, dynamic>),
      type: json['type'] as String,
      isHidden: json['is_hidden'] as bool,
      isPco: json['is_pco'] as bool,
      headerColor: json['header_color'] == null
          ? null
          : ProColor.fromJson(json['header_color'] as Map<String, dynamic>),
      duration: (json['duration'] as num?)?.toInt(),
      presentationInfo: json['presentation_info'] == null
          ? null
          : PresentationInfo.fromJson(
              json['presentation_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlaylistItemToJson(PlaylistItem instance) =>
    <String, dynamic>{
      'id': instance.id.toJson(),
      'type': instance.type,
      'is_hidden': instance.isHidden,
      'is_pco': instance.isPco,
      'header_color': instance.headerColor?.toJson(),
      'duration': instance.duration,
      'presentation_info': instance.presentationInfo?.toJson(),
    };

PlaylistId _$PlaylistIdFromJson(Map<String, dynamic> json) => PlaylistId(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      index: (json['index'] as num).toInt(),
    );

Map<String, dynamic> _$PlaylistIdToJson(PlaylistId instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'index': instance.index,
    };

PresentationInfo _$PresentationInfoFromJson(Map<String, dynamic> json) =>
    PresentationInfo(
      presentationUuid: json['presentation_uuid'] as String,
      arrangementName: json['arrangement_name'] as String,
    );

Map<String, dynamic> _$PresentationInfoToJson(PresentationInfo instance) =>
    <String, dynamic>{
      'presentation_uuid': instance.presentationUuid,
      'arrangement_name': instance.arrangementName,
    };
