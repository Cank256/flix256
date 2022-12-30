import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:core/utils/state_enum.dart';
import 'package:core/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../provider/movie_images_notifier.dart';
import '../provider/movie_list_notifier.dart';
import '../widgets/horizontal_item_list.dart';
import '../widgets/minimal_detail.dart';
import '../widgets/sub_heading.dart';
import 'popular_movies_page.dart';
import 'top_rated_movies_page.dart';
import 'upcoming_movies_page.dart';

class MainMoviePage extends StatefulWidget {
  const MainMoviePage({Key? key}) : super(key: key);

  @override
  _MainMoviePageState createState() => _MainMoviePageState();
}

class _MainMoviePageState extends State<MainMoviePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<MovieListNotifier>(context, listen: false)
          .fetchNowPlayingMovies()
          .whenComplete(
            () => Provider.of<MovieImagesNotifier>(context, listen: false)
                .fetchMovieImages(
              Provider.of<MovieListNotifier>(context, listen: false)
                  .nowPlayingMovies[0]
                  .id,
            ),
          );
      Provider.of<MovieListNotifier>(context, listen: false)
          .fetchUpcomingMovies();
      Provider.of<MovieListNotifier>(context, listen: false)
          .fetchPopularMovies();
      Provider.of<MovieListNotifier>(context, listen: false)
          .fetchTopRatedMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        key: const Key('movieScrollView'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<MovieListNotifier>(builder: (context, data, child) {
              if (data.nowPlayingState == RequestState.loaded) {
                return FadeIn(
                  duration: const Duration(milliseconds: 500),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 300.0,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        Provider.of<MovieImagesNotifier>(context, listen: false)
                            .fetchMovieImages(data.nowPlayingMovies[index].id);
                      },
                    ),
                    items: data.nowPlayingMovies.map(
                      (item) {
                        return GestureDetector(
                          key: const Key('openMovieMinimalDetail'),
                          onTap: () {
                            showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                              ),
                              context: context,
                              builder: (context) {
                                return MinimalDetail(
                                  keyValue: 'goToMovieDetail',
                                  closeKeyValue: 'closeMovieMinimalDetail',
                                  movie: item,
                                );
                              },
                            );
                          },
                          child: Stack(
                            children: [
                              ShaderMask(
                                shaderCallback: (rect) {
                                  return const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black,
                                      Colors.black,
                                      Colors.transparent,
                                    ],
                                    stops: [0, 0.3, 0.5, 1],
                                  ).createShader(
                                    Rect.fromLTRB(
                                        0, 0, rect.width, rect.height),
                                  );
                                },
                                blendMode: BlendMode.dstIn,
                                child: CachedNetworkImage(
                                  height: 300.0,
                                  imageUrl: Urls.imageUrl(item.backdropPath!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.circle,
                                            color: Colors.redAccent,
                                            size: 16.0,
                                          ),
                                          const SizedBox(width: 4.0),
                                          Text(
                                            'Now Playing'.toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: Consumer<MovieImagesNotifier>(
                                        builder: (context, data, child) {
                                          if (data.movieImagesState ==
                                              RequestState.loaded) {
                                            if (data.movieImages.logoPaths.isEmpty || data.movieImages.logoPaths[0].contains('svg')) {
                                              return Text(item.title!);
                                            }
                                            return CachedNetworkImage(
                                              width: 200.0,
                                              imageUrl: Urls.imageUrl(
                                                data.movieImages.logoPaths[0],
                                              ),
                                            );
                                          } else if (data.movieImagesState ==
                                              RequestState.error) {
                                            return const Center(
                                              child: Text('Failed to load the data'),
                                            );
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  ),
                );
              } else if (data.nowPlayingState == RequestState.error) {
                return const Center(child: Text('Failed to load the data'));
              } else {
                return ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black,
                        Colors.black,
                        Colors.transparent,
                      ],
                      stops: [0, 0.3, 0.5, 1],
                    ).createShader(
                      Rect.fromLTRB(0, 0, rect.width, rect.height),
                    );
                  },
                  blendMode: BlendMode.dstIn,
                  child: Shimmer.fromColors(
                    child: Container(
                      height: 300.0,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                    ),
                    baseColor: Colors.grey[850]!,
                    highlightColor: Colors.grey[800]!,
                  ),
                );
              }
            }),
            SubHeading(
              valueKey: 'seeNowPlayingMovies',
              text: 'Now Playing',
              onSeeMoreTapped: () => Navigator.pushNamed(
                context,
                TopRatedMoviesPage.routeName,
              ),
            ),
            Consumer<MovieListNotifier>(builder: (context, data, child) {
              if (data.nowPlayingState == RequestState.loaded) {
                return FadeIn(
                  duration: const Duration(milliseconds: 500),
                  child: HorizontalItemList(
                    movies: data.nowPlayingMovies,
                  ),
                );
              } else if (data.nowPlayingState == RequestState.error) {
                return const Center(child: Text('Failed to load the data'));
              } else {
                return SizedBox(
                  height: 170.0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Shimmer.fromColors(
                          child: Container(
                            height: 170.0,
                            width: 120.0,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          baseColor: Colors.grey[850]!,
                          highlightColor: Colors.grey[800]!,
                        ),
                      );
                    },
                  ),
                );
              }
            }),
            SubHeading(
              valueKey: 'seeUpcomingMovies',
              text: 'Coming Soon',
              onSeeMoreTapped: () => Navigator.pushNamed(
                context,
                UpcomingMoviesPage.routeName,
              ),
            ),
            Consumer<MovieListNotifier>(builder: (context, data, child) {
              if (data.upcomingMoviesState == RequestState.loaded) {
                return FadeIn(
                  duration: const Duration(milliseconds: 500),
                  child: HorizontalItemList(
                    movies: data.upcomingMovies,
                  ),
                );
              } else if (data.upcomingMoviesState == RequestState.error) {
                return const Center(child: Text('Failed to load the data'));
              } else {
                return SizedBox(
                  height: 170.0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Shimmer.fromColors(
                          child: Container(
                            height: 170.0,
                            width: 120.0,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          baseColor: Colors.grey[850]!,
                          highlightColor: Colors.grey[800]!,
                        ),
                      );
                    },
                  ),
                );
              }
            }),
            SubHeading(
              valueKey: 'seePopularMovies',
              text: 'Popular',
              onSeeMoreTapped: () => Navigator.pushNamed(
                context,
                PopularMoviesPage.routeName,
              ),
            ),
            Consumer<MovieListNotifier>(builder: (context, data, _) {
              if (data.popularMoviesState == RequestState.loaded) {
                return FadeIn(
                  duration: const Duration(milliseconds: 500),
                  child: HorizontalItemList(
                    movies: data.popularMovies,
                  ),
                );
              } else if (data.popularMoviesState == RequestState.error) {
                return const Center(child: Text('Failed to load the data'));
              } else {
                return SizedBox(
                  height: 170.0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Shimmer.fromColors(
                          child: Container(
                            height: 170.0,
                            width: 120.0,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          baseColor: Colors.grey[850]!,
                          highlightColor: Colors.grey[800]!,
                        ),
                      );
                    },
                  ),
                );
              }
            }),
            SubHeading(
              valueKey: 'seeTopRatedMovies',
              text: 'Top Rated',
              onSeeMoreTapped: () => Navigator.pushNamed(
                context,
                TopRatedMoviesPage.routeName,
              ),
            ),
            Consumer<MovieListNotifier>(builder: (context, data, child) {
              if (data.topRatedMoviesState == RequestState.loaded) {
                return FadeIn(
                  duration: const Duration(milliseconds: 500),
                  child: HorizontalItemList(
                    movies: data.topRatedMovies,
                  ),
                );
              } else if (data.topRatedMoviesState == RequestState.error) {
                return const Center(child: Text('Failed to load the data'));
              } else {
                return SizedBox(
                  height: 170.0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Shimmer.fromColors(
                          child: Container(
                            height: 170.0,
                            width: 120.0,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          baseColor: Colors.grey[850]!,
                          highlightColor: Colors.grey[800]!,
                        ),
                      );
                    },
                  ),
                );
              }
            }),
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}
