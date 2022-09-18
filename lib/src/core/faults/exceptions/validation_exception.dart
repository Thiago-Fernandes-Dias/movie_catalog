part of 'exceptions.dart';

class ValidationException extends BaseException {
  const ValidationException.emptyField() : super(type: ExceptionType.emptyField);
  
  const ValidationException.fieldLengthExceeded(String message) 
      : super(message: message, type: ExceptionType.fieldLengthExceeded);
}