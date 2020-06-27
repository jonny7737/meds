class TempMed {
  final int id;
  final String rxcui;
  final String name;
  final List<String> info;
  final List<String> warnings;
  final ImageInfo imageInfo;

  TempMed(this.id, this.rxcui, this.name, this.info, this.warnings, this.imageInfo);

  String toString({bool warningMsgs: false}) {
    List<String> theList;
    if (warningMsgs) {
      theList = warnings;
    } else {
      theList = info;
    }
    String medString = "";
    for (String str in theList) {
      medString += str + "\n\n";
    }
    return medString.trim();
  }

  bool isValid() {
    if (id < 0) {
      print("$id");
      return false;
    }
    if (rxcui == null) {
      print("RXCUI: $rxcui");
      return false;
    }
    if (name == null) {
      print("Name: $name");
      return false;
    }
    if (info == null || info.length == 0) {
      print("${info.length}");
      return false;
    }
    return true;
  }
}

class ImageInfo {
  final List<String> names;
  final List<String> urls;
  final List<String> mfgs;

  ImageInfo({this.names, this.urls, this.mfgs});

  int size() {
    if (names.length == urls.length && names.length == mfgs.length) {
      return names.length;
    } else
      return -1;
  }
}
