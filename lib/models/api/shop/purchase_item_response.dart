import 'package:json_annotation/json_annotation.dart';
import 'package:pomodak/models/api/shop/transaction_record_model.dart';
import 'package:pomodak/models/domain/item_model.dart';

part 'purchase_item_response.g.dart';

@JsonSerializable()
class PurchaseItemResponse {
  @JsonKey(name: 'transaction_record')
  final TransactionRecordModel transactionRecord;

  PurchaseItemResponse({
    required this.transactionRecord,
  });

  factory PurchaseItemResponse.fromJson(Map<String, dynamic> json) =>
      _$PurchaseItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseItemResponseToJson(this);
}
