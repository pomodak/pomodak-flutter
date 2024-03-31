import 'package:json_annotation/json_annotation.dart';

part 'base_api_response.g.dart';

@JsonSerializable(
  genericArgumentFactories: true,
)
class BaseApiResponse<T> {
  final String status; // success | error
  final String? message;
  final String? error;
  final T? data;

  BaseApiResponse({
    required this.status,
    this.data,
    this.error,
    this.message,
  });

  factory BaseApiResponse.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$BaseApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BaseApiResponseToJson(this, toJsonT);
}
