import 'package:crewmeister_absence_manager/features/absences/domain/entities/enums.dart';
import 'package:equatable/equatable.dart';

class AbsenceDetails extends Equatable {
  final int id;
  final String employeeUserId;
  final String employeeName;
  final AbsenceType type;
  final String startDate;
  final String endDate;
  final AbsenceStatus status;
  final String? memberNote;
  final String? admitterNote;

  const AbsenceDetails({
    required this.id,
    required this.employeeName,
    required this.employeeUserId,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.memberNote,
    this.admitterNote,
  });

  @override
  List<Object?> get props => [
        id,
        employeeName,
        employeeUserId,
        type,
        startDate,
        endDate,
        status,
        memberNote,
        admitterNote,
      ];
}
