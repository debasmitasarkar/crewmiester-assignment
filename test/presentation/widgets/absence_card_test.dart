import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/absence_details.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/enums.dart';
import 'package:crewmeister_absence_manager/features/absences/presentation/widgets/absence_card.dart';
import 'package:crewmeister_absence_manager/features/absences/presentation/widgets/status_pill.dart';
import 'package:crewmeister_absence_manager/features/absences/presentation/widgets/note.dart';
import 'package:shimmer/shimmer.dart';

AbsenceDetails makeDetails({
  AbsenceStatus status = AbsenceStatus.confirmed,
  String? memberNote = 'note',
  String? admitterNote,
}) =>
    AbsenceDetails(
      id: 1,
      employeeName: 'Alice',
      employeeUserId: '100',
      type: AbsenceType.vacation,
      startDate: '2021-01-01',
      endDate: '2021-01-02',
      status: status,
      memberNote: memberNote,
      admitterNote: admitterNote,
    );

Widget wrap(Widget w) => MaterialApp(home: Scaffold(body: w));

void main() {
  testWidgets('AbsenceCard renders core info & status pill', (tester) async {
    await tester.pumpWidget(wrap(AbsenceCard(absence: makeDetails())));

    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Type: Vacation'), findsOneWidget);
    expect(find.byType(StatusPill), findsOneWidget);
    expect(find.byType(Note), findsOneWidget);
  });

  testWidgets('AbsenceCard hides empty notes', (tester) async {
    await tester.pumpWidget(
      wrap(
        AbsenceCard(absence: makeDetails(memberNote: null, admitterNote: null)),
      ),
    );

    expect(find.byType(Note), findsNothing);
  });

  testWidgets('AbsenceCardShimmer shows shimmer container', (tester) async {
    await tester.pumpWidget(wrap(const AbsenceCardShimmer()));
    expect(find.byType(Shimmer), findsOneWidget);
  });
}
