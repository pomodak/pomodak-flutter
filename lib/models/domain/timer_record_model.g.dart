// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimerRecordModelAdapter extends TypeAdapter<TimerRecordModel> {
  @override
  final int typeId = 0;

  @override
  TimerRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimerRecordModel(
      memberId: fields[0] as String,
      date: fields[1] as DateTime,
      totalSeconds: fields[2] as int,
      totalCompleted: fields[3] as int,
      details: (fields[4] as Map).cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, TimerRecordModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.memberId)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.totalSeconds)
      ..writeByte(3)
      ..write(obj.totalCompleted)
      ..writeByte(4)
      ..write(obj.details);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
