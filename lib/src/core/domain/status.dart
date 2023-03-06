// Global Status
class Status {
  const Status();

  factory Status.initial() => const StatusInitial();
  factory Status.loading() => const StatusLoading();
  factory Status.success() => const StatusSuccess();
  factory Status.failure([Failure? failure]) => StatusFailure(failure);
}

class StatusInitial extends Status {
  const StatusInitial();
}

class StatusLoading extends Status {
  const StatusLoading();
}

class StatusSuccess extends Status {
  const StatusSuccess();
}

class StatusFailure extends Status {
  const StatusFailure([
    this.failure,
  ]);

  final Failure? failure;
}

// Failure
class Failure implements Exception {
  const Failure([this.failureMessage]);

  factory Failure.common(String message) => CommonFailure(message);
  factory Failure.value(String message) => ValueFailure(message);
  factory Failure.network() => const NetworkFailure();
  factory Failure.server(String message) => ServerFailure(message);
  factory Failure.unexpected(String message) => UnexpectedFailure(message);

  final String? failureMessage;
}

class CommonFailure extends Failure {
  const CommonFailure(this.message) : super(message);

  final String message;
}

class ValueFailure extends Failure {
  const ValueFailure(this.message) : super(message);

  final String message;
}

class NetworkFailure extends Failure {
  const NetworkFailure();
}

class ServerFailure extends Failure {
  const ServerFailure(this.message) : super(message);

  final String message;
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(this.message) : super(message);

  final String message;
}
