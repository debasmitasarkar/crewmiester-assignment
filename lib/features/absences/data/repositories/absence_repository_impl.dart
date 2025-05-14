import 'package:dartz/dartz.dart';

import 'package:crewmeister_absence_manager/core/error/failures.dart';
import 'package:crewmeister_absence_manager/core/network/network_info.dart';
import 'package:crewmeister_absence_manager/features/absences/data/datasources/remote_datasource.dart';
import 'package:crewmeister_absence_manager/features/absences/data/mappers/absence_response_mapper.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/absence_response.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/repositories/absence_repository.dart';

class AbsenceRepositoryImpl implements AbsenceRepository {
  AbsenceRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  final RemoteAbsenceDataSource dataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, AbsenceResponse>> getAbsences(
      {required int page, required int size}) async {
    if (await networkInfo.isConnected == false) {
      return left(const NetworkFailure('No internet connection'));
    }
    try {
      final result = await dataSource.fetchAbsences(
        page: page,
        size: size,
      );
      return result.map((dto) => dto.toDomain());
    } on FormatException catch (e) {
      return left(DataParsingFailure('JSON: $e'));
    }
  }
}
