import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/helpers/med_request.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/core/models/doctor_data.dart';
import 'package:meds/core/models/med_data.dart';
import 'package:meds/core/models/temp_med.dart';
import 'package:meds/core/services/repository_service.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/logger_viewmodel.dart';
import 'package:meds/ui/view_model/user_viewmodel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class AddMedViewModel extends ChangeNotifier with Logger {
  String imageDirectoryPath;
  final UserViewModel _userModel = locator();
  final LoggerViewModel _logs = locator();

  AddMedViewModel() {
    setLogging(_logs.isLogging(ADDMED_LOGS));
    _setImageDirectory();
  }

  RepositoryService _repository = locator();

  bool _isDisposed = false;
  int editIndex;

  var formKey;
  void setFormKey(formKey) => this.formKey = formKey;

  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    log('Has been disposed.', linenumber: lineNumber(StackTrace.current));
    super.dispose();
  }

  /// **********************************************************************
  String newMedName;
  String newMedDose;
  String newMedFrequency;
  String newMedDoctorName;
  int newMedDoctorId;

  String get fancyDoctorName {
    String _name;

    log('[$editIndex][$newMedDoctorName]', linenumber: lineNumber(StackTrace.current));

    if (editIndex == null) {
      if (newMedDoctorName == null)
        _name = doctorNames[0];
      else
        _name = 'Dr. ' + newMedDoctorName;
    } else
      _name = 'Dr. ' + newMedDoctorName;

    log('$_name', linenumber: lineNumber(StackTrace.current));
    return _name;
  }

  String reformatMedName(String medName, String dose) {
    String _newName = '';
    List<String> _nameSplit = medName.split(' ');
    for (int i = 0; i < _nameSplit.length; i++) {
      if (dose.startsWith(_nameSplit[i])) {
        for (int j = 0; j < i; j++) {
          _newName = _newName + _nameSplit[j] + ' ';
        }
        break;
      }
    }
    return _newName;
  }

  void setMedForEditing(int index) {
    if (index == null) {
//      clearNewMed();
      return;
    }

    editIndex = index;
    MedData _md = medAtEditIndex;

    log('${_md.doctorId}', linenumber: lineNumber(StackTrace.current));

    newMedName = reformatMedName(_md.name, _md.dose);
    newMedDose = _md.dose;
    newMedFrequency = _md.frequency;
    if (newMedDoctorId == null) newMedDoctorId = _md.doctorId;
    newMedDoctorName = getDoctorById(newMedDoctorId).name;

    log('${_md.doctorId}', linenumber: lineNumber(StackTrace.current));
  }

  String formInitialValue(String fieldName) {
    if (fieldName == 'name') return newMedName;
    if (fieldName == 'dose') return newMedDose;
    if (fieldName == 'frequency') return newMedFrequency;
    return 'Error';
  }

  MedData get medAtEditIndex => editIndex != null ? _repository.getMedAtIndex(editIndex) : null;

//  void _setMedName(String name) => newMedName = name;
//  void _setMedDose(String dose) => newMedDose = dose;
//  void _setMedFrequency(String frequency) => newMedFrequency = frequency;
  void _setMedDoctorId(String name) {
//    log('$name', linenumber: lineNumber(StackTrace.current));
    if (name.toLowerCase().startsWith('dr.')) {
      int i = name.indexOf(' ') + 1;
      name = name.substring(i);
    }
    newMedDoctorName = name;
    newMedDoctorId = _repository.getDoctorByName(name).id;
    log('$newMedDoctorName:$newMedDoctorId', linenumber: lineNumber(StackTrace.current));
  }

  void onFormSave(String formField, String value) {
    if (value == null || value.isEmpty) {
      showError(formField);
      setFormError(true);
    } else {
      setFormError(false);
      if (formField == 'name') newMedName = value;
      if (formField == 'dose') newMedDose = value;
      if (formField == 'frequency') newMedFrequency = value;
      if (formField == 'doctor') {
        if (value.toLowerCase().startsWith('dr.')) {
          int i = value.indexOf(' ') + 1;
          value = value.substring(i);
        }
        _setMedDoctorId(value);
        notifyListeners();
      }
    }
  }

  void clearNewMed() {
    editIndex = null;
    newMedName = null;
    newMedDose = null;
    newMedFrequency = null;
    newMedDoctorName = null;
    newMedDoctorId = null;
    log('New Med Info cleared.', linenumber: lineNumber(StackTrace.current));
  }

  void logEditIndex() {
    if (editIndex == null) return;
    MedData _md = _repository.getMedAtIndex(editIndex);
    log(
      '$editIndex: ${_md.name} : ${_md.doctorId}',
      linenumber: lineNumber(StackTrace.current),
    );
  }

  DoctorData getDoctorById(int id) => _repository.getDoctorById(id);

  List<String> get doctorNames {
    List<String> _doctorNames = [];
    List<DoctorData> _dd = _repository.getAllDoctors();
    for (var element in _dd) {
      _doctorNames.add('Dr. ' + element.name);
    }
    return _doctorNames;
  }

  List<Map<String, String>> doctorsForDropDown() {
    List<Map<String, String>> doctors = [];

    for (String doctor in doctorNames) {
      doctors.add({'display': doctor, 'value': doctor});
    }

    return doctors;
  }

  /// **********************************************************************
  bool _busy = false;
  bool _medsLoaded = false;
  bool _medsAdded = false;
  int _formErrors = 0;
  int _numMedsFound = 0;
  String _rxcuiComment;
  TempMed _tempMed;
  MedData _selectedMed;

  final double _errorMsgMaxHeight = 35;
  double nameErrorMsgHeight = 0;
  double doseErrorMsgHeight = 0;
  double frequencyErrorMsgHeight = 0;
  final String nameErrorMsg = 'Medication name is required.';
  final String doseErrorMsg = 'Dosage information is required.';
  final String frequencyErrorMsg = 'This information is required.';
  final Duration _secondsToDisplayErrorMsg = Duration(seconds: 4);

  bool get hasNewMed {
    log('$newMedName : $newMedDose', linenumber: lineNumber(StackTrace.current));
    if (newMedName == null || newMedDose == null || newMedFrequency == null) return false;
    if (newMedName.length > 2 && newMedDose.length > 2 && newMedFrequency.length > 3) return true;
    return false;
  }

  bool get formHasErrors {
    if (_formErrors != 0) {
      return true;
    }
    return false;
  }

  void setFormError(bool errors) {
    errors ? _formErrors++ : _formErrors--;
    if (_formErrors < 0) _formErrors = 0;
  }

  void clearFormError() => _formErrors = 0;

//  double get nameErrorMsgHeight => _medNameErrorMsgHeight;
//  double get doseErrorMsgHeight => _medDoseErrorMsgHeight;
//  double get frequencyErrorMsgHeight => _frequencyErrorMsgHeight;
//  String get nameErrorMsg => _medNameErrorMsg;
//  String get doseErrorMsg => _medDoseErrorMsg;
//  String get frequencyErrorMsg => _frequencyErrorMsg;

  double errorMsgHeight(String error) {
    if (error == 'name') return nameErrorMsgHeight;
    if (error == 'dose') return doseErrorMsgHeight;
    if (error == 'frequency') return frequencyErrorMsgHeight;
    return 100.0;
  }

  String errorMsg(String error) {
    if (error == 'name') return nameErrorMsg;
    if (error == 'dose') return doseErrorMsg;
    if (error == 'frequency') return frequencyErrorMsg;
    return 'Unknown ERROR';
  }

  void showError(String error) {
//    log('$error requested', linenumber: lineNumber(StackTrace.current));
    _setErrorHeight(error: error, height: _errorMsgMaxHeight);
    Future.delayed(
      _secondsToDisplayErrorMsg,
      () => {_setErrorHeight(error: error, height: 0)},
    );
  }

  void _setErrorHeight({String error, double height}) {
    if (_isDisposed) {
      log('AddMedViewModel was disposed');
      return;
    }
    if (error == 'name') nameErrorMsgHeight = height;
    if (error == 'dose') doseErrorMsgHeight = height;
    if (error == 'frequency') frequencyErrorMsgHeight = height;
    notifyListeners();
  }

  /// **********************************************************************
  bool get wasMedAdded => _medsAdded;

  bool get medsLoaded => _medsLoaded;
  int get numMedsFound => _numMedsFound;
  TempMed get medFound => _tempMed;
  String get rxcuiComment => _rxcuiComment;
  MedData get selectedMed => _selectedMed;

  void setMedsLoaded(bool value) {
    _medsLoaded = value;
  }

  void saveSelectedMed(int index) {
    _selectedMed = MedData(
      _userModel.name,
      editIndex,
      _tempMed.rxcui,
      _tempMed.imageInfo.names[index],
      _tempMed.imageInfo.mfgs[index],
      _tempMed.imageInfo.urls[index],
      _tempMed.info,
      _tempMed.warnings,
      doctorId: newMedDoctorId,
      dose: newMedDose,
      frequency: newMedFrequency,
    );
    saveMed(_selectedMed);
  }

  Future saveMedNoMfg() async {
    _selectedMed = MedData(
      _userModel.name,
      editIndex ?? -1,
      _tempMed.rxcui,
      _tempMed.imageInfo.names[0],
      'Unknown Manufacture',
      null,
      _tempMed.info,
      _tempMed.warnings,
      doctorId: newMedDoctorId,
      dose: newMedDose,
      frequency: newMedFrequency,
    );

    Directory directory = await getApplicationDocumentsDirectory();
    var dbPath = p.join(directory.path, 'medImages/${_tempMed.rxcui}.jpg');
    if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound) {
      ByteData data = await rootBundle.load('assets/drug.jpg');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes);
    }
    saveMed(_selectedMed);
  }

  void clearTempMeds() {
    _medsLoaded = false;
    _numMedsFound = 0;
    _rxcuiComment = null;
    _tempMed = null;
    log('Temp Meds cleared.', linenumber: lineNumber(StackTrace.current));
    notifyListeners();
  }

  bool get isBusy => _busy;
  void setBusy(bool loading) {
    _busy = loading;
    log('Loading Data: $isBusy', linenumber: lineNumber(StackTrace.current));
    notifyListeners();
  }

  Future<bool> getMedInfo() async {
    if (hasNewMed) {
      _medsLoaded = false;
      _selectedMed = null;
      setBusy(true);
      MedRequest _medRequest = MedRequest();
      bool gotMeds = await _medRequest.medInfoByName('$newMedName $newMedDose oral');

      _rxcuiComment = _medRequest.rxcuiComment;

      if (!gotMeds) {
        setBusy(false);
        return false;
      }
      log(
        'MedRequest meds loaded: ${_medRequest.numMeds} '
        '[${_medRequest.med(0).isValid()}]',
        linenumber: lineNumber(StackTrace.current),
      );
      if (_medRequest.imageURLs.length > 0) {
        _tempMed = _medRequest.meds[0];
        _medsLoaded = true;
        _numMedsFound = _tempMed.imageInfo.urls.length;
      }
      setBusy(false);
    }
    return true;
  }

  void saveMed(MedData _medData) {
    RepositoryService repository = locator();
    repository.save(_medData);
    _medsAdded = true;
//    clearNewMed();
    notifyListeners();
  }

  ///******************************************************************************
  ///
  void _setImageDirectory() async {
    Directory imageDirectory = await getApplicationDocumentsDirectory();
    Directory subDir = await Directory('${imageDirectory.path}/tempMedImages').create(recursive: true);
    imageDirectoryPath = subDir.path;
  }

  File _file(String filename) {
    String pathName = p.join(imageDirectoryPath, filename);
    return File(pathName);
  }

  File imageFile(String rxcui) {
    List<MedData> _meds = _repository.getAllMeds();
    int ndx = _meds.indexWhere((element) => element.rxcui == rxcui);
    if (ndx == -1) return null;
    File file = _file('${_meds[ndx].rxcui}.jpg');
    return file;
  }
}
