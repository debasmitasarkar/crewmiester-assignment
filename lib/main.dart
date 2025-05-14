import 'package:crewmeister_absence_manager/features/absences/presentation/cubit/absence_cubit.dart';
import 'package:crewmeister_absence_manager/features/absences/presentation/pages/absence_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'features/absences/domain/repositories/absence_repository.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init(); 
  runApp(const CrewmeisterApp());
}

class CrewmeisterApp extends StatelessWidget {
  const CrewmeisterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AbsenceRepository>.value(value: sl()),
      ],
      child: BlocProvider(
        create: (_) => AbsenceCubit(sl()),
        child: MaterialApp(
          title: 'Crewmeister Absence Manager',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
            useMaterial3: true,
          ),
          home: const AbsencesPage(),
        ),
      ),
    );
  }
}
