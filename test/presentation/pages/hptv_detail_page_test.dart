import 'package:ditonton/presentation/provider/hptv/hptv_detail_notifier.dart';
import 'package:mockito/annotations.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/hptv/hptv.dart';
import 'package:ditonton/presentation/pages/hptv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects_hptv.dart';
import 'hptv_detail_page_test.mocks.dart';

@GenerateMocks([HptvDetailNotifier])
void main() {
  late MockHptvDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockHptvDetailNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<HptvDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
          (WidgetTester tester) async {
        when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tv).thenReturn(testTvDetail);
        when(mockNotifier.recommendationTvState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvRecommendations).thenReturn(<Hptv>[]);
        when(mockNotifier.isAddedToWatchlistTv).thenReturn(false);

        final watchlistButtonIcon = find.byIcon(Icons.add);

        await tester.pumpWidget(_makeTestableWidget(HptvDetailPage(id: 1)));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should dispay check icon when tv is added to wathclist',
          (WidgetTester tester) async {
        when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tv).thenReturn(testTvDetail);
        when(mockNotifier.recommendationTvState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvRecommendations).thenReturn(<Hptv>[]);
        when(mockNotifier.isAddedToWatchlistTv).thenReturn(true);

        final watchlistButtonIcon = find.byIcon(Icons.check);

        await tester.pumpWidget(_makeTestableWidget(HptvDetailPage(id: 1)));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
          (WidgetTester tester) async {
        when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tv).thenReturn(testTvDetail);
        when(mockNotifier.recommendationTvState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvRecommendations).thenReturn(<Hptv>[]);
        when(mockNotifier.isAddedToWatchlistTv).thenReturn(false);
        when(mockNotifier.watchlistMessageTv).thenReturn('Added to Watchlist');

        final watchlistButton = find.byType(ElevatedButton);

        await tester.pumpWidget(_makeTestableWidget(HptvDetailPage(id: 1)));

        expect(find.byIcon(Icons.add), findsOneWidget);

        await tester.tap(watchlistButton);
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Added to Watchlist'), findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
          (WidgetTester tester) async {
        when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tv).thenReturn(testTvDetail);
        when(mockNotifier.recommendationTvState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvRecommendations).thenReturn(<Hptv>[]);
        when(mockNotifier.isAddedToWatchlistTv).thenReturn(false);
        when(mockNotifier.watchlistMessageTv).thenReturn('Failed');

        final watchlistButton = find.byType(ElevatedButton);

        await tester.pumpWidget(_makeTestableWidget(HptvDetailPage(id: 1)));

        expect(find.byIcon(Icons.add), findsOneWidget);

        await tester.tap(watchlistButton);
        await tester.pump();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Failed'), findsOneWidget);
      });
}