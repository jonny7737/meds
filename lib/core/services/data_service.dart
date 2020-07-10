import 'package:flutter/foundation.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/core/models/doctor_data.dart';
import 'package:meds/core/models/med_data.dart';
import 'package:meds/core/services/doctor_data_repository.dart';
import 'package:meds/core/services/med_data_repository.dart';
import 'package:meds/core/services/repository_service.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/logger_viewmodel.dart';

class DataService with Logger, ChangeNotifier implements RepositoryService {
  LoggerViewModel _debug = locator();
  MedDataRepository _medRepository;
  DoctorDataRepository _doctorRepository;

  DataService() {
    setLogging(_debug.isLogging(MED_REPOSITORY_LOGS) || _debug.isLogging(DOCTOR_REPOSITORY_LOGS));

    _medRepository = locator<MedDataRepository>();
    _medRepository.addListener(updatedMeds);

    _doctorRepository = locator<DoctorDataRepository>();
  }

  @override
  void dispose() {
    _medRepository.removeListener(updatedMeds);
    super.dispose();
  }

  void updatedMeds() {
    log('Updating Meds list', linenumber: lineNumber(StackTrace.current));
    notifyListeners();
  }

  @override
  bool get onlyOneUser => _medRepository.onlyOneUser;

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

  @override
  DoctorData getDoctorById(int id) {
    return _doctorRepository.getById(id);
  }

  Future clearAllMeds() async {
    await _medRepository.deleteAll();
  }

  Future clearAllDoctors() async {
    await _doctorRepository.deleteAll();
  }

  @override
  Future<void> save(Object newObject, {int editIndex}) async {
    String _action;

    if (newObject is MedData) {
      MedData _md = _medRepository.getByRxcui(newObject.rxcui);

      if (_md == null)
        _action = 'ADDED';
      else
        _action = 'UPDATED';

      await _medRepository.save(newObject);
      log(
        'Medication $_action - ${newObject.name} [$editIndex]',
        linenumber: lineNumber(StackTrace.current),
      );
    } else if (newObject is DoctorData) {
      DoctorData _dd = _doctorRepository.getById(newObject.id);
      if (_dd == null)
        _action = 'ADDED';
      else
        _action = 'UPDATED';

      await _doctorRepository.save(newObject);
      log('Doctor $_action - ${newObject.name}');
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
    _medRepository.deleteBox();
    return null;
  }

  @override
  Future initializeDoctorData() {
    throw UnimplementedError();
  }

  @override
  Future initializeMedData() {
    throw UnimplementedError();
  }
}
