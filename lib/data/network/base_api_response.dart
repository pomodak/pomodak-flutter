enum Status { loading, completed, error }

class ApiResponse<T> {
  Status? status;
  T? data;
  String? message;

  ApiResponse(this.status, this.data, this.message);

  void loading() {
    status = Status.loading;
  }

  void completed() {
    status = Status.completed;
  }

  void error() {
    status = Status.error;
  }

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data: $data";
  }
}
