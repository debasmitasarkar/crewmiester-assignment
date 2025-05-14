import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:crewmeister_absence_manager/features/absences/presentation/widgets/status_pill.dart';

Widget wrap(Widget w) => MaterialApp(home: Scaffold(body: w));

void main() {
  testWidgets('StatusPill shows label, icon and uses colour',
      (WidgetTester tester) async {
    const label = 'Confirmed';
    const colour = Colors.green;
    const iconData = Icons.check_rounded;

    await tester.pumpWidget(
      wrap(const StatusPill(label: label, colour: colour, icon: iconData)),
    );

    expect(find.text(label), findsOneWidget);
    expect(find.byIcon(iconData), findsOneWidget);

    final iconWidget = tester.widget<Icon>(find.byIcon(iconData));
    expect(iconWidget.size, 14);
    expect(iconWidget.color, Colors.white);

    final container = tester
        .widget<Container>(find
            .ancestor(
              of: find.byType(Icon),
              matching: find.byType(Container),
            )
            .first);
    final BoxDecoration? decoration = container.decoration as BoxDecoration?;
    expect(decoration?.color, colour);
    expect(decoration?.borderRadius, BorderRadius.circular(30));
  });
}
