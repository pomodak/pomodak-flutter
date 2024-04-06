import 'package:json_annotation/json_annotation.dart';

part 'transaction_record_model.g.dart';

enum TransactionType { purchase, sell }

@JsonSerializable()
class TransactionRecordModel {
  @JsonKey(name: 'transaction_record_id')
  final int transactionRecordId;
  @JsonKey(
      name: 'transaction_type',
      fromJson: _transactionTypeFromJson,
      toJson: _transactionTypeToJson)
  final TransactionType transactionType; // 거래 타입 (구매, 판매)
  final String notes; // 메모 (구매한 아이템 이름)
  final int count; // 구매수량
  final int amount; // 총가격
  @JsonKey(name: 'balance_after_transaction')
  final int balanceAfterTransaction; // 거래 후 잔액

  TransactionRecordModel({
    required this.transactionRecordId,
    required this.transactionType,
    required this.notes,
    required this.count,
    required this.amount,
    required this.balanceAfterTransaction,
  });

  factory TransactionRecordModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionRecordModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionRecordModelToJson(this);

  static TransactionType _transactionTypeFromJson(String transactionType) =>
      stringToTransactionType(transactionType);

  static String _transactionTypeToJson(TransactionType grade) =>
      characterGradeToString(grade);
}

String characterGradeToString(TransactionType grade) {
  return grade.toString().split('.').last;
}

TransactionType stringToTransactionType(String transactionType) {
  return TransactionType.values.firstWhere((e) =>
      e.toString().split('.').last.toLowerCase() ==
      transactionType.toLowerCase());
}
