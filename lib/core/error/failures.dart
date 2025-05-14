abstract class Failure {
  final String message;
  const Failure(this.message);
}
class DataParsingFailure extends Failure {
  const DataParsingFailure(super.msg);
}

class ServerFailure extends Failure {
  const ServerFailure(super.msg);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.msg);
}
