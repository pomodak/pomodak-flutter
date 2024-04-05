// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseItemResponse _$PurchaseItemResponseFromJson(
        Map<String, dynamic> json) =>
    PurchaseItemResponse(
      transactionRecord: TransactionRecordModel.fromJson(
          json['transaction_record'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PurchaseItemResponseToJson(
        PurchaseItemResponse instance) =>
    <String, dynamic>{
      'transaction_record': instance.transactionRecord,
    };
