// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presentation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Presentation _$PresentationFromJson(Map<String, dynamic> json) => Presentation(
      PresentationId.fromJson(json['id'] as Map<String, dynamic>),
      (json['groups'] as List<dynamic>)
          .map((e) => Group.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['has_timeline'] as bool,
      json['presentation_path'] as String,
      json['destination'] as String,
    );

Map<String, dynamic> _$PresentationToJson(Presentation instance) =>
    <String, dynamic>{
      'id': instance.id.toJson(),
      'groups': instance.groups.map((e) => e.toJson()).toList(),
      'has_timeline': instance.has_timeline,
      'presentation_path': instance.presentation_path,
      'destination': instance.destination,
    };

PresentationId _$PresentationIdFromJson(Map<String, dynamic> json) =>
    PresentationId(
      json['uuid'] as String,
      json['name'] as String,
      (json['index'] as num).toInt(),
    );

Map<String, dynamic> _$PresentationIdToJson(PresentationId instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'index': instance.index,
    };
