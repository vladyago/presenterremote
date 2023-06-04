// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slide.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Slide _$SlideFromJson(Map<String, dynamic> json) => Slide(
      enabled: json['enabled'] as bool,
      notes: json['notes'] as String,
      text: json['text'] as String,
      label: json['label'] as String,
    );

Map<String, dynamic> _$SlideToJson(Slide instance) => <String, dynamic>{
      'enabled': instance.enabled,
      'notes': instance.notes,
      'text': instance.text,
      'label': instance.label,
    };
