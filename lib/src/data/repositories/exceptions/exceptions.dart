import '../../../core/faults/exceptions/exceptions.dart';

class MovieNotFoundException extends BaseException {
  MovieNotFoundException({String? message}) : super(message ?? 'Filme não encontrado');
}
