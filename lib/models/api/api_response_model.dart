class ApiFailResponse {
  final String status;
  final dynamic message;
  final String error;

  ApiFailResponse({required this.status, this.message, required this.error});

  factory ApiFailResponse.fromJson(Map<String, dynamic> json) {
    return ApiFailResponse(
      status: json['status'],
      message: json['message'],
      error: json['error'],
    );
  }
}
