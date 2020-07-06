import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/core/models/med_data.dart';
import 'package:meds/core/services/med_data_box.dart';
import 'package:meds/core/services/repository.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/debug_viewmodel.dart';
import 'package:meds/ui/view_model/user_viewmodel.dart';

class MedDataRepository with Logger, ChangeNotifier implements Repository<MedData> {
  UserViewModel _userModel = locator();
  MedDataBox _medDataBox = locator();
  DebugViewModel _debug = locator();

  Box _box;
  Stream _boxStream;
  List<MedData> _meds = [];
  int _numUsers = 0;

  MedDataRepository() {
    setDebug(_debug.isDebugging(MED_REPOSITORY_DEBUG));

    _medDataBox.addListener(boxOpened);
    _userModel.addListener(_refreshMeds);
    _initialize();
  }

  bool get onlyOneUser => _numUsers == 1;

  void _refreshMeds() async {
    _meds = await _getAll();
  }

  /// This is required because Hive.openBox()
  ///  does not emit a BoxEvent.  It will only
  ///  be triggered once.
  void boxOpened() {
    log('Med box Opened event, refresh list.');
    notifyListeners();
    _medDataBox.removeListener(boxOpened);
  }

  @override
  void dispose() {
    _box.close();
    log('Doctor box closed.');
    _userModel.removeListener(_refreshMeds);
    _medDataBox.removeListener(boxOpened);
    super.dispose();
  }

  void _initialize() async {
    log('Initializing...');

    _box = await _medDataBox.box;
    log('got box');

    _meds = await _getAll();

    _boxStream = _box.watch();
    _boxStream.listen((event) async {
      log('BoxEvent occurred: reloading MedData');
      _meds = await _getAll();
    });
    log('...complete');
  }

  @override
  MedData getAtIndex(int index) {
    if (index >= _meds.length) return null;
    return _meds[index];
  }

  MedData getByRxcui(String rxcui) {
    int index = _meds.indexWhere((element) => element.rxcui == rxcui);
    if (index == -1) return null;
    log('Returning: ${_meds[index].name}', linenumber: lineNumber(StackTrace.current));
    return _meds[index];
  }

  @override
  MedData getByName(String name) {
    int index = _meds.indexWhere((element) => element.name == name);
    if (index == -1) return null;
    return _meds[index];
  }

  @override
  MedData getById(int id) {
    int index = _meds.indexWhere((element) => element.id == id);
    if (index == -1) return null;
    return _meds[index];
  }

  /// Refresh the repository list with sorted data from the box
  ///   Sorting is based on medication name field.
  ///   The list is filtered by the current logged-in user.
  Future<List<MedData>> _getAll() async {
    _numUsers = _countUniqueUsers();
    List<MedData> _medData;
    _medData = _box.values.toList().where((med) => med.owner == _userModel.name).toList();

    _medData.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    notifyListeners();
    return _medData;
  }

  int _countUniqueUsers() {
    List _userList = [];
    _userList.add(_userModel.name);
    List<MedData> _medData = _box.values.toList();
    for (var med in _medData) {
      if (!_userList.contains(med.owner)) _userList.add(med.owner);
    }
    return _userList.length;
  }

  @override
  List<MedData> getAll() {
    return _meds;
  }

  /*
   * TODO: Update save method to support additional parameters
      doctorId, dose and frequency
   */
  @override
  Future<void> save(MedData newObject, {int index = -1}) async {
    int _doctorId;
    if (index == -1) {
      if (newObject.id == -1) {
        if (newObject.doctorId == -1) _doctorId = 0;
        newObject = newObject.copyWith(id: _box.length, doctorId: _doctorId);
      }
      _box.add(newObject);
    } else {
      _box.putAt(index, newObject);
    }
    log('MedData saved: Doctor ID: ${newObject.doctorId}', linenumber: lineNumber(StackTrace.current));
  }

  @override
  Future<void> delete(MedData objectToDelete) async {
    log('Deleting ${objectToDelete.name}', linenumber: lineNumber(StackTrace.current));
    await _box.delete(objectToDelete.key);
  }

  @override
  Future<void> deleteAll() async {
    for (var med in _meds) {
      if (med.owner == _userModel.name) delete(med);
    }
  }

  @override
  int size() => _meds.length;

  @override
  Future deleteBox() async {
    log('Deleting MedBox');
    await _medDataBox.deleteBox();
    return null;
  }
}
