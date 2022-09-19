part of 'errors.dart';

class RequestTimeoutError extends BaseError {
  RequestTimeoutError()
      : super(
          message: 'The request taken to long to answer. '
              'Verify your connection settings and try again',
          type: ErrorType.repositoryInconsistentState,
        );
}
