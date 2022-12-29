import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:movie/presentation/provider/top_rated_movies_notifier.dart';
import 'package:provider/provider.dart';

import 'top_rated_movies_page_test.mocks.dart';

@GenerateMocks([TopRatedMoviesNotifier])
void main() {
  late MockTopRatedMoviesNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTopRatedMoviesNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TopRatedMoviesNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    'page should display progress bar when loading',
    (WidgetTester tester) async {
      // arrange
      when(mockNotifier.state).thenReturn(RequestState.loading);

      // act
      final centerFinder = find.byType(Center);
      final progressFinder = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

      // assert
      expect(centerFinder, equals(findsOneWidget));
      expect(progressFinder, equals(findsOneWidget));
    },
  );

  testWidgets(
    'page should display when data is loaded',
    (WidgetTester tester) async {
      // arrange
      when(mockNotifier.state).thenReturn(RequestState.loaded);
      when(mockNotifier.movies).thenReturn(<Movie>[]);

      // act
      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(
        _makeTestableWidget(const TopRatedMoviesPage()),
        const Duration(milliseconds: 500),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // assert
      expect(listViewFinder, equals(findsOneWidget));
    },
  );

  testWidgets(
    'page should display text with message when error',
    (WidgetTester tester) async {
      // arrange
      when(mockNotifier.state).thenReturn(RequestState.error);
      when(mockNotifier.message).thenReturn('Error message');

      // act
      final textFinder = find.byKey(const Key('error_message'));

      await tester.pumpWidget(
        _makeTestableWidget(const TopRatedMoviesPage()),
        const Duration(milliseconds: 500),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // assert
      expect(textFinder, equals(findsOneWidget));
    },
  );
}
