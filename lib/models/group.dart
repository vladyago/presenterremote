import 'package:json_annotation/json_annotation.dart';
import 'package:presenterremote/models/color.dart';
import 'package:presenterremote/models/slide.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  final String name;
  final ProColor color;
  final List<Slide> slides;

  Group(this.name, this.color, this.slides);

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  Map<String, dynamic> toJson() => _$GroupToJson(this);
}
