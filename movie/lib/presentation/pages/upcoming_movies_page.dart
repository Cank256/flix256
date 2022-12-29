import 'package:animate_do/animate_do.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/upcoming_movies_notifier.dart';
import '../widgets/item_card_list.dart';

class UpcomingMoviesPage extends StatefulWidget {
  static const routeName = '/upcoming-movies';

  const UpcomingMoviesPage({Key? key}) : super(key: key);

  @override
  _UpcomingMoviesPageState createState() => _UpcomingMoviesPageState();
}

class _UpcomingMoviesPageState extends State<UpcomingMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<UpcomingMoviesNotifier>(context, listen: false)
            .fetchUpcomingMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Coming Soon'),
        backgroundColor: Colors.black.withOpacity(0.6),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<UpcomingMoviesNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.loaded) {
              return FadeInUp(
                from: 20,
                duration: const Duration(milliseconds: 500),
                child: ListView.builder(
                  key: const Key('upcomingMoviesListView'),
                  itemBuilder: (context, index) {
                    final movie = data.movies[index];
                    return ItemCard(
                      movie: movie,
                    );
                  },
                  itemCount: data.movies.length,
                ),
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
