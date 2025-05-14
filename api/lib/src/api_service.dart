import 'dart:convert';
import 'package:absence_api/src/models/absence_details_data.dart';
import 'package:absence_api/src/models/absence_response_data.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'models/absence_data.dart';
import 'models/member_data.dart';

const _absencesPath = 'packages/absence_api/json_files/absences.json';
const _membersPath  = 'packages/absence_api/json_files/members.json';

class AbsenceApi {
  List<AbsenceData>? _cachedAbsences;
  List<MemberData>? _cachedMembers;
  List<AbsenceDetailsData>? _joined; 

  Future<AbsenceResponseData> getAbsences({int page = 0, int size = 10}) async {
    if (_joined == null) await _loadAndJoin();

    final start = page * size;
    final slice = start >= _joined!.length
        ? <AbsenceDetailsData>[]
        : _joined!.skip(start).take(size).toList();
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return AbsenceResponseData(total: _joined!.length, items: slice);
  }

  Future<void> _loadAndJoin() async {
    final rawAbs = await rootBundle.loadString(_absencesPath);
    _cachedAbsences = (jsonDecode(rawAbs)['payload'] as List)
        .map((e) => AbsenceData.fromJson(e as Map<String, dynamic>))
        .toList();

    final rawMem = await rootBundle.loadString(_membersPath);
    _cachedMembers = (jsonDecode(rawMem)['payload'] as List)
        .map((e) => MemberData.fromJson(e as Map<String, dynamic>))
        .toList();

    final nameMap = {
      for (final m in _cachedMembers!) m.userId: m.name,
    };

    _joined = _cachedAbsences!
        .where((a) => nameMap.containsKey(a.memberUserId))
        .map((a) => AbsenceDetailsData.from(a, nameMap[a.memberUserId]!))
        .toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
  }
}
