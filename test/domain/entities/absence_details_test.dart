import 'package:flutter_test/flutter_test.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/absence_details.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/enums.dart';

AbsenceDetails make({
  int id = 1,
  AbsenceType type = AbsenceType.vacation,
  AbsenceStatus status = AbsenceStatus.requested,
}) =>
    AbsenceDetails(
      id: id,
      employeeName: 'Alice',
      employeeUserId: '100',
      type: type,
      startDate: '2021-01-01',
      endDate: '2021-01-02',
      status: status,
      memberNote: 'note',
      admitterNote: null,
    );

void main() {
  test('Equatable equality works', () {
    final a = make();
    final b = make();

    expect(a, equals(b));  
    expect(a.hashCode, b.hashCode);
  });

  test('Different field → not equal', () {
    final a = make();
    final diff = make(id: 2);

    expect(a == diff, isFalse);
  });

  test('props list contains all fields', () {
    final a = make();
    expect(
      a.props,
      [
        a.id,
        a.employeeName,
        a.employeeUserId,
        a.type,
        a.startDate,
        a.endDate,
        a.status,
        a.memberNote,
        a.admitterNote,
      ],
    );
  });
}
