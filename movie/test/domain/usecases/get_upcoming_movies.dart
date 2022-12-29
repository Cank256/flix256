import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_upcoming_movies.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockMovieRepository mockMovieRepository;
  late GetUpcomingMovies usecase;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetUpcomingMovies(mockMovieRepository);
  });

  final tMovies = <Movie>[];

  test(
    'should get list of movie from the repository',
    () async {
      // arrange
      when(mockMovieRepository.getUpcomingMovies())
          .thenAnswer((_) async => Right(tMovies));

      // act
      final result = await usecase.execute();

      // assert
      expect(result, equals(Right(tMovies)));
    },
  );
}
