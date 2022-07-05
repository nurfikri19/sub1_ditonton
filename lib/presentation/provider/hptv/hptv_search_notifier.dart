import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/hptv/hptv.dart';
import 'package:ditonton/domain/usecases/hptv/search_hptv.dart';
import 'package:flutter/foundation.dart';

class HptvSearchNotifier extends ChangeNotifier {
  final SearchHptv searchTv;

  HptvSearchNotifier({required this.searchTv});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Hptv> _searchTvResult = [];
  List<Hptv> get searchTvResult => _searchTvResult;

  String _message = '';
  String get message => _message;

  Future<void> fetchTvSearch(String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await searchTv.execute(query);
    result.fold(
          (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
          (data) {
        _searchTvResult = data;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
