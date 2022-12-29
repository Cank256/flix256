import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/remove_watchlist_movie.dart';

import '../../helpers/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockMovieRepository mockMovieRepository;
  late RemoveWatchlistMovie usecase;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = RemoveWatchlistMovie(
      movieRepository: mockMovieRepository,
    );
  });

  test(
    'should remove a movie from repository',
    () async {
      // arrange
      when(mockMovieRepository.removeWatchlist(testMovieDetail))
          .thenAnswer((_) async => const Right('Removed from watchlist'));

      // act
      final result = await usecase.execute(testMovieDetail);

      // assert
      verify(mockMovieRepository.removeWatchlist(testMovieDetail));
      expect(result, equals(const Right('Removed from watchlist')));
    },
  );
}
