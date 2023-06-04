import 'package:json_annotation/json_annotation.dart';

part 'color.g.dart';

@JsonSerializable()
class ProColor {
  final double red;
  final double green;
  final double blue;
  final double alpha;

  ProColor(this.red, this.green, this.blue, this.alpha);

  factory ProColor.fromJson(Map<String, dynamic> json) =>
      _$ProColorFromJson(json);
  Map<String, dynamic> toJson() => _$ProColorToJson(this);
}
