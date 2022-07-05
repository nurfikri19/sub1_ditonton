import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/hptv/hptv.dart';
import 'package:ditonton/domain/usecases/hptv/get_watchlist_hptv.dart';
import 'package:flutter/foundation.dart';

class WatchlistHptvNotifier extends ChangeNotifier {
  var _watchlistTv = <Hptv>[];
  List<Hptv> get watchlistTv => _watchlistTv;

  var _watchlistTvState = RequestState.Empty;
  RequestState get watchlistTvState => _watchlistTvState;

  String _message = '';
  String get message => _message;

  WatchlistHptvNotifier({required this.getWatchlistTv});

  final GetWatchlistHptv getWatchlistTv;

  Future<void> fetchWatchlistTv() async {
    _watchlistTvState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistTv.execute();
    result.fold(
          (failure) {
        _watchlistTvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvData) {
        _watchlistTvState = RequestState.Loaded;
        _watchlistTv = tvData;
        notifyListeners();
      },
    );
  }
}
