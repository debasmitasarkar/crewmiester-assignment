import 'package:flutter_test/flutter_test.dart';
import 'package:absence_api/src/models/absence_data.dart';

void main() {
  group('AbsenceData JSON (de)serialisation', () {
    const fixture = {
      'id': 2351,
      'crewId': 352,
      'userId': 2664,
      'type': 'sickness',
      'startDate': '2021-01-13',
      'endDate': '2021-01-13',
      'confirmedAt': '2020-12-12T18:03:55.000+01:00',
      'rejectedAt': null,
      'memberNote': '',
      'admitterNote': '',
    };

    test('fromJson creates a valid DTO', () {
      final dto = AbsenceData.fromJson(fixture);

      expect(dto.id, equals(2351));
      expect(dto.crewId, equals(352));
      expect(dto.memberUserId, equals(2664));
      expect(dto.type, equals('sickness'));
      expect(dto.startDate, equals('2021-01-13'));
      expect(dto.endDate, equals('2021-01-13'));
      expect(dto.confirmedAt, isNotNull);
      expect(dto.rejectedAt, isNull);
    });
  });
}
