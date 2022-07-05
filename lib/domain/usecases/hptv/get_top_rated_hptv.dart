import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/hptv/hptv.dart';
import 'package:ditonton/domain/repositories/hptv_repository.dart';

class GetTopRatedHptv {
  final HptvRepository repository;

  GetTopRatedHptv(this.repository);

  Future<Either<Failure, List<Hptv>>> execute() {
    return repository.getTopRatedTv();
  }
}
