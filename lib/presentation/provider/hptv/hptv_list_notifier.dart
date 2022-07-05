import 'package:ditonton/domain/entities/hptv/hptv.dart';
import 'package:ditonton/domain/usecases/hptv/get_now_playing_hptv.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/hptv/get_popular_hptv.dart';
import 'package:ditonton/domain/usecases/hptv/get_top_rated_hptv.dart';
import 'package:flutter/material.dart';

class HptvListNotifier extends ChangeNotifier {
  var _nowPlayingTv = <Hptv>[];
  List<Hptv> get nowPlayingTv => _nowPlayingTv;

  RequestState _nowPlayingTvState = RequestState.Empty;
  RequestState get nowPlayingTvState => _nowPlayingTvState;

  var _popularTv = <Hptv>[];
  List<Hptv> get popularTv => _popularTv;

  RequestState _popularTvState = RequestState.Empty;
  RequestState get popularTvState => _popularTvState;

  var _topRatedTv = <Hptv>[];
  List<Hptv> get topRatedTv => _topRatedTv;

  RequestState _topRatedTvState = RequestState.Empty;
  RequestState get topRatedTvState => _topRatedTvState;

  String _message = '';
  String get message => _message;

  HptvListNotifier({
    required this.getNowPlayingHptv,
    required this.getPopularHptv,
    required this.getTopRatedHptv,
  });

  final GetNowPlayingHptv getNowPlayingHptv;
  final GetPopularHptv getPopularHptv;
  final GetTopRatedHptv getTopRatedHptv;

  Future<void> fetchNowPlayingTv() async {
    _nowPlayingTvState = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingHptv.execute();
    result.fold(
          (failure) {
        _nowPlayingTvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvData) {
        _nowPlayingTvState = RequestState.Loaded;
        _nowPlayingTv = tvData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTv() async {
    _popularTvState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularHptv.execute();
    result.fold(
          (failure) {
        _popularTvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvData) {
        _popularTvState = RequestState.Loaded;
        _popularTv = tvData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTv() async {
    _topRatedTvState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedHptv.execute();
    result.fold(
          (failure) {
        _topRatedTvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvData) {
        _topRatedTvState = RequestState.Loaded;
        _topRatedTv = tvData;
        notifyListeners();
      },
    );
  }
}
