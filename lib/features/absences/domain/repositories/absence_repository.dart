import 'package:crewmeister_absence_manager/core/error/failures.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/absence_response.dart';
import 'package:dartz/dartz.dart';

abstract interface class AbsenceRepository {
  Future<Either<Failure, AbsenceResponse>> getAbsences({
    required int page,
    required int size,
  });
}
