import 'package:hive/hive.dart';

/**
 * TODO: To generate '.g.' file, open terminal and run this command
            flutter packages pub run build_runner build
 */
part 'doctor_data.g.dart';

@HiveType(typeId: 1)
class DoctorData extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phone;

  DoctorData(this.id, this.name, this.phone);

  int compareTo(DoctorData otherDoctor) => name.compareTo(otherDoctor.name);

  String toString() {
    return name;
  }
}
