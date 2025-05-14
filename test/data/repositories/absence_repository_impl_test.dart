
import 'package:absence_api/absence_api.dart';
import 'package:crewmeister_absence_manager/core/error/failures.dart';
import 'package:crewmeister_absence_manager/core/network/network_info.dart';
import 'package:crewmeister_absence_manager/features/absences/data/datasources/remote_datasource.dart';
import 'package:crewmeister_absence_manager/features/absences/data/repositories/absence_repository_impl.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/absence_response.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDataSource extends Mock implements RemoteAbsenceDataSource {}

class MockNetwork extends Mock implements NetworkInfo {}

AbsenceResponseData respDto() => const AbsenceResponseData(total: 1, items: []);

void main() {
  late MockDataSource ds;
  late MockNetwork net;
  late AbsenceRepositoryImpl repo;

  setUp(() {
    ds = MockDataSource();
    net = MockNetwork();
    repo = AbsenceRepositoryImpl(dataSource: ds, networkInfo: net);
  });

  group('getAbsences', () {
    const page = 0, size = 10;

    test('returns NetworkFailure when offline', () async {
      when(() => net.isConnected).thenAnswer((_) async => false);

      final result = await repo.getAbsences(page: page, size: size);

      result.fold(
        (l) => expect(l, isA<NetworkFailure>()),
        (_) => fail('should be failure'),
      );
      verifyNever(() => ds.fetchAbsences(page: page, size: size));
    });

    test('returns mapped AbsenceResponse on success', () async {
      when(() => net.isConnected).thenAnswer((_) async => true);
      when(() => ds.fetchAbsences(page: page, size: size))
          .thenAnswer((_) async => right(respDto()));

      final result = await repo.getAbsences(page: page, size: size);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('expected right'),
        (r) => expect(r, isA<AbsenceResponse>()),
      );
    });

    test('propagates datasource failure', () async {
      when(() => net.isConnected).thenAnswer((_) async => true);
      when(() => ds.fetchAbsences(page: page, size: size))
          .thenAnswer((_) async => left(const ServerFailure('boom')));

      final result = await repo.getAbsences(page: page, size: size);

      result.fold(
        (l) => expect(l, isA<ServerFailure>()),
        (_) => fail('should be left'),
      );
    });

    test('catches FormatException and returns DataParsingFailure', () async {
      when(() => net.isConnected).thenAnswer((_) async => true);
      when(() => ds.fetchAbsences(page: page, size: size))
          .thenThrow(const FormatException('bad json'));

      final result = await repo.getAbsences(page: page, size: size);

      result.fold(
        (l) => expect(l, isA<DataParsingFailure>()),
        (_) => fail('should be left'),
      );
    });
  });
}
