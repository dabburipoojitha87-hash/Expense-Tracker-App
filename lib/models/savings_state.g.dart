// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavingsStateAdapter extends TypeAdapter<SavingsState> {
  @override
  final int typeId = 2;

  @override
  SavingsState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavingsState(
      totalAccumulatedSavings: fields[0] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SavingsState obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.totalAccumulatedSavings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavingsStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
