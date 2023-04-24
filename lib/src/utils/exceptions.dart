// ignore_for_file: public_member_api_docs

abstract class ReException implements Exception {
  ReException({this.message}) : super();

  /// A message describing the format error.
  final String? message;

  @override
  String toString() {
    return message ?? 'ReException';
  }
}

class ReDuplicateEventHandlerException extends ReException {
  ReDuplicateEventHandlerException(Type eventType)
      : super(message: 'The event of type $eventType already has a handler.');
}
