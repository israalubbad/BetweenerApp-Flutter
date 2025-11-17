class ApiResponse<T> {
  Status status;
  T? data;
  String? message;

  ApiResponse.loading([this.message]) : status = Status.LOADING;
  ApiResponse.completed(this.data) : status = Status.COMPLETED;
  ApiResponse.error([this.message]) : status = Status.ERROR;

  bool get isLoading => status == Status.LOADING;
  bool get isCompleted => status == Status.COMPLETED;
  bool get isError => status == Status.ERROR;

  @override
  String toString() {
    return "Status: $status \nMessage: $message \nData: $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR }
