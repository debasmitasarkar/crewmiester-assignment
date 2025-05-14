import 'package:json_annotation/json_annotation.dart';

part 'absence_data.g.dart';

@JsonSerializable()
class AbsenceData {
  final int id;
  final int crewId;

  @JsonKey(name: 'userId')
  final int memberUserId;
  final String type;
  final String startDate;
  final String endDate;
  final String? confirmedAt;
  final String? rejectedAt;
  final String? memberNote;
  final String? admitterNote;

  const AbsenceData({
    required this.id,
    required this.crewId,
    required this.memberUserId,
    required this.type,
    required this.startDate,
    required this.endDate,
    this.confirmedAt,
    this.rejectedAt,
    this.memberNote,
    this.admitterNote,
  });

  factory AbsenceData.fromJson(Map<String, dynamic> json) =>
      _$AbsenceDataFromJson(json);

  Map<String, dynamic> toJson() => _$AbsenceDataToJson(this);
}
