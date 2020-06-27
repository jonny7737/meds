import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:flutter/material.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/core/models/doctor_data.dart';
import 'package:meds/core/models/med_data.dart';
import 'package:meds/core/services/repository_service.dart';
import 'package:meds/locator.dart';
import 'package:path_provider/path_provider.dart';

class HomeViewModel extends ChangeNotifier with Logger {
  HomeViewModel() {
    setDebug(false);
    _setImageDirectory();
    updateListData();
    _repository.addListener(() {
      updateListData();
    });
    log('Constructor complete');
  }

  RepositoryService _repository = locator<RepositoryService>();

  String imageDirectoryPath;

  int _activeMedIndex = -1;

  bool _modelDirty = false;
  bool get isModelDirty => _modelDirty;
  void modelDirty(bool value) {
    _modelDirty = value;
    log('Model Dirty: $isModelDirty');
    notifyListeners();
  }

  String _errorMsg = 'Please add at least one Doctor';
  double _errorMsgMaxHeight = 35;
  double _addMedErrorMsgHeight = 0;

  bool _bottomSet = false;
  double _bottomCardUp = 0;
  double _bottomCardDn = 0;
  bool _detailCardVisible = false;

  int get activeMedIndex => _activeMedIndex;
  void setActiveMedIndex(int ndx) {
    _activeMedIndex = ndx;
  }

  MedData get activeMed {
    if (_activeMedIndex == -1) {
      return mtMedData;
    } else
      return _repository.getAllMeds()[_activeMedIndex];
  }

  File get activeImageFile => imageFile(activeMed.rxcui);

  void _setImageDirectory() async {
    Directory imageDirectory = await getApplicationDocumentsDirectory();
    Directory subDir = await Directory('${imageDirectory.path}/medImages').create(recursive: true);
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

  bool get bottomsSet => _bottomSet;
  void setBottoms({double cardUp, double cardDn}) {
    _bottomCardUp = cardUp;
    _bottomCardDn = cardDn;
    _bottomSet = true;
  }

  double get cardBottom {
    if (_detailCardVisible)
      return _bottomCardUp;
    else
      return _bottomCardDn;
  }

  bool get detailCardVisible => _detailCardVisible;

  void showDetailCard() {
    log('Detail Card UP');
    _detailCardVisible = true;
    notifyListeners();
  }

  void hideDetailCard() {
    log('Detail Card DN');
    _detailCardVisible = false;
    notifyListeners();
  }

  double get errorMsgHeight => _addMedErrorMsgHeight;
  String get errorMsg => _errorMsg;

  int get numberOfDoctors => _repository.numberOfDoctors;
  int get numberOfMeds {
    log('${_repository.numberOfMeds}', linenumber: lineNumber(StackTrace.current));
    return _repository.numberOfMeds;
  }

  List<MedData> get medList => _repository.getAllMeds();
  List<DoctorData> get doctorList => _repository.getAllDoctors();
  int get size => _repository.numberOfMeds;
  MedData get mtMedData => MedData(-1, '00000', 'MT MedData', '', '', [], [], doctorId: -1);

  void showAddMedError() {
    _setAddMedErrorHeight(_errorMsgMaxHeight);
    Future.delayed(Duration(seconds: 4), () => {_setAddMedErrorHeight(0)});
  }

  void _setAddMedErrorHeight(double height) {
    _addMedErrorMsgHeight = height;
    notifyListeners();
  }

  void updateListData() async {
    log('Updating lists', linenumber: lineNumber(StackTrace.current));
    modelDirty(false);
  }

  void clearListData() async {
    await _repository.clearAllMeds();
    await _repository.clearAllDoctors();
    modelDirty(true);
  }

  DoctorData getDoctorById(int id) {
    List<DoctorData> _doctors = _repository.getAllDoctors();
    int ndx = _doctors.indexWhere((element) => id == element.id);
    if (ndx == -1) {
      return DoctorData(id, 'Doctor not configured', '');
    } else
      return _doctors[ndx];
  }

  void save(Object newObject) async {
    await _repository.save(newObject);
    notifyListeners();
  }

  void delete(Object objectToDelete) async {
    await _repository.delete(objectToDelete);
  }
}
