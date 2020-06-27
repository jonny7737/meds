import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/core/models/med_data.dart';

class MedDataBox with Logger, ChangeNotifier {
  static const int retryTime = 100; // milliseconds to wait for !_initializing

  Box<MedData> _box;
  bool _initialized = false;
  bool _initializing = false;
  bool _lockCheck = false;

  MedDataBox() {
    setDebug(true);
    _init();
    log('constructor completed');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _init() async {
    await initializeHiveBox(initCalling: true);
    _initialized = true;

    /// This is required because Hive.openBox()
    ///  does not emit a BoxEvent
    notifyListeners();
  }

  Future<MedData> getByKey(key) async {
    return _box.get(key);
  }

  Future<Box<MedData>> get box async {
    if (_box != null && _box.isOpen) {
      _initializing = false;
      _lockCheck = false;
      _initialized = true;
      return _box;
    }
    log('Re-get on box');
    while (_lockCheck) {
      log('lockCheck delay', linenumber: lineNumber(StackTrace.current));
      await Future.delayed(Duration(milliseconds: 20), () {});
      if (_box != null && _box.isOpen) {
        _lockCheck = false;
        _initializing = false;
        _initialized = true;
        log('LockCheck cleared with box', linenumber: lineNumber(StackTrace.current));
        return _box;
      }
    }
    _lockCheck = true;

    if (_initializing) {
      log('initializing delay');
      int _totalDelay = 0;

      Future.doWhile(() {
        if (_totalDelay > 1000) {
          return false;
        }
        _totalDelay += retryTime;
        return Future.delayed(new Duration(milliseconds: retryTime), () {
          bool continueLoop = !_initialized;
          return continueLoop;
        });
      });

      if (_initialized) {
        _lockCheck = false;
        return _box;
      }
    }

    if (!_initialized) {
      _initializing = true;
      await initializeHiveBox();
      _initialized = true;
    }
    _initializing = false;
    _lockCheck = false;
    return _box;
  }

  Future<void> initializeHiveBox({bool initCalling = false}) async {
    if (_lockCheck) return;
    _lockCheck = true;
    log('Is box open? ${Hive.isBoxOpen(kMedHiveBox)}');
    log('awaiting Hive Box');
    _box = await Hive.openBox<MedData>(kMedHiveBox);
    if (_box != null) {
      log('Hive Box retrieved');
      if (_box.isOpen) log('MedData box is opened [$initCalling] with ${_box.length} entries.');
    } else
      log('No Hive Box');
    _lockCheck = false;
  }

  Future deleteBox() async {
    await Hive.deleteBoxFromDisk(kMedHiveBox);
  }
}
