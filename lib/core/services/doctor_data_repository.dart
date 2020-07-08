import 'dart:async';

import 'package:hive/hive.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/core/models/doctor_data.dart';
import 'package:meds/core/services/doctor_data_box.dart';
import 'package:meds/core/services/repository.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/debug_viewmodel.dart';

class DoctorDataRepository with Logger implements Repository<DoctorData> {
  DebugViewModel _debug = locator();

  DoctorDataBox _doctorDataBox;
  Box _box;
  bool _initialized = false;
  Stream _boxStream;
  List<DoctorData> _doctors = [];

  DoctorDataRepository() {
    setDebug(_debug.isDebugging(DOCTOR_REPOSITORY_DEBUG));

    _doctorDataBox = locator<DoctorDataBox>();
    _initialize();
  }

  void dispose() {
    _box.close();
    log('Doctor box closed.');
  }

  void _initialize() async {
    log('Initializing: ${!_initialized}');

    _box = await _doctorDataBox.box;
    log('got box');

    _doctors = await _getAll();

    _boxStream = _box.watch();
    _boxStream.listen((event) async {
      log('[DoctorDataRepository]: doctor list update needed');
      _doctors = await _getAll();
    });
    _initialized = true;
    log('Initializing: ${!_initialized}');
  }

  @override
  DoctorData getAtIndex(int index) {
    if (index >= _doctors.length) return null;
    return _doctors[index];
  }

  @override
  DoctorData getByName(String name) {
    int index = _doctors.indexWhere((element) => element.name == name);
    if (index == -1) return null;
    return _doctors[index];
  }

  @override
  DoctorData getById(int id) {
    int index = _doctors.indexWhere((element) => element.id == id);
    if (index == -1) return null;
    return _doctors[index];
  }

  @override
  List<DoctorData> getAll() {
    return _doctors;
  }

  Future<List<DoctorData>> _getAll() async {
    return _box.values.toList();
  }

  @override
  Future<void> save(DoctorData newObject) async {
    DoctorData _dd = getById(newObject.id);
    int key;

    if (_dd == null) {
      _dd = newObject.copyWith(id: _box.length);
      _box.add(_dd);
    } else {
      key = _dd.key;
      _dd = newObject.copyWith(id: key);
      _box.put(key, _dd);
    }
    log('DoctorData saved: DoctorId:${_dd.id}, DoctorName:${_dd.name}', linenumber: lineNumber(StackTrace.current));
  }

  @override
  Future<void> delete(DoctorData objectToDelete) async {
    _box.delete(objectToDelete.key);
  }

  @override
  Future<void> deleteAll() async {
    await _box.clear();
  }

  @override
  int size() => _doctors.length;

  @override
  Future deleteBox() async {
    await _doctorDataBox.deleteBox();
    return null;
  }
}
