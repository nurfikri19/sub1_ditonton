import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/hptv/hptv.dart';
import 'package:ditonton/domain/usecases/hptv/get_hptv_detail.dart';
import 'package:ditonton/domain/usecases/hptv/get_hptv_recomendations.dart';
import 'package:ditonton/domain/usecases/hptv/get_watchlist_status_hptv.dart';
import 'package:ditonton/domain/usecases/hptv/remove_watchlist_hptv.dart';
import 'package:ditonton/domain/usecases/hptv/save_watchlist_hptv.dart';
import 'package:ditonton/presentation/provider/hptv/hptv_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects_hptv.dart';
import 'hptv_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetHptvDetail,
  GetHptvRecommendations,
  GetWatchListStatusHptv,
  SaveWatchlistHptv,
  RemoveWatchlistHptv,
])
void main() {
  late HptvDetailNotifier provider;
  late MockGetHptvDetail mockGetTvDetail;
  late MockGetHptvRecommendations mockGetTvRecommendations;
  late MockGetWatchListStatusHptv mockGetWatchlistStatus;
  late MockSaveWatchlistHptv mockSaveWatchlist;
  late MockRemoveWatchlistHptv mockRemoveWatchlist;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvDetail = MockGetHptvDetail();
    mockGetTvRecommendations = MockGetHptvRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatusHptv();
    mockSaveWatchlist = MockSaveWatchlistHptv();
    mockRemoveWatchlist = MockRemoveWatchlistHptv();
    provider = HptvDetailNotifier(
      getHptvDetail: mockGetTvDetail,
      getHptvRecommendations: mockGetTvRecommendations,
      getWatchListStatusHptv: mockGetWatchlistStatus,
      saveWatchlistHptv: mockSaveWatchlist,
      removeWatchlistHptv: mockRemoveWatchlist,
    )..addListener(() {
      listenerCallCount += 1;
    });
  });

  final tId = 1;

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
  final tTvs = <Hptv>[tTv];

  void _arrangeUsecase() {
    when(mockGetTvDetail.execute(tId))
        .thenAnswer((_) async => Right(testTvDetail));
    when(mockGetTvRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tTvs));
  }

  group('Get Tv Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvDetail(tId);
      // assert
      verify(mockGetTvDetail.execute(tId));
      verify(mockGetTvRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchTvDetail(tId);
      // assert
      expect(provider.tvState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change tv when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvDetail(tId);
      // assert
      expect(provider.tvState, RequestState.Loaded);
      expect(provider.tv, testTvDetail);
      expect(listenerCallCount, 3);
    });

    test('should change recommendation tv when data is gotten successfully',
            () async {
          // arrange
          _arrangeUsecase();
          // act
          await provider.fetchTvDetail(tId);
          // assert
          expect(provider.tvState, RequestState.Loaded);
          expect(provider.tvRecommendations, tTvs);
        });
  });

  group('Get Tv Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvDetail(tId);
      // assert
      verify(mockGetTvRecommendations.execute(tId));
      expect(provider.tvRecommendations, tTvs);
    });

    test('should update recommendation state when data is gotten successfully',
            () async {
          // arrange
          _arrangeUsecase();
          // act
          await provider.fetchTvDetail(tId);
          // assert
          expect(provider.recommendationTvState, RequestState.Loaded);
          expect(provider.tvRecommendations, tTvs);
        });

    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvDetail));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await provider.fetchTvDetail(tId);
      // assert
      expect(provider.recommendationTvState, RequestState.Error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatusTv(1);
      // assert
      expect(provider.isAddedToWatchlistTv, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchlistStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlistTv(testTvDetail);
      // assert
      verify(mockSaveWatchlist.execute(testTvDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchlistStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlistTv(testTvDetail);
      // assert
      verify(mockRemoveWatchlist.execute(testTvDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlistTv(testTvDetail);
      // assert
      verify(mockGetWatchlistStatus.execute(testTvDetail.id));
      expect(provider.isAddedToWatchlistTv, true);
      expect(provider.watchlistMessageTv, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.addWatchlistTv(testTvDetail);
      // assert
      expect(provider.watchlistMessageTv, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTvs));
      // act
      await provider.fetchTvDetail(tId);
      // assert
      expect(provider.tvState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}