class AppException implements Exception {
  final String? _message;
  final String? _prefix;
  AppException([this._message, this._prefix]);

  @override
  String toString() {
    if (_prefix == null) {
      return '$_message';
    }
    return '$_prefix - $_message';
  }
}

// 서버에서 전달되는 메세지 사용
class FetchCustomException extends AppException {
  FetchCustomException([
    super.message,
  ]);
}

class FetchDataException extends AppException {
  FetchDataException([
    String? message,
  ]) : super(message, "Error Dururing communication");
}

class BadRequestException extends AppException {
  BadRequestException([
    String? message,
  ]) : super(message, "Invalid request");
}

class UnauthorizedException extends AppException {
  UnauthorizedException([
    String? message,
  ]) : super(message, "Unauthorized request");
}

class InvalidInputException extends AppException {
  InvalidInputException([
    String? message,
  ]) : super(message, "Invalid input");
}
