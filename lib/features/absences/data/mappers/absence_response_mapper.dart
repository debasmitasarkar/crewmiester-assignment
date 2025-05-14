import 'package:absence_api/absence_api.dart'
    show AbsenceResponseData, AbsenceDetailsData;
import 'package:crewmeister_absence_manager/features/absences/domain/entities/absence_details.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/absence_response.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/enums.dart';

extension AbsenceDetailsDataX on AbsenceDetailsData {
  AbsenceDetails toDomain() => AbsenceDetails(
        id: id,
        employeeName: employeeName,
        employeeUserId: memberUserId,
        type: AbsenceType.values.firstWhere((e) => e.name == type),
        startDate: startDate,
        endDate: endDate,
        status: AbsenceStatus.values.firstWhere((e) => e.name == status),
        memberNote: memberNote?.isEmpty == true ? null : memberNote,
        admitterNote: admitterNote?.isEmpty == true ? null : admitterNote,
      );
}

extension AbsenceResponseDataX on AbsenceResponseData {
  AbsenceResponse toDomain() => AbsenceResponse(
        total: total,
        items: items.map((e) => e.toDomain()).toList(growable: false),
      );
}
