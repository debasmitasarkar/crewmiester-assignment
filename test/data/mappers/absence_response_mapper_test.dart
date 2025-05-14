import 'package:flutter_test/flutter_test.dart';
import 'package:absence_api/absence_api.dart'
    show AbsenceDetailsData, AbsenceResponseData;
import 'package:crewmeister_absence_manager/features/absences/data/mappers/absence_response_mapper.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/absence_details.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/enums.dart';

AbsenceDetailsData makeDto({
  int id = 1,
  String type = 'vacation',
  String status = 'confirmed',
  String? memberNote = 'note',
  String? admitterNote = '',
}) =>
    AbsenceDetailsData(
      id: id,
      memberUserId: '100',
      employeeName: 'Alice',
      type: type,
      startDate: '2021-01-01',
      endDate: '2021-01-02',
      status: status,
      memberNote: memberNote,
      admitterNote: admitterNote,
    );

void main() {
  test('AbsenceDetailsData → AbsenceDetails mapping', () {
    final dto = makeDto();
    final domain = dto.toDomain();

    expect(domain, isA<AbsenceDetails>());
    expect(domain.id, dto.id);
    expect(domain.employeeName, dto.employeeName);
    expect(domain.employeeUserId, dto.memberUserId);
    expect(domain.type, AbsenceType.vacation);
    expect(domain.status, AbsenceStatus.confirmed);
    expect(domain.memberNote, 'note');
    expect(domain.admitterNote, isNull);
  });

  test('AbsenceResponseData → AbsenceResponse mapping', () {
    final dtoList = [makeDto(id: 1), makeDto(id: 2, status: 'requested')];
    final respDto = AbsenceResponseData(total: 2, items: dtoList);

    final domainResp = respDto.toDomain();

    expect(domainResp.total, 2);
    expect(domainResp.items.length, 2);
    expect(domainResp.items.first.id, 1);
    expect(domainResp.items.last.status, AbsenceStatus.requested);
  });
}
