import 'package:about/about.dart';
import 'package:core/presentation/pages/home_page.dart';
import 'package:core/presentation/pages/intro_page.dart';
import 'package:core/presentation/pages/start_page.dart';
import 'package:core/presentation/pages/watchlist_page.dart';
import 'package:core/presentation/provider/home_notifier.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:movie/presentation/pages/upcoming_movies_page.dart';
import 'package:movie/presentation/provider/movie_detail_notifier.dart';
import 'package:movie/presentation/provider/movie_images_notifier.dart';
import 'package:movie/presentation/provider/movie_list_notifier.dart';
import 'package:movie/presentation/provider/popular_movies_notifier.dart';
import 'package:movie/presentation/provider/top_rated_movies_notifier.dart';
import 'package:movie/presentation/provider/upcoming_movies_notifier.dart';
import 'package:movie/presentation/provider/watchlist_movie_notifier.dart';
import 'package:provider/provider.dart';
import 'package:search/presentation/pages/tv_search_page.dart';
import 'package:search/search.dart';
import 'package:tv/presentation/pages/popular_tvs_page.dart';
import 'package:tv/presentation/pages/showing_today_tvs_page.dart';
import 'package:tv/presentation/pages/top_rated_tvs_page.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'package:tv/presentation/provider/popular_tvs_notifier.dart';
import 'package:tv/presentation/provider/showing_today_tvs_notifier.dart';
import 'package:tv/presentation/provider/top_rated_tvs_notifier.dart';
import 'package:tv/presentation/provider/tv_detail_notifier.dart';
import 'package:tv/presentation/provider/tv_images_notifier.dart';
import 'package:tv/presentation/provider/tv_list_notifier.dart';
import 'package:tv/presentation/provider/tv_season_episodes_notifier.dart';
import 'package:tv/presentation/provider/watchlist_tv_provider.dart';
import 'injection.dart' as di;

Future<void> main() async {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// General
        ChangeNotifierProvider(
          create: (_) => di.locator<HomeNotifier>(),
        ),

        /// Movie
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<UpcomingMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieImagesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistMovieNotifier>(),
        ),

        /// Tv
        ChangeNotifierProvider(
          create: (_) => di.locator<TvListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularTvsNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<ShowingTodayTvsNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedTvsNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvSeasonEpisodesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvImagesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistTvNotifier>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieSearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSearchBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flix 256',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          colorScheme: kColorScheme.copyWith(
            secondary: Colors.redAccent,
          ),
        ),
        home: const StartPage(),

        // ChangeNotifierProvider<BottomNavigationBarProvider>(
        //   child: const BottomNavigationBarExample(),
        //   create: (BuildContext context) => BottomNavigationBarProvider(),
        // ),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => const HomePage());
            case PopularMoviesPage.routeName:
              return MaterialPageRoute(
                  builder: (_) => const PopularMoviesPage());
            case UpcomingMoviesPage.routeName:
              return MaterialPageRoute(builder: (_) => const UpcomingMoviesPage());
            case TopRatedMoviesPage.routeName:
              return MaterialPageRoute(
                  builder: (_) => const TopRatedMoviesPage());
            case MovieDetailPage.routeName:
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: settings.arguments as int),
                settings: settings,
              );
            case PopularTvsPage.routeName:
              return MaterialPageRoute(builder: (_) => const PopularTvsPage());
            case ShowingTodayTvsPage.routeName:
              return MaterialPageRoute(builder: (_) => const ShowingTodayTvsPage());
            case TopRatedTvsPage.routeName:
              return MaterialPageRoute(builder: (_) => const TopRatedTvsPage());
            case TvDetailPage.routeName:
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: settings.arguments as int),
                settings: settings,
              );
            case MovieSearchPage.routeName:
              return MaterialPageRoute(builder: (_) => const MovieSearchPage());
            case TvSearchPage.routeName:
              return MaterialPageRoute(builder: (_) => const TvSearchPage());
            case WatchlistPage.routeName:
              return MaterialPageRoute(builder: (_) => const WatchlistPage());
            case AboutPage.routeName:
              return MaterialPageRoute(builder: (_) => const AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return const Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({Key? key}) : super(key: key);

  @override
  _BottomNavigationBarExampleState createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  var currentTab = [
    const IntroPage(),
    const HomePage(),
    const WatchlistPage(),
  ];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<BottomNavigationBarProvider>(context);
    return Scaffold(
      body: currentTab[provider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: provider.currentIndex,
        type: BottomNavigationBarType.fixed, // Fixed 
        backgroundColor: Colors.transparent,
        onTap: (index) {
          provider.currentIndex = index;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Watch List',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings),
          //   title: Text('Settings'),
          // )
        ],
      ),
    );
  }
}

class BottomNavigationBarProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}