import 'package:flutter_test/flutter_test.dart';
import 'package:crewmeister_absence_manager/features/absences/presentation/cubit/absence_cubit.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/absence_details.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/enums.dart';
import 'package:crewmeister_absence_manager/features/absences/presentation/models/absence_filter_model.dart';

AbsenceDetails makeAbs(int id) => AbsenceDetails(
      id: id,
      employeeName: 'U$id',
      employeeUserId: '$id',
      type: AbsenceType.vacation,
      startDate: '2021-01-01',
      endDate: '2021-01-01',
      status: AbsenceStatus.requested,
    );

void main() {
  group('Equatable states', () {
    test('AbsenceLoading equality', () {
      expect(AbsenceLoading(), equals(AbsenceLoading()));
    });

    test('AbsenceError equality by message', () {
      expect(const AbsenceError('x'), equals(const AbsenceError('x')));
      expect(const AbsenceError('x') == const AbsenceError('y'), isFalse);
    });

    test('AbsenceLoaded equality & copyWith', () {
      final base = AbsenceLoaded(
        loadedItems: [makeAbs(1)],
        filteredItems: [makeAbs(1)],
        total: 1,
        hasReachedMax: false,
        filters: const AbsenceFilters(),
        isLoading: false,
      );

      expect(base, equals(base.copyWith()));

      final changed = base.copyWith(
        loadedItems: [makeAbs(1), makeAbs(2)],
        total: 2,
        hasReachedMax: true,
      );

      expect(changed.loadedItems.length, 2);
      expect(changed.total, 2);
      expect(changed.hasReachedMax, true);
      expect(base == changed, isFalse);
    });
  });
}
