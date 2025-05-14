import 'package:dartz/dartz.dart';

import 'package:crewmeister_absence_manager/core/error/failures.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/absence_response.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/repositories/absence_repository.dart';

class GetAbsences {
  final AbsenceRepository repo;
  const GetAbsences(this.repo);

  Future<Either<Failure, AbsenceResponse>> call({
    required int page,
    required int size,
  }) =>
      repo.getAbsences(page: page, size: size);
}
