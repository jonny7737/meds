import 'package:flutter/foundation.dart';
import 'package:meds/core/models/doctor_data.dart';
import 'package:meds/core/models/med_data.dart';

abstract class RepositoryService with ChangeNotifier {
  int get numberOfMeds;

  int get numberOfDoctors;

  bool get onlyOneUser;

  Future<void> save(Object newObject, {int editIndex});

  Future<void> delete(Object objectToDelete);

  MedData getMedAtIndex(int index);

  List<MedData> getAllMeds();

  Future clearAllMeds();

  DoctorData getDoctorByName(String name);

  DoctorData getDoctorById(int id);

  MedData getMedByRxcui(String rxcui);

  List<DoctorData> getAllDoctors();

  Future clearAllDoctors();

  Future deleteMedBox();

  Future deleteDoctorBox();

  Future initializeMedData();

  Future initializeDoctorData();
}
