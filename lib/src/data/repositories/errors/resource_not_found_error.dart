part of 'errors.dart';

class ResourceNotFoundError extends BaseError {
  ResourceNotFoundError(String message)
      : super(type: ErrorType.repositoryInconsistentState, message: message);
}
