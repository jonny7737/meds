import 'package:hive/hive.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/core/models/doctor_data.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/logger_viewmodel.dart';

class DoctorDataBox with Logger {
  LoggerViewModel _debug = locator();

  static const int retryTime = 100; // milliseconds to wait for !_initializing

  Box<DoctorData> _box;
  bool _initialized = false;
  bool _initializing = false;
  bool _lockCheck = false;

  DoctorDataBox() {
    setDebug(_debug.isDebugging(DOCTOR_REPOSITORY_DEBUG));

    _init();
    log('constructor completed');
  }

  void _init() async {
    await initializeHiveBox();
    _initialized = true;
  }

  Future<DoctorData> getByKey(key) async {
    DoctorData _dd = _box.get(key);
    return _dd;
  }

  Future<Box<DoctorData>> get box async {
    if (_box != null && _box.isOpen) {
      _lockCheck = false;
      _initializing = false;
      _initialized = true;
      return _box;
    }
    log('Re-get on box');

    while (_lockCheck) {
      log('lockCheck wait');
      await Future.delayed(Duration(milliseconds: 50));
      if (_box != null && _box.isOpen) {
        _lockCheck = false;
        _initializing = false;
        _initialized = true;
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
        _initializing = false;
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

  Future<void> initializeHiveBox() async {
    log('Is box open? ${Hive.isBoxOpen(kDoctorHiveBox)}');
    log('awaiting Hive Box');
    _box = await Hive.openBox<DoctorData>(kDoctorHiveBox);
    if (_box != null) {
      log('Hive Box retrieved');
      if (_box.isOpen) log('DoctorData box is opened with ${_box.length} entries.');
    } else
      log('No Hive Box');
  }

  Future deleteBox() async {
    await Hive.deleteBoxFromDisk(kDoctorHiveBox);
  }
}
