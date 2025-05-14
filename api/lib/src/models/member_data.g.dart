// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberData _$MemberDataFromJson(Map<String, dynamic> json) => MemberData(
      id: (json['id'] as num).toInt(),
      crewId: (json['crewId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      name: json['name'] as String,
      image: json['image'] as String,
    );

Map<String, dynamic> _$MemberDataToJson(MemberData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'crewId': instance.crewId,
      'userId': instance.userId,
      'name': instance.name,
      'image': instance.image,
    };
