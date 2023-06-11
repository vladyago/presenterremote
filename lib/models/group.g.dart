// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      json['name'] as String,
      json['color'] == null
          ? null
          : ProColor.fromJson(json['color'] as Map<String, dynamic>),
      (json['slides'] as List<dynamic>)
          .map((e) => Slide.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'name': instance.name,
      'color': instance.color?.toJson(),
      'slides': instance.slides.map((e) => e.toJson()).toList(),
    };
