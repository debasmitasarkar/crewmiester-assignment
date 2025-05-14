import 'package:flutter_test/flutter_test.dart';
import 'package:absence_api/src/models/absence_data.dart';
import 'package:absence_api/src/models/absence_details_data.dart';
import 'package:absence_api/src/models/absence_response_data.dart';

AbsenceDetailsData makeDetails(int id) {
  final dto = AbsenceData(
    id: id,
    crewId: 1,
    memberUserId: 100 + id,
    type: 'vacation',
    startDate: '2021-01-01',
    endDate: '2021-01-02',
    confirmedAt: null,
    rejectedAt: null,
    memberNote: '',
    admitterNote: '',
  );
  return AbsenceDetailsData.from(dto, 'User $id');
}

void main() {
  test('AbsenceResponseData stores total and items', () {
    final list = List.generate(3, makeDetails);
    final resp = AbsenceResponseData(total: 3, items: list);

    expect(resp.total, 3);
    expect(resp.items.length, 3);
    expect(resp.items.first.id, 0);
  });
}
