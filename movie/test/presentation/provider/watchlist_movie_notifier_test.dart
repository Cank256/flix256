import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';
import 'package:movie/presentation/provider/watchlist_movie_notifier.dart';

import '../../helpers/dummy_objects.dart';
import 'watchlist_movie_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late int listenerCallCount;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late WatchlistMovieNotifier provider;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    provider = WatchlistMovieNotifier(
      getWatchlistMovies: mockGetWatchlistMovies,
    )..addListener(() {
        listenerCallCount++;
      });
  });

  test(
    'should change movies when data is gotten successfully',
    () async {
      // arrange
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right([testWatchlistMovie]));

      // act
      await provider.fetchWatchlistMovies();

      // assert
      expect(provider.watchlistState, equals(RequestState.loaded));
      expect(provider.watchlistMovies, equals([testWatchlistMovie]));
      expect(listenerCallCount, equals(2));
    },
  );

  test(
    'should return database failure when error',
    () async {
      // arrange
      when(mockGetWatchlistMovies.execute()).thenAnswer(
          (_) async => const Left(DatabaseFailure('Can\'t get data')));

      // act
      await provider.fetchWatchlistMovies();

      // assert
      expect(provider.watchlistState, equals(RequestState.error));
      expect(provider.message, equals('Can\'t get data'));
      expect(listenerCallCount, equals(2));
    },
  );
}
