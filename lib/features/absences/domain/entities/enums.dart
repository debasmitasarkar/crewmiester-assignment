enum AbsenceType {
  vacation,
  sickness;

  String get label => switch (this) {
        AbsenceType.vacation => 'Vacation',
        AbsenceType.sickness => 'Sickness',
      };
}

enum AbsenceStatus {
  requested,
  confirmed,
  rejected;

  String get label => switch (this) {
        AbsenceStatus.requested => 'Requested',
        AbsenceStatus.confirmed => 'Confirmed',
        AbsenceStatus.rejected => 'Rejected',
      };
}
