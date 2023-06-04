import 'package:json_annotation/json_annotation.dart';

part 'slide.g.dart';

@JsonSerializable()
class Slide {
  Slide({
    required this.enabled,
    required this.notes,
    required this.text,
    required this.label,
  });

  final bool enabled;
  final String notes;
  final String text;
  final String label;

  factory Slide.fromJson(Map<String, dynamic> json) => _$SlideFromJson(json);
  Map<String, dynamic> toJson() => _$SlideToJson(this);
}
