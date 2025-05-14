import 'package:absence_api/absence_api.dart';
import 'package:crewmeister_absence_manager/core/network/network_info.dart';
import 'package:crewmeister_absence_manager/features/absences/data/datasources/remote_datasource.dart';
import 'package:crewmeister_absence_manager/features/absences/data/repositories/absence_repository_impl.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/repositories/absence_repository.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/usecases/get_absences.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  sl.registerSingleton(AbsenceApi());
  sl.registerLazySingleton<RemoteAbsenceDataSource>(
      () => RemoteAbsenceDataSource(api: sl()));
  sl.registerLazySingleton<AbsenceRepository>(() =>
      AbsenceRepositoryImpl(dataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<GetAbsences>(() => GetAbsences(sl()));
}
