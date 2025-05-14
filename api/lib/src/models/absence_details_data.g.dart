// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absence_details_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AbsenceDetailsData _$AbsenceDetailsDataFromJson(Map<String, dynamic> json) =>
    AbsenceDetailsData(
      id: (json['id'] as num).toInt(),
      memberUserId: json['memberUserId'] as String,
      employeeName: json['employeeName'] as String,
      type: json['type'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      status: json['status'] as String,
      memberNote: json['memberNote'] as String?,
      admitterNote: json['admitterNote'] as String?,
    );

Map<String, dynamic> _$AbsenceDetailsDataToJson(AbsenceDetailsData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memberUserId': instance.memberUserId,
      'employeeName': instance.employeeName,
      'type': instance.type,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'status': instance.status,
      'memberNote': instance.memberNote,
      'admitterNote': instance.admitterNote,
    };
