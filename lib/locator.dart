import 'package:get_it/get_it.dart';
import 'package:meds/core/models/logger_model.dart';
import 'package:meds/core/models/user_model.dart';
import 'package:meds/core/services/doctor_data_box.dart';
import 'package:meds/core/services/doctor_data_repository.dart';
import 'package:meds/core/services/data_service.dart';
import 'package:meds/core/services/med_data_box.dart';
import 'package:meds/core/services/med_data_repository.dart';
import 'package:meds/core/services/repository_service.dart';
import 'package:meds/ui/view_model/logger_viewmodel.dart';
import 'package:meds/ui/view_model/screen_info_viewmodel.dart';
import 'package:meds/ui/view_model/user_viewmodel.dart';
import 'package:meds/ui/views/doctors/doctors_viewmodel.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<UserModel>(() => UserModel());
  locator.registerLazySingleton<UserViewModel>(() => UserViewModel());

  locator.registerLazySingleton<LoggerModel>(() => LoggerModel());
  locator.registerLazySingleton<DebugViewModel>(() => DebugViewModel());

  locator.registerLazySingleton<MedDataBox>(() => MedDataBox());
  locator.registerLazySingleton<DoctorDataBox>(() => DoctorDataBox());
  locator.registerLazySingleton<MedDataRepository>(() => MedDataRepository());
  locator.registerLazySingleton<DoctorDataRepository>(() => DoctorDataRepository());

  locator.registerLazySingleton<RepositoryService>(() => DataService());

  locator.registerLazySingleton<DoctorsViewModel>(() => DoctorsViewModel());

  locator.registerLazySingleton(() => ScreenInfoViewModel());
}
