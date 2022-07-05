import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/hptv/get_hptv_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects_hptv.dart';
import '../../../helpers/test_helper_hptv.mocks.dart';

void main() {
  late GetHptvDetail usecase;
  late MockHptvRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockHptvRepository();
    usecase = GetHptvDetail(mockMovieRepository);
  });

  final tId = 1;

  test('should get tv detail from the repository', () async {
    // arrange
    when(mockMovieRepository.getTvDetail(tId))
        .thenAnswer((_) async => Right(testTvDetail));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(testTvDetail));
  });
}