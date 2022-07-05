import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/hptv/hptv.dart';
import 'package:ditonton/domain/usecases/hptv/get_now_playing_hptv.dart';
import 'package:ditonton/domain/usecases/hptv/get_popular_hptv.dart';
import 'package:ditonton/domain/usecases/hptv/get_top_rated_hptv.dart';
import 'package:ditonton/presentation/provider/hptv/hptv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'hptv_list_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingHptv, GetPopularHptv, GetTopRatedHptv])
void main() {
  late HptvListNotifier provider;
  late MockGetNowPlayingHptv mockGetNowPlayingTv;
  late MockGetPopularHptv mockGetPopularTv;
  late MockGetTopRatedHptv mockGetTopRatedTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingTv = MockGetNowPlayingHptv();
    mockGetPopularTv = MockGetPopularHptv();
    mockGetTopRatedTv = MockGetTopRatedHptv();
    provider = HptvListNotifier(
      getNowPlayingHptv: mockGetNowPlayingTv,
      getPopularHptv: mockGetPopularTv,
      getTopRatedHptv: mockGetTopRatedTv,
    )..addListener(() {
      listenerCallCount += 1;
    });
  });

  final tTv = Hptv(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTvList = <Hptv>[tTv];

  group('now playing tv', () {
    test('initialState should be Empty', () {
      expect(provider.nowPlayingTvState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchNowPlayingTv();
      // assert
      verify(mockGetNowPlayingTv.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchNowPlayingTv();
      // assert
      expect(provider.nowPlayingTvState, RequestState.Loading);
    });

    test('should change tv when data is gotten successfully', () async {
      // arrange
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchNowPlayingTv();
      // assert
      expect(provider.nowPlayingTvState, RequestState.Loaded);
      expect(provider.nowPlayingTv, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchNowPlayingTv();
      // assert
      expect(provider.nowPlayingTvState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular tv', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchPopularTv();
      // assert
      expect(provider.popularTvState, RequestState.Loading);
      // verify(provider.setState(RequestState.Loading));
    });

    test('should change tv data when data is gotten successfully',
            () async {
          // arrange
          when(mockGetPopularTv.execute())
              .thenAnswer((_) async => Right(tTvList));
          // act
          await provider.fetchPopularTv();
          // assert
          expect(provider.popularTvState, RequestState.Loaded);
          expect(provider.popularTv, tTvList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularTv();
      // assert
      expect(provider.popularTvState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated tv', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchTopRatedTv();
      // assert
      expect(provider.topRatedTvState, RequestState.Loading);
    });

    test('should change tv data when data is gotten successfully',
            () async {
          // arrange
          when(mockGetTopRatedTv.execute())
              .thenAnswer((_) async => Right(tTvList));
          // act
          await provider.fetchTopRatedTv();
          // assert
          expect(provider.topRatedTvState, RequestState.Loaded);
          expect(provider.topRatedTv, tTvList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedTv();
      // assert
      expect(provider.topRatedTvState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}