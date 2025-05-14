import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:crewmeister_absence_manager/features/absences/presentation/widgets/note.dart';

Widget wrap(Widget w) => MaterialApp(home: Scaffold(body: w));

void main() {
  testWidgets('Note renders label and italic text', (tester) async {
    await tester.pumpWidget(
      wrap(const Note(label: 'Member note', text: 'Hello')),
    );

    final richFinder = find.byType(RichText);
    expect(richFinder, findsOneWidget);

    final rich = tester.widget<RichText>(richFinder);
    final spans = (rich.text as TextSpan).children!;
    expect(spans.length, 2);

    final labelSpan = spans[0] as TextSpan;
    final textSpan  = spans[1] as TextSpan;

    expect(labelSpan.text, 'Member note: ');
    expect(textSpan.text,  'Hello');
    expect(textSpan.style!.fontStyle, FontStyle.italic);
    expect(labelSpan.style?.fontStyle, isNot(FontStyle.italic));
  });
}
