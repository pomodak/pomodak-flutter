import 'package:json_annotation/json_annotation.dart';
import 'package:pomodak/models/api/shop/transaction_record_model.dart';

part 'transaction_response.g.dart';

@JsonSerializable()
class TransactionResponse {
  @JsonKey(name: 'transaction_record')
  final TransactionRecordModel transactionRecord;

  TransactionResponse({
    required this.transactionRecord,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionResponseToJson(this);
}
