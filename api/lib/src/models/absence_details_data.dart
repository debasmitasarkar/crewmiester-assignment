import 'package:json_annotation/json_annotation.dart';
import 'absence_data.dart';

part 'absence_details_data.g.dart';

@JsonSerializable()
class AbsenceDetailsData {
  final int id;
  final String memberUserId;
  final String employeeName;
  final String type;
  final String startDate;
  final String endDate;
  final String status;
  final String? memberNote;
  final String? admitterNote;

  AbsenceDetailsData({
    required this.id,
    required this.memberUserId,
    required this.employeeName,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.memberNote,
    this.admitterNote,
  });

  factory AbsenceDetailsData.from(AbsenceData d, String employeeName) {
    final status = switch ((d.confirmedAt, d.rejectedAt)) {
      (null, null) => 'requested',
      (null, String _) => 'rejected',
      (String _, null) => 'confirmed',
      _ => 'requested', 
    };

    return AbsenceDetailsData(
      id: d.id,
      memberUserId: d.memberUserId.toString(),
      employeeName: employeeName,
      type: d.type,
      startDate: d.startDate,
      endDate: d.endDate,
      status: status,
      memberNote: d.memberNote?.isEmpty == true ? null : d.memberNote,
      admitterNote: d.admitterNote?.isEmpty == true ? null : d.admitterNote,
    );
  }

  factory AbsenceDetailsData.fromJson(Map<String, dynamic> j) =>
      _$AbsenceDetailsDataFromJson(j);
  Map<String, dynamic> toJson() => _$AbsenceDetailsDataToJson(this);
}
