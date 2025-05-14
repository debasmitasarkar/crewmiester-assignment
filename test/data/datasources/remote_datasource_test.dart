import 'dart:io';

import 'package:absence_api/absence_api.dart';
import 'package:crewmeister_absence_manager/core/error/failures.dart';
import 'package:crewmeister_absence_manager/features/absences/data/datasources/remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockApi extends Mock implements AbsenceApi {}

AbsenceResponseData makeResp() => AbsenceResponseData(
      total: 1,
      items: [
        AbsenceDetailsData(
          id: 1,
          memberUserId: '100',
          employeeName: 'Alice',
          type: 'vacation',
          startDate: '2021-01-01',
          endDate: '2021-01-02',
          status: 'requested',
        ),
      ],
    );

void main() {
  late _MockApi api;
  late RemoteAbsenceDataSource ds;

  setUp(() {
    api = _MockApi();
    ds = RemoteAbsenceDataSource(api: api);
  });

  test('returns Right on success', () async {
    when(() => api.getAbsences(page: 0, size: 10))
        .thenAnswer((_) async => makeResp());

    final res = await ds.fetchAbsences(page: 0, size: 10);

    expect(res.isRight(), true);
    expect(res.getOrElse(() => throw 0).total, 1);
  });

  test('maps SocketException to ServerFailure', () async {
    when(() => api.getAbsences(page: 0, size: 10))
        .thenThrow(const SocketException('offline'));

    final res = await ds.fetchAbsences(page: 0, size: 10);

    expect(res.isLeft(), true);
    expect(res.swap().getOrElse(() => throw 0), isA<ServerFailure>());
  });

  test('maps FormatException to DataParsingFailure', () async {
    when(() => api.getAbsences(page: 0, size: 10))
        .thenThrow(const FormatException('bad json'));

    final res = await ds.fetchAbsences(page: 0, size: 10);

    expect(res.isLeft(), true);
    expect(res.swap().getOrElse(() => throw 0), isA<DataParsingFailure>());
  });
}
