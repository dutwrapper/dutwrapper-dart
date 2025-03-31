enum DutWrapperExceptionReason {
  unknown(-1),
  applicationError(0),
  internetNotFound(1),
  serverNotFound(2),
  notAuthorized(3),
  parameterException(4),
  dataNotFoundException(5);

  const DutWrapperExceptionReason(this.value);
  final int value;
}

class DutWrapperException implements Exception {
  final String? message;
  final DutWrapperExceptionReason reason;

  const DutWrapperException({
    this.message,
    this.reason = DutWrapperExceptionReason.unknown,
  });
}
