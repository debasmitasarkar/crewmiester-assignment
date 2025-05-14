import 'package:bloc_test/bloc_test.dart';
import 'package:crewmeister_absence_manager/features/absences/presentation/pages/absence_page.dart';
import 'package:crewmeister_absence_manager/features/absences/presentation/widgets/absence_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:crewmeister_absence_manager/features/absences/presentation/cubit/absence_cubit.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/enums.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/absence_details.dart';
import 'package:crewmeister_absence_manager/features/absences/presentation/models/absence_filter_model.dart';

class MockCubit extends Mock implements AbsenceCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockCubit cubit;

  AbsenceDetails makeAbs(int id) => AbsenceDetails(
        id: id,
        employeeName: 'U$id',
        employeeUserId: '$id',
        type: AbsenceType.vacation,
        startDate: '2021-01-01',
        endDate: '2021-01-01',
        status: AbsenceStatus.requested,
      );

  setUp(() {
    cubit = MockCubit();
  });

  Future<void> pump(WidgetTester t) async {
    await t.pumpWidget(
      MaterialApp(
        home: BlocProvider<AbsenceCubit>.value(
          value: cubit,
          child: const AbsencesPage(),
        ),
      ),
    );
  }

  testWidgets('shows shimmer when loading', (t) async {
    when(() => cubit.state).thenReturn(AbsenceLoading());
    whenListen(cubit, Stream<AbsenceState>.fromIterable([AbsenceLoading()]));
    await pump(t);
    expect(find.byType(AbsenceCardShimmer), findsNWidgets(6));
  });

  testWidgets('shows error text', (t) async {
    when(() => cubit.state).thenReturn(const AbsenceError('err'));
    whenListen(cubit, Stream<AbsenceState>.fromIterable([const AbsenceError('err')]));
    await pump(t);
    expect(find.text('err'), findsOneWidget);
  });

  testWidgets('shows list & total on loaded', (t) async {
    final loaded = AbsenceLoaded(
      loadedItems: [makeAbs(1), makeAbs(2)],
      filteredItems: [makeAbs(1), makeAbs(2)],
      total: 2,
      hasReachedMax: true,
      filters: const AbsenceFilters(),
      isLoading: false,
    );
    when(() => cubit.state).thenReturn(loaded);
    whenListen(cubit, Stream<AbsenceState>.fromIterable([loaded]));
    await pump(t);
    expect(find.text('Total absences: '), findsOneWidget);
    expect(find.byType(AbsenceCard), findsNWidgets(2));
  });
}
