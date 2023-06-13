// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pick_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PickListNewAdapter extends TypeAdapter<PickListNew> {
  @override
  final int typeId = 1;

  @override
  PickListNew read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PickListNew(
      timezone: fields[0] as String?,
      uid: fields[1] as String?,
      orderDate: fields[2] as dynamic,
      orderDateFormatted: fields[3] as String?,
      deliveryDate: fields[4] as dynamic,
      deliveryDateFormatted: fields[5] as String?,
      debtor: fields[6] as Debtor?,
      agent: fields[7] as String?,
      colliAmount: fields[8] as dynamic,
      palletAmount: fields[9] as dynamic,
      invoiceId: fields[10] as dynamic,
      deliveryConditionId: fields[11] as String?,
      countryCode: fields[12] as String?,
      internalMemo: fields[13] as String?,
      picker: fields[14] as String?,
      deliveryAddress: fields[15] as dynamic,
      orderReference: fields[16] as dynamic,
      warehouse: fields[17] as String?,
      lines: fields[18] as int?,
      status: fields[19] as int?,
      hasCancelled: fields[20] as bool?,
      hasBackOrder: fields[21] as bool?,
      id: fields[22] as int?,
      isNew: fields[23] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, PickListNew obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.timezone)
      ..writeByte(1)
      ..write(obj.uid)
      ..writeByte(2)
      ..write(obj.orderDate)
      ..writeByte(3)
      ..write(obj.orderDateFormatted)
      ..writeByte(4)
      ..write(obj.deliveryDate)
      ..writeByte(5)
      ..write(obj.deliveryDateFormatted)
      ..writeByte(6)
      ..write(obj.debtor)
      ..writeByte(7)
      ..write(obj.agent)
      ..writeByte(8)
      ..write(obj.colliAmount)
      ..writeByte(9)
      ..write(obj.palletAmount)
      ..writeByte(10)
      ..write(obj.invoiceId)
      ..writeByte(11)
      ..write(obj.deliveryConditionId)
      ..writeByte(12)
      ..write(obj.countryCode)
      ..writeByte(13)
      ..write(obj.internalMemo)
      ..writeByte(14)
      ..write(obj.picker)
      ..writeByte(15)
      ..write(obj.deliveryAddress)
      ..writeByte(16)
      ..write(obj.orderReference)
      ..writeByte(17)
      ..write(obj.warehouse)
      ..writeByte(18)
      ..write(obj.lines)
      ..writeByte(19)
      ..write(obj.status)
      ..writeByte(20)
      ..write(obj.hasCancelled)
      ..writeByte(21)
      ..write(obj.hasBackOrder)
      ..writeByte(22)
      ..write(obj.id)
      ..writeByte(23)
      ..write(obj.isNew);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PickListNewAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DebtorAdapter extends TypeAdapter<Debtor> {
  @override
  final int typeId = 2;

  @override
  Debtor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Debtor(
      uid: fields[0] as String?,
      name: fields[1] as String?,
      email: fields[2] as dynamic,
      street: fields[3] as String?,
      number: fields[4] as String?,
      streetNote: fields[5] as dynamic,
      city: fields[6] as String?,
      postalCode: fields[7] as String?,
      country: fields[8] as String?,
      vatNumber: fields[9] as dynamic,
      chamberOfCommerceNumber: fields[10] as dynamic,
      status: fields[11] as int?,
      agentId: fields[12] as dynamic,
      organisation: fields[13] as String?,
      organisationId: fields[14] as int?,
      addressId: fields[15] as int?,
      paymentConditionId: fields[16] as dynamic,
      id: fields[17] as int?,
      isNew: fields[18] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Debtor obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.street)
      ..writeByte(4)
      ..write(obj.number)
      ..writeByte(5)
      ..write(obj.streetNote)
      ..writeByte(6)
      ..write(obj.city)
      ..writeByte(7)
      ..write(obj.postalCode)
      ..writeByte(8)
      ..write(obj.country)
      ..writeByte(9)
      ..write(obj.vatNumber)
      ..writeByte(10)
      ..write(obj.chamberOfCommerceNumber)
      ..writeByte(11)
      ..write(obj.status)
      ..writeByte(12)
      ..write(obj.agentId)
      ..writeByte(13)
      ..write(obj.organisation)
      ..writeByte(14)
      ..write(obj.organisationId)
      ..writeByte(15)
      ..write(obj.addressId)
      ..writeByte(16)
      ..write(obj.paymentConditionId)
      ..writeByte(17)
      ..write(obj.id)
      ..writeByte(18)
      ..write(obj.isNew);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
