import 'package:ditonton/presentation/provider/hptv/top_rated_hptv_notifier.dart';
import 'package:mockito/annotations.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/hptv/hptv.dart';
import 'package:ditonton/presentation/pages/top_rated_hptv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'top_rated_hptv_page_test.mocks.dart';

@GenerateMocks([TopRatedHptvNotifier])
void main() {
  late MockTopRatedHptvNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTopRatedHptvNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TopRatedHptvNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
          (WidgetTester tester) async {
        when(mockNotifier.state).thenReturn(RequestState.Loading);

        final progressFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(TopRatedHptvPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressFinder, findsOneWidget);
      });

  testWidgets('Page should display when data is loaded',
          (WidgetTester tester) async {
        when(mockNotifier.state).thenReturn(RequestState.Loaded);
        when(mockNotifier.tv).thenReturn(<Hptv>[]);

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(TopRatedHptvPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(mockNotifier.state).thenReturn(RequestState.Error);
        when(mockNotifier.message).thenReturn('Error message');

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(TopRatedHptvPage()));

        expect(textFinder, findsOneWidget);
      });
}