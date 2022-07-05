import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/hptv/hptv_detail.dart';
import 'package:ditonton/domain/repositories/hptv_repository.dart';

class SaveWatchlistHptv {
  final HptvRepository repository;

  SaveWatchlistHptv(this.repository);

  Future<Either<Failure, String>> execute(HptvDetail tv) {
    return repository.saveWatchlistTv(tv);
  }
}
