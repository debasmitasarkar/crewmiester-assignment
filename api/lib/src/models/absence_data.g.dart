// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absence_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AbsenceData _$AbsenceDataFromJson(Map<String, dynamic> json) => AbsenceData(
      id: (json['id'] as num).toInt(),
      crewId: (json['crewId'] as num).toInt(),
      memberUserId: (json['userId'] as num).toInt(),
      type: json['type'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      confirmedAt: json['confirmedAt'] as String?,
      rejectedAt: json['rejectedAt'] as String?,
      memberNote: json['memberNote'] as String?,
      admitterNote: json['admitterNote'] as String?,
    );

Map<String, dynamic> _$AbsenceDataToJson(AbsenceData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'crewId': instance.crewId,
      'userId': instance.memberUserId,
      'type': instance.type,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'confirmedAt': instance.confirmedAt,
      'rejectedAt': instance.rejectedAt,
      'memberNote': instance.memberNote,
      'admitterNote': instance.admitterNote,
    };
