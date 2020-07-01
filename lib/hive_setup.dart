import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/core/models/doctor_data.dart';
import 'package:meds/core/models/med_data.dart';
import 'package:meds/core/services/repository_service.dart';
import 'package:meds/locator.dart';

class HiveSetup with Logger {
  HiveSetup({bool purge = false}) {
    setDebug(false);

    log('HiveSetup started');

    _initializeHive(purge: purge);
  }
  void _initializeHive({bool purge = false}) async {
    log('Initializing Hive, Purge All Data: $purge');
    await Hive.initFlutter(kHiveDirectory);

    Hive.registerAdapter(MedDataAdapter());
    Hive.registerAdapter(DoctorDataAdapter());

    if (purge) {
      Future.wait([
        Hive.deleteBoxFromDisk(kMedHiveBox),
        Hive.deleteBoxFromDisk(kDoctorHiveBox),
      ]);
      _initializeFakeData();
    }
    log('HiveSetup complete');
  }

  Future _initializeFakeData() async {
    RepositoryService repository = locator<RepositoryService>();
    await repository.initializeMedData();
    await repository.initializeDoctorData();
  }
}
