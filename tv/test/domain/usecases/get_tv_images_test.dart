import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_tv_images.dart';

import '../../helpers/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvRepository mockTvRepository;
  late GetTvImages usecase;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvImages(mockTvRepository);
  });

  const tId = 1;

  test(
    'should get tv images from the repository',
    () async {
      // arrange
      when(mockTvRepository.getTvImages(tId))
          .thenAnswer((_) async => const Right(testImages));

      // act
      final result = await usecase.execute(tId);

      // assert
      expect(result, equals(const Right(testImages)));
    },
  );
}
