// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FormDataModelAdapter extends TypeAdapter<FormDataModel> {
  @override
  final int typeId = 1;

  @override
  FormDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FormDataModel(
      name: fields[0] as String,
      email: fields[1] as String,
      password: fields[2] as String,
      phone: fields[3] as String,
      age: fields[4] as String?,
      gender: fields[5] as String?,
      country: fields[6] as String?,
      selectedDate: fields[7] as DateTime?,
      selectedTime: fields[8] as String?,
      rating: fields[9] as double,
      percentage: fields[10] as double,
      priceRangeStart: fields[11] as double?,
      priceRangeEnd: fields[12] as double?,
      notifications: fields[13] as bool,
      agreePolicy: fields[14] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FormDataModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.age)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.country)
      ..writeByte(7)
      ..write(obj.selectedDate)
      ..writeByte(8)
      ..write(obj.selectedTime)
      ..writeByte(9)
      ..write(obj.rating)
      ..writeByte(10)
      ..write(obj.percentage)
      ..writeByte(11)
      ..write(obj.priceRangeStart)
      ..writeByte(12)
      ..write(obj.priceRangeEnd)
      ..writeByte(13)
      ..write(obj.notifications)
      ..writeByte(14)
      ..write(obj.agreePolicy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
