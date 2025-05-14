import 'package:json_annotation/json_annotation.dart';

part 'member_data.g.dart';

@JsonSerializable()
class MemberData {
  final int id;
  final int crewId;
  final int userId;
  final String name;
  final String image;

  MemberData({
    required this.id,
    required this.crewId,
    required this.userId,
    required this.name,
    required this.image,
  });

  factory MemberData.fromJson(Map<String, dynamic> json) =>
      _$MemberDataFromJson(json);

  Map<String, dynamic> toJson() => _$MemberDataToJson(this);
}
