import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

import 'package:crewmeister_absence_manager/core/error/failures.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/usecases/get_absences.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/absence_details.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/absence_response.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/enums.dart';
import 'package:crewmeister_absence_manager/features/absences/presentation/cubit/absence_cubit.dart';

class MockGetAbsences extends Mock implements GetAbsences {}

AbsenceDetails makeAbs(int id, AbsenceType t) => AbsenceDetails(
      id: id,
      employeeName: 'U$id',
      employeeUserId: '$id',
      type: t,
      startDate: '2021-01-0$id',
      endDate: '2021-01-0$id',
      status: AbsenceStatus.requested,
    );

void main() {
  late MockGetAbsences uc;

  setUp(() {
    uc = MockGetAbsences();
    registerFallbackValue(0);
  });

  blocTest<AbsenceCubit, AbsenceState>(
    'emits Loading → Loaded on success',
    build: () {
      when(() => uc(page: any(named: 'page'), size: any(named: 'size')))
          .thenAnswer((_) async => right(AbsenceResponse(
              total: 2, items: [makeAbs(1, AbsenceType.vacation)])));
      return AbsenceCubit(uc);
    },
    expect: () => [
      isA<AbsenceLoaded>()
          .having((s) => s.filteredItems.length, 'items', 1)
          .having((s) => s.total, 'total', 2),
    ],
  );

  blocTest<AbsenceCubit, AbsenceState>(
    'emits Error on failure',
    build: () {
      when(() => uc(page: any(named: 'page'), size: any(named: 'size')))
          .thenAnswer((_) async => left(const ServerFailure('err')));
      return AbsenceCubit(uc);
    },
    expect: () => [
      isA<AbsenceError>(),
    ],
  );
  blocTest<AbsenceCubit, AbsenceState>(
    'loadNext appends items',
    build: () {
      when(() => uc(page: 0, size: 10)).thenAnswer(
        (_) async => right(
          AbsenceResponse(
            total: 3,
            items: [makeAbs(1, AbsenceType.vacation)],
          ),
        ),
      );
      when(() => uc(page: 1, size: 10)).thenAnswer(
        (_) async => right(
          AbsenceResponse(
            total: 3,
            items: [
              makeAbs(2, AbsenceType.sickness),
              makeAbs(3, AbsenceType.vacation),
            ],
          ),
        ),
      );
      return AbsenceCubit(uc);
    },
    act: (c) async {
      await Future.delayed(Duration.zero);
      await c.loadNext();
    },
    skip: 2,
    expect: () => [
      isA<AbsenceLoaded>()
          .having((s) => s.loadedItems.length, 'loaded', 3)
          .having((s) => s.hasReachedMax, 'max', true),
    ],
  );

  blocTest<AbsenceCubit, AbsenceState>(
    'applyType filters list',
    build: () {
      when(() => uc(page: any(named: 'page'), size: any(named: 'size')))
          .thenAnswer(
        (_) async => right(
          AbsenceResponse(
            total: 2,
            items: [
              makeAbs(1, AbsenceType.vacation),
              makeAbs(2, AbsenceType.sickness),
            ],
          ),
        ),
      );
      return AbsenceCubit(uc);
    },
    act: (c) async {
      await Future.delayed(Duration.zero);
      await c.applyType(AbsenceType.vacation);
    },
    expect: () => [
      isA<AbsenceLoaded>(),
      isA<AbsenceLoaded>()
          .having((s) => s.filteredItems.length, 'filtered', 1)
          .having((s) => s.filters.type, 'typeFilter', AbsenceType.vacation),
    ],
  );
}
