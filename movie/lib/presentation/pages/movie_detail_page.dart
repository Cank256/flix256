import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/utils/state_enum.dart';
import 'package:core/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../domain/entities/genre.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/entities/video_results.dart';
import '../provider/movie_detail_notifier.dart';
import '../widgets/minimal_detail.dart';
import '../widgets/trailer_view.dart';

bool _trailerIsShowing = false;

class MovieDetailPage extends StatefulWidget {
  static const routeName = '/movie-detail';

  final int id;
  const MovieDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MovieDetailNotifier>(context, listen: false)
          .fetchMovieDetail(widget.id);
      Provider.of<MovieDetailNotifier>(context, listen: false)
          .loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MovieDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.movieState == RequestState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.movieState == RequestState.loaded) {
            final movie = provider.movie;

            return MovieDetailContent(
              movie: movie,
              recommendations: provider.recommendations,
              isAddedToWatchlist: provider.isAddedToWatchlist,
            );

          } else {
            return Text(provider.message);
          }
        },
      ),
    );
  }

}

class MovieDetailContent extends StatefulWidget {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedToWatchlist;

  const MovieDetailContent({
    Key? key,
    required this.movie,
    required this.recommendations,
    required this.isAddedToWatchlist,
  }) : super(key: key);

  @override
  State<MovieDetailContent> createState() => _MovieDetailContentState();
}

class _MovieDetailContentState extends State<MovieDetailContent> {

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: const Key('movieDetailScrollView'),
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 250.0,
          flexibleSpace: FlexibleSpaceBar(
            background: FadeIn(
              duration: const Duration(milliseconds: 500),
              child: ShaderMask(
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
                    stops: [0.0, 0.5, 1.0, 1.0],
                  ).createShader(
                    Rect.fromLTRB(0.0, 0.0, rect.width, rect.height),
                  );
                },
                blendMode: BlendMode.dstIn,
                child: CachedNetworkImage(
                  width: MediaQuery.of(context).size.width,
                  imageUrl: Urls.imageUrl(widget.movie.backdropPath!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: FadeInUp(
            from: 20,
            duration: const Duration(milliseconds: 500),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie.title,
                    style: kHeading5.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2.0,
                          horizontal: 12.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          widget.movie.releaseDate.split('-')[1] + '-' + widget.movie.releaseDate.split('-')[0],
                          // movie.releaseDate,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20.0,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            (widget.movie.voteAverage / 2).toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                        ],
                      ),
                      const SizedBox(width: 5.0),
                      Text(
                        _showDuration(widget.movie.runtime),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      ElevatedButton(
                        // key: const Key('movieToWatchlist'),
                        onPressed: () {
                          setState((){
                            _trailerIsShowing = !_trailerIsShowing;
                          });
                          
                          // showModalBottomSheet(
                          //     shape: const RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.only(
                          //         topLeft: Radius.circular(10.0),
                          //         topRight: Radius.circular(10.0),
                          //       ),
                          //     ),
                          //     context: context,
                          //     builder: (context) {
                          //       return TrailerView(
                          //         keyValue: 'goToMovieDetail',
                          //         closeKeyValue: 'closeMovieMinimalDetail',
                          //         videoUrl: _movieTrailer('code', movie.videos)
                          //       );
                          //     },
                          //   );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.play_circle, color: Colors.black, size: 15.0,),
                            SizedBox(width: 2.0),
                            Text(
                              'Trailer',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800
                              ),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          primary:Colors.white,
                          minimumSize: const Size(50.0, 35.0,),
                          maximumSize: const Size(100.0, 35.0),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16.0),
                  
                  Visibility(
                    visible: _trailerIsShowing,
                    child: YoutubePlayerBuilder(
                      onExitFullScreen: () {
                        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
                        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
                      },
                      player: YoutubePlayer(
                        controller: YoutubePlayerController(
                          initialVideoId: _trailerId(widget.movie.videos), //Add videoID.
                          // initialVideoId: 'TbM-zWIkj_o',
                          flags: const YoutubePlayerFlags(
                            hideControls: false,
                            controlsVisibleAtStart: true,
                            autoPlay: true,
                            mute: false,
                            disableDragSeek: false,
                          ),
                        ),
                        showVideoProgressIndicator: true,
                        progressColors: const ProgressBarColors(
                          playedColor: Colors.red,
                          handleColor: Colors.redAccent,
                        ),
                      ), 
                      builder: (context , player ) { 
                        return Column(
                          children: [
                            player
                          ],
                        );
                       },
                    )
                  ),

                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    key: const Key('movieToWatchlist'),
                    onPressed: () async {
                      if (!widget.isAddedToWatchlist) {
                        await Provider.of<MovieDetailNotifier>(context,
                                listen: false)
                            .addToWatchlist(widget.movie);
                      } else {
                        await Provider.of<MovieDetailNotifier>(context,
                                listen: false)
                            .removeFromWatchlist(widget.movie);
                      }

                      final message = Provider.of<MovieDetailNotifier>(context,
                              listen: false)
                          .watchlistMessage;

                      if (message ==
                              MovieDetailNotifier.watchlistAddSuccessMessage ||
                          message ==
                              MovieDetailNotifier
                                  .watchlistRemoveSuccessMessage) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(message)));
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(message),
                            );
                          },
                        );
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.isAddedToWatchlist
                            ? const Icon(Icons.check, color: Colors.white)
                            : const Icon(Icons.add, color: Colors.black),
                        const SizedBox(width: 16.0),
                        Text(
                          widget.isAddedToWatchlist
                              ? 'Added to watchlist'
                              : 'Add to watchlist',
                          style: TextStyle(
                            color: widget.isAddedToWatchlist
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary:
                          widget.isAddedToWatchlist ? Colors.grey[850] : Colors.white,
                      minimumSize: Size(
                        MediaQuery.of(context).size.width,
                        42.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    widget.movie.overview,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Genres: ${_showGenres(widget.movie.genres)}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
          sliver: SliverToBoxAdapter(
            child: FadeInUp(
              from: 20,
              duration: const Duration(milliseconds: 500),
              child: Text(
                'More like this'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ),
        // Tab(text: 'More like this'.toUpperCase()),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
          sliver: _showRecommendations(),
        ),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  //Get Trailer Video Youtube ID
  String _trailerId(videos) {
    // ignore: prefer_typing_uninitialized_variables
    var finalResult;
    for(var i = 0; i < videos.results.length; i++){
      if(videos.results[i].type == 'Trailer'){
        finalResult = videos.results[i];
      }
    }
    
    return finalResult.key.toString();
    
  }

  //Takes in movie.videos
  String _movieTrailer(String type, videos) {
    // ignore: prefer_typing_uninitialized_variables
    var finalResult;
    for(var i = 0; i < videos.results.length; i++){
      if(videos.results[i].type == 'Trailer'){
        finalResult = videos.results[i];
      }
    }
    if(type == 'url'){
      return 'https://www.youtube.com/watch?v=' + finalResult.key.toString();
    }
    else{
      return finalResult.key.toString();
    }
    
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  Widget _showRecommendations() {
    return Consumer<MovieDetailNotifier>(
      builder: (context, data, child) {
        if (data.recommendationsState == RequestState.loaded) {
          return SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final recommendation = data.recommendations[index];
                return FadeInUp(
                  from: 20,
                  duration: const Duration(milliseconds: 500),
                  child: GestureDetector(
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
                            movie: recommendation,
                          );
                        },
                      );
                    },
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      child: CachedNetworkImage(
                        imageUrl: Urls.imageUrl(recommendation.posterPath!),
                        placeholder: (context, url) => Shimmer.fromColors(
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
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        height: 180.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
              childCount: data.recommendations.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 0.7,
              crossAxisCount:
                  (MediaQuery.of(context).orientation == Orientation.portrait)
                      ? 3
                      : 4,
            ),
          );
        } else if (data.recommendationsState == RequestState.error) {
          return SliverToBoxAdapter(child: Center(child: Text(data.message)));
        } else {
          return const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
