import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:meds/core/helpers/med_request.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/core/models/med_data.dart';
import 'package:meds/core/models/temp_med.dart';
import 'package:meds/core/services/repository_service.dart';
import 'package:meds/locator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class AddMedViewModel extends ChangeNotifier with Logger {
  String imageDirectoryPath;

  AddMedViewModel() {
    setDebug(true);
    _setImageDirectory();
  }

  RepositoryService _repository = locator();

  bool _isDisposed = false;

  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    log('Has been disposed.', linenumber: lineNumber(StackTrace.current));
    super.dispose();
  }

  int _editIndex;
  int get editIndex => _editIndex;
  void setEditIndex(int i) => _editIndex = i;
  MedData get medAtEditIndex => _repository.getMedAtIndex(_editIndex);
  void logEditIndex() {
    if (_editIndex != null)
      log('$_editIndex: ${_repository.getMedAtIndex(_editIndex).name}', linenumber: lineNumber(StackTrace.current));
  }

  bool _busy = false;
  bool _medsLoaded = false;
  bool _medsAdded = false;
  int _formErrors = 0;
  int _numMedsFound = 0;
  String _rxcuiComment;
  TempMed _tempMed;
  MedData _selectedMed;

  double _errorMsgMaxHeight = 35;
  double _medNameErrorMsgHeight = 0;
  double _medDoseErrorMsgHeight = 0;
  double _frequencyErrorMsgHeight = 0;
  String _medNameErrorMsg = 'Medication name is required.';
  String _medDoseErrorMsg = 'Dosage information is required.';
  String _frequencyErrorMsg = 'This information is required.';
  Duration _secondsToDisplayErrorMsg = Duration(seconds: 4);

  String _newMedName;
  String _newMedDose;
  String _newMedFrequency;

  bool get hasNewMed {
    log('$_newMedName : $_newMedDose', linenumber: lineNumber(StackTrace.current));
    if (_newMedName == null || _newMedDose == null || _newMedFrequency == null) return false;
    if (_newMedName.length > 2 && _newMedDose.length > 2 && _newMedFrequency.length > 3) return true;
    return false;
  }

  String get newMedDose => _newMedDose;

  void setMedName(String name) => _newMedName = name;
  void setMedDose(String dose) => _newMedDose = dose;
  void setMedFrequency(String frequency) => _newMedFrequency = frequency;
  void clearNewMed() {
    _newMedName = null;
    _newMedDose = null;
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

  double get nameErrorMsgHeight => _medNameErrorMsgHeight;
  double get doseErrorMsgHeight => _medDoseErrorMsgHeight;
  double get frequencyErrorMsgHeight => _frequencyErrorMsgHeight;
  String get nameErrorMsg => _medNameErrorMsg;
  String get doseErrorMsg => _medDoseErrorMsg;
  String get frequencyErrorMsg => _frequencyErrorMsg;

  void onFormSave(String formField, String value) {
    if (value == null || value.isEmpty) {
      showError(formField);
      setFormError(true);
    } else {
      setFormError(false);
      if (formField == 'name') setMedName(value);
      if (formField == 'dose') setMedDose(value);
      if (formField == 'frequency') setMedFrequency(value);
    }
  }

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
    if (error == 'name') _medNameErrorMsgHeight = height;
    if (error == 'dose') _medDoseErrorMsgHeight = height;
    if (error == 'frequency') _frequencyErrorMsgHeight = height;
    notifyListeners();
  }

  bool get wasMedAdded => _medsAdded;

  bool get medsLoaded => _medsLoaded;
  int get numMedsFound => _numMedsFound;
  TempMed get medFound => _tempMed;
  String get rxcuiComment => _rxcuiComment;
  MedData get selectedMed => _selectedMed;

  void saveSelectedMed(int index) {
    _selectedMed = MedData(
      -1,
      _tempMed.rxcui,
      _tempMed.imageInfo.names[index],
      _tempMed.imageInfo.mfgs[index],
      _tempMed.imageInfo.urls[index],
      _tempMed.info,
      _tempMed.warnings,
      dose: _newMedDose,
      frequency: _newMedFrequency,
    );
    saveMed(_selectedMed);
  }

  Future saveMedNoMfg() async {
    _selectedMed = MedData(
      -1,
      _tempMed.rxcui,
      _tempMed.imageInfo.names[0],
      'Manufacture Unknown',
      null,
      _tempMed.info,
      _tempMed.warnings,
      dose: _newMedDose,
      frequency: _newMedFrequency,
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
      bool gotMeds = await _medRequest.medInfoByName('$_newMedName $_newMedDose oral');

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
