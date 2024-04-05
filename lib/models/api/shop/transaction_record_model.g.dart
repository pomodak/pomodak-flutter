// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionRecordModel _$TransactionRecordModelFromJson(
        Map<String, dynamic> json) =>
    TransactionRecordModel(
      transactionRecordId: json['transaction_record_id'] as String,
      transactionType: TransactionRecordModel._transactionTypeFromJson(
          json['transaction_type'] as String),
      notes: json['notes'] as String,
      count: json['count'] as String,
      amount: json['amount'] as String,
      balanceAfterTransaction: json['balance_after_transaction'] as int,
    );

Map<String, dynamic> _$TransactionRecordModelToJson(
        TransactionRecordModel instance) =>
    <String, dynamic>{
      'transaction_record_id': instance.transactionRecordId,
      'transaction_type': TransactionRecordModel._transactionTypeToJson(
          instance.transactionType),
      'notes': instance.notes,
      'count': instance.count,
      'amount': instance.amount,
      'balance_after_transaction': instance.balanceAfterTransaction,
    };
