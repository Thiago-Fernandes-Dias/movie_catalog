part of 'fixtures.dart';

class MockTMDBRestApiClient extends Mock implements TMDBRestApiClient {}

class MockMoviesRepository extends Mock implements MoviesRepository {}

class MockSearchRepository extends Mock implements SearchRepository {}

class MockOnRequestCallback extends Mock implements OnRequestCallbackObserver {}

class MockOnResponseCallback extends Mock implements OnResponseCallbackObserver {}

class MockOnBaseExceptionCallback extends Mock implements OnBaseExceptionCallbackObserver {}
