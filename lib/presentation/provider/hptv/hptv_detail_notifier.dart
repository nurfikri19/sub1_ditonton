import 'package:ditonton/domain/entities/hptv/hptv.dart';
import 'package:ditonton/domain/entities/hptv/hptv_detail.dart';
import 'package:ditonton/domain/usecases/hptv/get_hptv_detail.dart';
import 'package:ditonton/domain/usecases/hptv/get_hptv_recomendations.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/hptv/get_watchlist_status_hptv.dart';
import 'package:ditonton/domain/usecases/hptv/remove_watchlist_hptv.dart';
import 'package:ditonton/domain/usecases/hptv/save_watchlist_hptv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HptvDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetHptvDetail getHptvDetail;
  final GetHptvRecommendations getHptvRecommendations;
  final GetWatchListStatusHptv getWatchListStatusHptv;
  final SaveWatchlistHptv saveWatchlistHptv;
  final RemoveWatchlistHptv removeWatchlistHptv;

  HptvDetailNotifier({
    required this.getHptvDetail,
    required this.getHptvRecommendations,
    required this.getWatchListStatusHptv,
    required this.saveWatchlistHptv,
    required this.removeWatchlistHptv,
  });

  late HptvDetail _tv;
  HptvDetail get tv => _tv;

  RequestState _tvState = RequestState.Empty;
  RequestState get tvState => _tvState;

  List<Hptv> _tvRecommendations = [];
  List<Hptv> get tvRecommendations => _tvRecommendations;

  RequestState _recommendationTvState = RequestState.Empty;
  RequestState get recommendationTvState => _recommendationTvState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlistTv = false;
  bool get isAddedToWatchlistTv => _isAddedtoWatchlistTv;

  Future<void> fetchTvDetail(int id) async {
    _tvState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getHptvDetail.execute(id);
    final recommendationResult = await getHptvRecommendations.execute(id);
    detailResult.fold(
          (failure) {
        _tvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tv) {
        _recommendationTvState = RequestState.Loading;
        _tv = tv;
        notifyListeners();
        recommendationResult.fold(
              (failure) {
            _recommendationTvState = RequestState.Error;
            _message = failure.message;
          },
              (tv) {
            _recommendationTvState = RequestState.Loaded;
            _tvRecommendations = tv;
          },
        );
        _tvState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessageTv = '';
  String get watchlistMessageTv => _watchlistMessageTv;

  Future<void> addWatchlistTv(HptvDetail tv) async {
    final result = await saveWatchlistHptv.execute(tv);

    await result.fold(
          (failure) async {
        _watchlistMessageTv = failure.message;
      },
          (successMessage) async {
        _watchlistMessageTv = successMessage;
      },
    );

    await loadWatchlistStatusTv(tv.id);
  }

  Future<void> removeFromWatchlistTv(HptvDetail tv) async {
    final result = await removeWatchlistHptv.execute(tv);

    await result.fold(
          (failure) async {
        _watchlistMessageTv = failure.message;
      },
          (successMessage) async {
        _watchlistMessageTv = successMessage;
      },
    );

    await loadWatchlistStatusTv(tv.id);
  }

  Future<void> loadWatchlistStatusTv(int id) async {
    final result = await getWatchListStatusHptv.execute(id);
    _isAddedtoWatchlistTv = result;
    notifyListeners();
  }
}
