import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

import '../entities/tv.dart';
import '../repositories/tv_repository.dart';

class GetShowingTodayTvs {
  final TvRepository repository;

  GetShowingTodayTvs(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getShowingTodayTvs();
  }
}
