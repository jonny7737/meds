import 'dart:async';

import 'package:hive/hive.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/core/models/doctor_data.dart';
import 'package:meds/core/services/doctor_data_box.dart';
import 'package:meds/core/services/repository.dart';
import 'package:meds/locator.dart';

class DoctorDataRepository with Logger implements Repository<DoctorData> {
  DoctorDataBox _doctorDataBox;
  Box _box;
  bool _initialized = false;
  Stream _boxStream;
  List<DoctorData> _doctors = [];

  DoctorDataRepository() {
    setDebug(false);
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
  List<DoctorData> getAll() {
    return _doctors;
  }

  Future<List<DoctorData>> _getAll() async {
    return _box.values.toList();
  }

  @override
  Future<void> save(DoctorData newObject, {int index = -1}) async {
    if (index == -1) {
      _box.add(newObject);
    } else {
      _box.putAt(index, newObject);
    }
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
