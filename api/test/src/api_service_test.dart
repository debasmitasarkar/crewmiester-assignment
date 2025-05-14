import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:absence_api/absence_api.dart';

ByteData bd(String s) => ByteData.view(Uint8List.fromList(utf8.encode(s)).buffer);

const absencesJson = '''
{
  "message":"Success",
  "payload":[
    { "id":1,"crewId":1,"userId":100,"type":"vacation","startDate":"2021-01-01","endDate":"2021-01-02","confirmedAt":null,"rejectedAt":null,"memberNote":"","admitterNote":"" },
    { "id":2,"crewId":1,"userId":101,"type":"sickness","startDate":"2021-02-01","endDate":"2021-02-02","confirmedAt":null,"rejectedAt":"2021-02-03","memberNote":"","admitterNote":"" },
    { "id":3,"crewId":1,"userId":100,"type":"vacation","startDate":"2021-03-01","endDate":"2021-03-02","confirmedAt":"2021-03-03","rejectedAt":null,"memberNote":"","admitterNote":"" }
  ]
}
''';

const membersJson = '''
{
  "message":"Success",
  "payload":[
    {"crewId":1,"id":1,"userId":100,"name":"Alice","image":""},
    {"crewId":1,"id":2,"userId":101,"name":"Bob","image":""}
  ]
}
''';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
    'flutter/assets',
    (msg) async {
      final key = utf8.decode(msg!.buffer.asUint8List());
      if (key.endsWith('absences.json')) return bd(absencesJson);
      if (key.endsWith('members.json')) return bd(membersJson);
      return null;
    },
  );

  final api = AbsenceApi();

  test('returns first page slice', () async {
    final resp = await api.getAbsences(page: 0, size: 2);
    expect(resp.total, 3);
    expect(resp.items.length, 2);
    expect(resp.items.first.employeeName, 'Alice');
    expect(resp.items.first.status, 'requested');
  });

  test('pagination second page', () async {
    final resp = await api.getAbsences(page: 1, size: 2);
    expect(resp.items.length, 1);
    expect(resp.items.first.id, 3);
    expect(resp.items.first.status, 'confirmed');
  });

  test('page out of range returns empty list', () async {
    final resp = await api.getAbsences(page: 5, size: 2);
    expect(resp.items, isEmpty);
    expect(resp.total, 3);
  });
}
