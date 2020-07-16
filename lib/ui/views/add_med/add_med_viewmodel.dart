import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/core/models/doctor_data.dart';
import 'package:meds/core/models/med_data.dart';
import 'package:meds/core/services/med_lookup_service.dart';
import 'package:meds/core/services/repository_service.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/logger_viewmodel.dart';

class AddMedViewModel extends ChangeNotifier with Logger {
  final LoggerViewModel _logs = locator();
  final MedLookUpService _ls = locator();
  final RepositoryService _repository = locator();

  AddMedViewModel() {
    setLogging(_logs.isLogging(ADDMED_LOGS));
    _ls.addListener(setState);
  }

  bool _isDisposed = false;

  GlobalKey<FormState> formKey;
  void setFormKey(formKey) {
    this.formKey = formKey;
    log('FormKey set', linenumber: lineNumber(StackTrace.current));
  }

  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    _ls.removeListener(setState);
    log('Has been disposed.', linenumber: lineNumber(StackTrace.current));
    super.dispose();
  }

  /// **********************************************************************
  String get newMedName => _ls.newMedName;
  String get fancyDoctorName {
    String _name;

    if (_ls.editIndex == null) {
      if (_ls.newMedDoctorName == null)
        _name = doctorNames[0];
      else
        _name = 'Dr. ' + _ls.newMedDoctorName;
    } else
      _name = 'Dr. ' + _ls.newMedDoctorName;
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

  MedData get medAtEditIndex => _ls.editIndex != null ? _repository.getMedAtIndex(_ls.editIndex) : null;

  void setMedForEditing(int index) {
    if (index == null) {
      return;
    }

    _ls.editIndex = index;
    MedData _md = medAtEditIndex;

    log('${_md.doctorId}', linenumber: lineNumber(StackTrace.current));

    _ls.newMedName = reformatMedName(_md.name, _md.dose);
    _ls.newMedDose = _md.dose;
    _ls.newMedFrequency = _md.frequency;
    if (_ls.newMedDoctorId == null) _ls.newMedDoctorId = _md.doctorId;
    _ls.newMedDoctorName = getDoctorById(_ls.newMedDoctorId).name;

    log('${_md.doctorId}', linenumber: lineNumber(StackTrace.current));
  }

  String formInitialValue(String fieldName) {
    String value;
    if (fieldName == 'name') value = _ls.newMedName;
    if (fieldName == 'dose') value = _ls.newMedDose;
    if (fieldName == 'frequency') value = _ls.newMedFrequency;

    return value;
  }

  void _setMedDoctorId(String name) {
    if (name.toLowerCase().startsWith('dr.')) {
      int i = name.indexOf(' ') + 1;
      name = name.substring(i);
    }
    _ls.newMedDoctorName = name;
    _ls.newMedDoctorId = _repository.getDoctorByName(name).id;
    log('${_ls.newMedDoctorName}:${_ls.newMedDoctorId}', linenumber: lineNumber(StackTrace.current));
  }

  void onFormSave(String formField, String value) {
    if (value == null || value.isEmpty) {
      showError(formField);
      setFormError(true);
    } else {
      setFormError(false);
      if (formField == 'name') _ls.newMedName = value;
      if (formField == 'dose') _ls.newMedDose = value;
      if (formField == 'frequency') _ls.newMedFrequency = value;
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

  void logEditIndex() {
    if (_ls.editIndex == null) return;
    MedData _md = _repository.getMedAtIndex(_ls.editIndex);
    log(
      '$_ls.editIndex: ${_md.name} : ${_md.doctorId}',
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
  int _formErrors = 0;
  double nameErrorMsgHeight = 0;
  double doseErrorMsgHeight = 0;
  double frequencyErrorMsgHeight = 0;

  final double _errorMsgMaxHeight = 35;
  final String nameErrorMsg = 'Medication name is required.';
  final String doseErrorMsg = 'Dosage information is required.';
  final String frequencyErrorMsg = 'This information is required.';
  final Duration _secondsToDisplayErrorMsg = Duration(seconds: 4);

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
      () {
        _setErrorHeight(error: error, height: 0);
        log('$error notification completed', linenumber: lineNumber(StackTrace.current));
      },
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
  bool get wasMedAdded => _ls.medsAdded;

  bool get medsLoaded => _ls.medsLoaded;
  int get numMedsFound => _ls.numMedsFound;
  String get rxcuiComment => _ls.rxcuiComment;
  bool get hasNewMed => _ls.hasNewMed;

  void setState() {
    notifyListeners();
  }

  void setMedsLoaded(bool value) {
    _ls.medsLoaded = value;
    notifyListeners();
  }

  bool get isBusy => _ls.busy;
  void setBusy(bool loading) {
    _ls.busy = loading;
    log('Loading Data: $isBusy', linenumber: lineNumber(StackTrace.current));
    notifyListeners();
  }

  Future<bool> getMedInfo() async {
    if (hasNewMed) {
      setBusy(true);
      bool gotMeds = await _ls.getMedInfo();
      setBusy(false);
      formKey.currentState.reset();
      notifyListeners();

      if (gotMeds) return true;
    }
    return false;
  }
}
