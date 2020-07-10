import 'dart:io';
import 'package:flutter/services.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/ui/view_model/logger_viewmodel.dart';
import 'package:meds/ui/view_model/user_viewmodel.dart';
import 'package:path/path.dart' as p;

import 'package:flutter/material.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/core/models/doctor_data.dart';
import 'package:meds/core/models/med_data.dart';
import 'package:meds/core/services/repository_service.dart';
import 'package:meds/locator.dart';
import 'package:path_provider/path_provider.dart';

class HomeViewModel extends ChangeNotifier with Logger {
  final LoggerViewModel _debug = locator();

  HomeViewModel() {
    setLogging(_debug.isLogging(HOME_LOGS));
    _init();
    log('Constructor complete');
  }

  void _init() async {
    _userModel.addListener(update);
    await _setImageDirectory();
    updateListData();
    _repository.addListener(updateListData);
  }

  UserViewModel _userModel = locator();

  RepositoryService _repository = locator();

  void update() {
    modelDirty(true);
  }

  @override
  void dispose() {
    log('Dispose was called', linenumber: lineNumber(StackTrace.current));
    _userModel.removeListener(update);
    _repository.removeListener(updateListData);
    super.dispose();
  }

  String imageDirectoryPath;

  int _activeMedIndex = -1;

  bool _modelDirty = false;
  bool get isModelDirty => _modelDirty;
  void modelDirty(bool value) {
    bool oldDirtyState = isModelDirty;
    _modelDirty = value;
    log(
      'Model Dirty: $isModelDirty <= $oldDirtyState',
      linenumber: lineNumber(StackTrace.current),
    );
    notifyListeners();
  }

  String _errorMsg = 'Please add at least one Doctor';
  double _errorMsgMaxHeight = 35;
  double _addMedErrorMsgHeight = 0;

  double get errorMsgHeight => _addMedErrorMsgHeight;
  String get errorMsg => _errorMsg;

  void showAddMedError() {
    _setAddMedErrorHeight(_errorMsgMaxHeight);
    Future.delayed(Duration(seconds: 4), () => {_setAddMedErrorHeight(0)});
  }

  void _setAddMedErrorHeight(double height) {
    _addMedErrorMsgHeight = height;
    notifyListeners();
  }

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
      return _repository.getMedAtIndex(_activeMedIndex);
  }

  File get activeImageFile => imageFile(activeMed.rxcui);

  Future _setImageDirectory() async {
    Directory imageDirectory = await getApplicationDocumentsDirectory();
    Directory subDir = await Directory('${imageDirectory.path}/medImages').create(recursive: true);
    imageDirectoryPath = subDir.path;
  }

  File _file(String filename) {
    String pathName = p.join(imageDirectoryPath, filename);
    return File(pathName);
  }

  File imageFile(String rxcui) {
    //   if (rxcui == '00000') return null;

    List<MedData> _meds = _repository.getAllMeds();
    int ndx = _meds.indexWhere((element) => element.rxcui == rxcui);

    if (ndx == -1 || imageDirectoryPath == null) return null;
    File file = _file('$rxcui.jpg');
    return file;
  }

  setDefaultMedImage(String rxcui) async {
    Directory directory = await getApplicationDocumentsDirectory();
    var iPath = p.join(directory.path, 'medImages/$rxcui.jpg');
    if (FileSystemEntity.typeSync(iPath) == FileSystemEntityType.notFound) {
      ByteData data = await rootBundle.load('assets/drug.jpg');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(iPath).writeAsBytes(bytes);
      log('Default image set: $iPath', linenumber: lineNumber(StackTrace.current));
    }
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

  int get numberOfDoctors => _repository.numberOfDoctors;
  int get numberOfMeds => _repository.numberOfMeds;

  List<MedData> get medList => _repository.getAllMeds();
  List<DoctorData> get doctorList => _repository.getAllDoctors();
  int get size => _repository.numberOfMeds;
  MedData get mtMedData => MedData(_userModel.name, -1, '00000', 'MT MedData', '', '', [], [], doctorId: -1);

  void updateListData() async {
    log('Updating lists', linenumber: lineNumber(StackTrace.current));
    modelDirty(false);
  }

  void clearListData() async {
    await _repository.clearAllMeds();
    log('Only One User: ${_repository.onlyOneUser}', linenumber: lineNumber(StackTrace.current));
    if (_repository.onlyOneUser) await _repository.clearAllDoctors();
    modelDirty(true);
  }

  DoctorData getDoctorById(int id) {
    List<DoctorData> _doctors = _repository.getAllDoctors();
    int ndx = _doctors.indexWhere((element) => id == element.id);
    if (ndx == -1) {
      ndx = 0;
      //return DoctorData(id, 'Doctor not configured', '');
    } //else
    return _doctors[ndx];
  }

  void save(Object newObject) async {
    await _repository.save(newObject);
    notifyListeners();
  }

  MedData getMedByRxcui(String rxcui) {
    return _repository.getMedByRxcui(rxcui);
  }

  MedData getMedAt(int index) {
    return _repository.getMedAtIndex(index);
  }

  void delete(Object objectToDelete) async {
    await _repository.delete(objectToDelete);

    if (objectToDelete is DoctorData) return;

    final dir = Directory(imageDirectoryPath);
    if (dir.existsSync()) {
      var files = dir.listSync().toList();
      for (var i in files) {
        String _rxcui = p.basename(i.path).split(".")[0];
        if (getMedByRxcui(_rxcui) == null) {
          log('Deleting: ${i.path}', linenumber: lineNumber(StackTrace.current));
          File(i.path).deleteSync();
          log('Deleted: $_rxcui', linenumber: lineNumber(StackTrace.current));
        }
      }
    }
  }
}
