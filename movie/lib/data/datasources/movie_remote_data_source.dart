import 'dart:convert';

import 'package:core/utils/exception.dart';
import 'package:core/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/media_image_model.dart';
import '../models/movie_detail_response.dart';
import '../models/movie_model.dart';
import '../models/movie_response.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getUpcomingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<MovieDetailResponse> getMovieDetail(int id);
  Future<List<MovieModel>> getMovieRecommendations(int id);
  Future<List<MovieModel>> searchMovies(String query);
  Future<MediaImageModel> getMovieImages(int id);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final http.Client client;

  MovieRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    final response = await client.get(Uri.parse(Urls.nowPlayingMovies));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getUpcomingMovies() async {
    DateTime today = DateTime.now();
    String todayFormatted = DateFormat('yyyy-MM-dd').format(today);
    DateTime sixMonthsFromNow = today.add(const Duration(hours: 4380));
    String sixMonthsFromNowFormatted = DateFormat('yyyy-MM-dd').format(sixMonthsFromNow);
    var url = Urls.baseUrl+'/discover/movie?'+Urls.apiKey+'&primary_release_date.gte=$todayFormatted&primary_release_date.lte=$sixMonthsFromNowFormatted';

    // final response = await client.get(Uri.parse(Urls.upcomingMovies));
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final response = await client.get(Uri.parse(Urls.popularMovies));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    final response = await client.get(Uri.parse(Urls.topRatedMovies));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }
  
  @override
  Future<MovieDetailResponse> getMovieDetail(int id) async {
    final response = await client.get(Uri.parse(Urls.movieDetail(id)));

    if (response.statusCode == 200) {
      return MovieDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getMovieRecommendations(int id) async {
    final response = await client.get(Uri.parse(Urls.movieRecommendations(id)));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await client.get(Uri.parse(Urls.searchMovies(query)));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<MediaImageModel> getMovieImages(int id) async {
    final response = await client.get(Uri.parse(Urls.movieImages(id)));

    if (response.statusCode == 200) {
      return MediaImageModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}

class Post {

  String key;
  String site;
  String type;


  Post({required this.key, required this.site, required this.type});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        key: json['key'].toString(),
        site: json['site'].toString(),
        type: json['type'].toString()
    );
  }
}
