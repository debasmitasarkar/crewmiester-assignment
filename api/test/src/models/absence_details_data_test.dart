import 'package:flutter_test/flutter_test.dart';
import 'package:absence_api/src/models/absence_data.dart';
import 'package:absence_api/src/models/absence_details_data.dart';

void main() {
  AbsenceData makeDto({
    String? confirmedAt,
    String? rejectedAt,
    String? memberNote,
    String? admitterNote,
  }) =>
      AbsenceData(
        id: 1,
        crewId: 1,
        memberUserId: 100,
        type: 'vacation',
        startDate: '2021-01-01',
        endDate: '2021-01-02',
        confirmedAt: confirmedAt,
        rejectedAt: rejectedAt,
        memberNote: memberNote,
        admitterNote: admitterNote,
      );

  group('AbsenceDetailsData.from', () {
    test('status → requested when both timestamps null', () {
      final details = AbsenceDetailsData.from(makeDto(), 'Alice');
      expect(details.status, 'requested');
    });

    test('status → rejected when only rejectedAt present', () {
      final dto = makeDto(rejectedAt: '2021-01-03T10:00:00Z');
      final details = AbsenceDetailsData.from(dto, 'Bob');
      expect(details.status, 'rejected');
    });

    test('status → confirmed when only confirmedAt present', () {
      final dto = makeDto(confirmedAt: '2021-01-03T10:00:00Z');
      final details = AbsenceDetailsData.from(dto, 'Carol');
      expect(details.status, 'confirmed');
    });

    test('empty notes become null', () {
      final dto = makeDto(memberNote: '', admitterNote: '');
      final details = AbsenceDetailsData.from(dto, 'Dave');
      expect(details.memberNote, isNull);
      expect(details.admitterNote, isNull);
    });

    test('toJson / fromJson round-trip retains every field', () {
      final dto = makeDto(
        confirmedAt: '2021-01-03T10:00:00Z',
        memberNote: 'feel better',
      );

      final original = AbsenceDetailsData.from(dto, 'Eve');
      final copy = AbsenceDetailsData.fromJson(original.toJson());

      expect(copy.id, original.id);
      expect(copy.memberUserId, original.memberUserId);
      expect(copy.employeeName, original.employeeName);
      expect(copy.type, original.type);
      expect(copy.startDate, original.startDate);
      expect(copy.endDate, original.endDate);
      expect(copy.status, original.status);
      expect(copy.memberNote, original.memberNote);
      expect(copy.admitterNote, original.admitterNote);
    });
  });
}
