import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/tv.dart';
import '../../domain/usecases/get_showing_today_tvs.dart';

class ShowingTodayTvsNotifier extends ChangeNotifier {
  final GetShowingTodayTvs getShowingTodayTvs;

  ShowingTodayTvsNotifier(this.getShowingTodayTvs);

  List<Tv> _tvs = <Tv>[];
  List<Tv> get tvs => _tvs;

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  String _message = '';
  String get message => _message;

  Future<void> fetchShowingTodayTvs() async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await getShowingTodayTvs.execute();
    result.fold(
      (failure) {
        _state = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _state = RequestState.loaded;
        _tvs = tvsData;
        notifyListeners();
      },
    );
  }
}
