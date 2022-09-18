part of 'errors.dart';

class SerializationError extends BaseError {
  SerializationError(String message) : super(message: message, type: ErrorType.serialization);
}