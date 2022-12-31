import 'package:intl/intl.dart';

class Urls {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = 'api_key=ff6cc53a2ac35d044a5a0b095748a152';
  
  /// Movies
  static const String nowPlayingMovies = '$baseUrl/movie/now_playing?$apiKey&lang=en';
  //Upcoming Movies with Region set to USA
  static const String upcomingMovies = '$baseUrl/movie/upcoming?$apiKey&lang=en&region=US';
  static const String popularMovies = '$baseUrl/movie/popular?$apiKey&lang=en';
  static const String topRatedMovies = '$baseUrl/movie/top_rated?$apiKey&lang=en';
  static String movieDetail(int id) => '$baseUrl/movie/$id?$apiKey&append_to_response=videos';
  static String movieRecommendations(int id) =>
      '$baseUrl/movie/$id/recommendations?$apiKey';
  static String searchMovies(String query) =>
      '$baseUrl/search/movie?$apiKey&query=$query';

  /// Tvs
  static const String onTheAirTvs = '$baseUrl/tv/on_the_air?$apiKey&lang=en';
  static const String onShowingTodayTvs = '$baseUrl/tv/airing_today?$apiKey&lang=en';
  static String upcomingTvs = '$baseUrl/discover/tv?$apiKey&primary_release_date.gte='+DateFormat('yyyy-MM-dd').format(DateTime.now())+'&primary_release_date.lte='+DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(hours: 4380)));
  static const String popularTvs = '$baseUrl/tv/popular?$apiKey&lang=en';
  static const String topRatedTvs = '$baseUrl/tv/top_rated?$apiKey&lang=en';
  static String tvDetail(int id) => '$baseUrl/tv/$id?$apiKey&append_to_response=videos';
  static String tvSeasons(int id, int seasonNumber) =>
      '$baseUrl/tv/$id/season/$seasonNumber?$apiKey';
  static String tvRecommendations(int id) =>
      '$baseUrl/tv/$id/recommendations?$apiKey';
  static String searchTvs(String query) =>
      '$baseUrl/search/tv?$apiKey&query=$query';

  /// Image
  static const String baseImageUrl = 'https://image.tmdb.org/t/p/original';
  static String imageUrl(String path) => '$baseImageUrl$path';
  static String movieImages(int id) =>
      '$baseUrl/movie/$id/images?$apiKey&language=en-US&include_image_language=en,null';
  static String tvImages(int id) =>
      '$baseUrl/tv/$id/images?$apiKey&language=en-US&include_image_language=en,null';
}

