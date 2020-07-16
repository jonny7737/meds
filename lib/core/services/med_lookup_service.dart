import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

import 'package:flutter/foundation.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/helpers/med_request.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/core/models/med_data.dart';
import 'package:meds/core/models/temp_med.dart';
import 'package:meds/core/services/repository_service.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/logger_viewmodel.dart';
import 'package:meds/ui/view_model/user_viewmodel.dart';
import 'package:path_provider/path_provider.dart';

class MedLookUpService with Logger, ChangeNotifier {
  final UserViewModel _userModel = locator();
  final LoggerViewModel _logger = locator();

  MedLookUpService() {
    setLogging(_logger.isLogging(ADDMED_LOGS));
  }

  bool busy = false;
  bool medsLoaded = false;
  bool wasMedAdded = false;
  int numMedsFound = 0;
  String rxcuiComment;
  TempMed tempMed;
  MedData _selectedMed;

  int editIndex;

  String newMedName;
  String newMedDose;
  String newMedFrequency;
  String newMedDoctorName;
  int newMedDoctorId;

  TempMed get medFound => tempMed;
  MedData get selectedMed => _selectedMed;

  void setBusy(bool b) => busy = b;

  bool get hasNewMed {
    log('$newMedName : $newMedDose', linenumber: lineNumber(StackTrace.current));

    if (newMedName == null || newMedDose == null || newMedFrequency == null) return false;
    if (newMedName.length > 2 && newMedDose.length > 2 && newMedFrequency.length > 3) return true;
    return false;
  }

  void saveMed(MedData _medData) {
    RepositoryService repository = locator();
    repository.save(_medData);
    wasMedAdded = true;
    clearNewMed();
    notifyListeners();
  }

  void saveSelectedMed(int index) {
    _selectedMed = MedData(
      _userModel.name,
      editIndex,
      tempMed.rxcui,
      tempMed.imageInfo.names[index],
      tempMed.imageInfo.mfgs[index],
      tempMed.imageInfo.urls[index],
      tempMed.info,
      tempMed.warnings,
      doctorId: newMedDoctorId,
      dose: newMedDose,
      frequency: newMedFrequency,
    );
    saveMed(_selectedMed);
  }

  Future saveMedNoMfg() async {
    _selectedMed = MedData(
      _userModel.name,
      editIndex,
      tempMed.rxcui,
      tempMed.imageInfo.names[0],
      'Unknown Manufacture',
      null,
      tempMed.info,
      tempMed.warnings,
      doctorId: newMedDoctorId,
      dose: newMedDose,
      frequency: newMedFrequency,
    );

    /// All of this just to copy the 'Unknown  Manufacturer' image to the medImages directory.
    ///
    Directory directory = await getApplicationDocumentsDirectory();
    var dbPath = p.join(directory.path, 'medImages/${tempMed.rxcui}.jpg');
    if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound) {
      ByteData data = await rootBundle.load('assets/drug.jpg');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes);
    }

    saveMed(_selectedMed);
  }

  void clearTempMeds() {
    medsLoaded = false;
    numMedsFound = 0;
    rxcuiComment = null;
    tempMed = null;
    log('Temp Meds cleared.', linenumber: lineNumber(StackTrace.current));
    notifyListeners();
  }

  void clearNewMed() {
    busy = false;
    medsLoaded = false;
    editIndex = null;
    newMedName = null;
    newMedDose = null;
    newMedFrequency = null;
    newMedDoctorName = null;
    newMedDoctorId = null;
    notifyListeners();
    log('New Med Info cleared.', linenumber: lineNumber(StackTrace.current));
  }

  Future<bool> getMedInfo() async {
    if (hasNewMed) {
      medsLoaded = false;
      _selectedMed = null;
      setBusy(true);
      MedRequest _medRequest = MedRequest();
      bool gotMeds = await _medRequest.medInfoByName('$newMedName $newMedDose oral');
      setBusy(false);

      rxcuiComment = _medRequest.rxcuiComment;

      if (!gotMeds) return false;

      log(
        'MedRequest meds loaded: ${_medRequest.numMeds} '
        '[${_medRequest.med(0).isValid()}]',
        linenumber: lineNumber(StackTrace.current),
      );
      if (_medRequest.imageURLs.length > 0) {
        tempMed = _medRequest.meds[0];
        medsLoaded = true;
        numMedsFound = tempMed.imageInfo.urls.length;
        return true;
      }
    }
    return false;
  }
}
