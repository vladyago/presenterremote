// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProColor _$ProColorFromJson(Map<String, dynamic> json) => ProColor(
      (json['red'] as num).toDouble(),
      (json['green'] as num).toDouble(),
      (json['blue'] as num).toDouble(),
      (json['alpha'] as num).toDouble(),
    );

Map<String, dynamic> _$ProColorToJson(ProColor instance) => <String, dynamic>{
      'red': instance.red,
      'green': instance.green,
      'blue': instance.blue,
      'alpha': instance.alpha,
    };
