import 'dart:io';

import 'package:absence_api/absence_api.dart';
import 'package:crewmeister_absence_manager/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class RemoteAbsenceDataSource {
  RemoteAbsenceDataSource({required this.api});

  final AbsenceApi api;

  Future<Either<Failure, AbsenceResponseData>> fetchAbsences({
    required int page,
    required int size,
  }) async {
    try {
      final dto = await api.getAbsences(page: page, size: size);
      return right(dto);
    } on SocketException catch (e) {
      return left(ServerFailure('Network: $e'));
    } on FormatException catch (e) {
      return left(DataParsingFailure('JSON: $e'));
    }
  }
}
