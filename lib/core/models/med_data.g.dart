// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'med_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedDataAdapter extends TypeAdapter<MedData> {
  @override
  final typeId = 0;

  @override
  MedData read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedData(
      fields[10] as String,
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      (fields[5] as List)?.cast<String>(),
      (fields[6] as List)?.cast<String>(),
      doctorId: fields[7] as int,
      dose: fields[8] as String,
      frequency: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MedData obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.rxcui)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.mfg)
      ..writeByte(4)
      ..write(obj.imageURL)
      ..writeByte(5)
      ..write(obj.info)
      ..writeByte(6)
      ..write(obj.warnings)
      ..writeByte(7)
      ..write(obj.doctorId)
      ..writeByte(8)
      ..write(obj.dose)
      ..writeByte(9)
      ..write(obj.frequency)
      ..writeByte(10)
      ..write(obj.owner);
  }
}
