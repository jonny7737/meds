import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/core/models/med_data.dart';
import 'package:meds/core/services/med_data_box.dart';
import 'package:meds/core/services/repository.dart';
import 'package:meds/locator.dart';

class MedDataRepository with Logger, ChangeNotifier implements Repository<MedData> {
  MedDataBox _medDataBox;
  Box _box;
  Stream _boxStream;
  List<MedData> _meds = [];

  MedDataRepository() {
    setDebug(true);
    _medDataBox = locator<MedDataBox>();
    _medDataBox.addListener(boxOpened);
    _initialize();
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
    super.dispose();
  }

  void _initialize() async {
    log('Initializing...');

    _box = await _medDataBox.box;
    log('got box');

    _meds = await _getAll();

    _boxStream = _box.watch();
    _boxStream.listen((event) async {
      log('BoxEvent occurred: reload MedData');
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

  Future<List<MedData>> _getAll() async {
    final _box = await _medDataBox.box;
    notifyListeners();
    return _box.values.toList();
  }

  @override
  List<MedData> getAll() {
    return _meds;
  }

  /** // ignore: slash_for_doc_comments
   *
   * TODO: Update save method to support additional parameters
      doctorId, dose and frequency
   */
  @override
  Future<void> save(MedData newObject, {int index = -1}) async {
    final _box = await _medDataBox.box;
    if (index == -1) {
      if (newObject.id == -1) {
        newObject = newObject.copyWith(id: _box.length);
      }
      _box.add(newObject);
    } else {
      _box.putAt(index, newObject);
    }
  }

  @override
  Future<void> delete(MedData objectToDelete) async {
    final _box = await _medDataBox.box;
    await _box.delete(objectToDelete.key);
  }

  @override
  Future<void> deleteAll() async {
    final _box = await _medDataBox.box;
    await _box.clear();
  }

  @override
  int size() {
    return _meds.length;
  }

  @override
  Future deleteBox() async {
    log('Deleting MedBox');
    await _medDataBox.deleteBox();
    return null;
  }
}
