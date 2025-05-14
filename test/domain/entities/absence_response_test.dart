import 'package:flutter_test/flutter_test.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/absence_details.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/absence_response.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/enums.dart';

AbsenceDetails makeDetails(int id) => AbsenceDetails(
      id: id,
      employeeName: 'User$id',
      employeeUserId: '$id',
      type: AbsenceType.vacation,
      startDate: '2021-01-01',
      endDate: '2021-01-02',
      status: AbsenceStatus.requested,
      memberNote: null,
      admitterNote: null,
    );

void main() {
  test('equality', () {
    final items = [makeDetails(1), makeDetails(2)];
    final a = AbsenceResponse(total: 2, items: items);
    final b = AbsenceResponse(total: 2, items: List.from(items));
    expect(a, equals(b));
    expect(a.hashCode, b.hashCode);
  });

  test('inequality when total differs', () {
    final items = [makeDetails(1)];
    final a = AbsenceResponse(total: 1, items: items);
    final b = AbsenceResponse(total: 2, items: items);
    expect(a == b, isFalse);
  });

  test('props contains all fields', () {
    final resp = AbsenceResponse(total: 3, items: [makeDetails(1)]);
    expect(resp.props, [3, resp.items]);
  });
}
