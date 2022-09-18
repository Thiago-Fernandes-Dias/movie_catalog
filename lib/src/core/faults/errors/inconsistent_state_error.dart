part of 'errors.dart';

class InconsistentStateError extends BaseError {
  InconsistentStateError(String message) 
      : super(message: message, type: ErrorType.insistentErrorState);

  InconsistentStateError.repository(String message)
      : super(message: message, type: ErrorType.repositoryInconsistentState);

  InconsistentStateError.service(String message)
      : super(message: message, type: ErrorType.serviceInconsistentState);
  
  InconsistentStateError.gateway(String message)
      : super(message: message, type: ErrorType.gatewayInconsistentState);
}