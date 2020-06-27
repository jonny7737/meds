// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DoctorDataAdapter extends TypeAdapter<DoctorData> {
  @override
  final typeId = 1;

  @override
  DoctorData read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoctorData(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DoctorData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phone);
  }
}
