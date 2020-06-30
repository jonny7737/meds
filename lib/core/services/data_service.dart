import 'package:flutter/foundation.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/core/models/doctor_data.dart';
import 'package:meds/core/models/med_data.dart';
import 'package:meds/core/services/doctor_data_repository.dart';
import 'package:meds/core/services/med_data_repository.dart';
import 'package:meds/core/services/repository_service.dart';
import 'package:meds/locator.dart';

class DataService with Logger, ChangeNotifier implements RepositoryService {
  MedDataRepository _medRepository;
  DoctorDataRepository _doctorRepository;

  DataService() {
    setDebug(false);

    _medRepository = locator<MedDataRepository>();
    _medRepository.addListener(() {
      log('Update Meds list', linenumber: lineNumber(StackTrace.current));
      notifyListeners();
    });

    _doctorRepository = locator<DoctorDataRepository>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  int get numberOfMeds => _medRepository.size();
  MedData getMedAtIndex(int index) => _medRepository.getAtIndex(index);

  @override
  int get numberOfDoctors => _doctorRepository.size();

  @override
  List<MedData> getAllMeds() {
    List<MedData> medList = _medRepository.getAll();
    return medList;
  }

  MedData getMedByRxcui(String rxcui) {
    return _medRepository.getByRxcui(rxcui);
  }

  /// Returns a Name sorted list of doctors.
  ///
  /// Sort is from the 'name' field NOT lastName, firstName
  ///
  @override
  List<DoctorData> getAllDoctors() {
    List<DoctorData> doctorList = _doctorRepository.getAll()..sort((a, b) => a.name.compareTo(b.name));
    return doctorList;
  }

  @override
  DoctorData getDoctorByName(String name) {
    return _doctorRepository.getByName(name);
  }

  Future clearAllMeds() async {
    await _medRepository.deleteAll();
    // TODO: Delete all RXCUI.jpg from medImages directory.
  }

  Future clearAllDoctors() async {
    await _doctorRepository.deleteAll();
  }

  @override
  Future<void> save(Object newObject, {bool fakeData = false}) async {
    bool _exists = false;
    int matchId = -1;
    String _action;

    if (newObject is MedData) {
      if (!fakeData) {
        List<MedData> medList = getAllMeds();
        medList.forEach((med) {
          if (med.compareTo(newObject) == 0) {
            _exists = true;
          }
          if (_exists) {
            matchId = med.id;
          }
        });
      }
      if (matchId == -1)
        _action = 'ADDED';
      else
        _action = 'UPDATED';

      await _medRepository.save(newObject, index: matchId);
      log('Medication $_action - ${newObject.name} [$matchId]');
    } else if (newObject is DoctorData) {
      var doctorList = getAllDoctors();
      int index = 0;
      doctorList.forEach((doctor) {
        log('[${doctor.name}] == [${newObject.name}] : ${doctor.name == newObject.name}');
        if (doctor.name == newObject.name) {
          log('DoctorId: ${doctor.id}');
          if (matchId == -1) matchId = index;
        }
        index++;
      });
      await _doctorRepository.save(newObject, index: matchId);
      if (matchId == -1)
        _action = 'ADDED';
      else
        _action = 'UPDATED';
      log('Doctor $_action - ${newObject.name} [$matchId]');
    }
  }

  @override
  Future<void> delete(Object objectToDelete) async {
    if (objectToDelete is MedData) {
      await _medRepository.delete(objectToDelete);
    }
    if (objectToDelete is DoctorData) {
      _doctorRepository.delete(objectToDelete);
      //log('Doctor Deleted: ${objectToDelete.name}');
    }
  }

  @override
  Future deleteDoctorBox() async {
    _doctorRepository.deleteBox();
    return null;
  }

  @override
  Future deleteMedBox() async {
    // TODO: Delete all RXCUI.jpg from medImages directory.
    _medRepository.deleteBox();
    return null;
  }

  @override
  Future initializeDoctorData() {
    // TODO: implement initializeDoctorData
    throw UnimplementedError();
  }

  @override
  Future initializeMedData() {
    // TODO: implement initializeMedData
    throw UnimplementedError();
  }
}
