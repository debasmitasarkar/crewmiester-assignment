import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:crewmeister_absence_manager/core/error/failures.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/absence_response.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/repositories/absence_repository.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/usecases/get_absences.dart';

class MockRepo extends Mock implements AbsenceRepository {}

AbsenceResponse resp() => const AbsenceResponse(total: 0, items: []);

void main() {
  late MockRepo repo;
  late GetAbsences usecase;

  setUp(() {
    repo = MockRepo();
    usecase = GetAbsences(repo);
  });

  test('returns AbsenceResponse from repository', () async {
    when(() => repo.getAbsences(page: 0, size: 10))
        .thenAnswer((_) async => right(resp()));

    final result = await usecase(page: 0, size: 10);

    expect(result.isRight(), true);
    verify(() => repo.getAbsences(page: 0, size: 10)).called(1);
  });

  test('returns Failure from repository', () async {
    when(() => repo.getAbsences(page: 0, size: 10))
        .thenAnswer((_) async => left(const ServerFailure('err')));

    final result = await usecase(page: 0, size: 10);

    expect(result.isLeft(), true);
  });
}
