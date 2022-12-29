import 'package:equatable/equatable.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/entities/videos.dart';
import 'genre_model.dart';

class MovieDetailResponse extends Equatable {
  final String? backdropPath;
  final List<GenreModel> genres;
  final int id;
  final String overview;
  final String? posterPath;
  final String releaseDate;
  final int runtime;
  final String title;
  final double voteAverage;
  final int voteCount;
  final Videos? videos;

  const MovieDetailResponse({
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.runtime,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
    required this.videos,
  });

  factory MovieDetailResponse.fromJson(Map<String, dynamic> json) =>
      MovieDetailResponse(
        backdropPath: json['backdrop_path'],
        genres: List<GenreModel>.from(
            json['genres'].map((x) => GenreModel.fromJson(x))),
        id: json['id'],
        overview: json['overview'],
        posterPath: json['poster_path'],
        releaseDate: json['release_date'],
        runtime: json['runtime'],
        title: json['title'],
        voteAverage: json['vote_average'].toDouble(),
        voteCount: json['vote_count'],
        videos: json['videos'] != null ? Videos.fromJson(json['videos']) : null,
      );

  Map<String, dynamic> toJson() => {
        'backdrop_path': backdropPath,
        'genres': List<dynamic>.from(genres.map((x) => x.toJson())),
        'id': id,
        'overview': overview,
        'poster_path': posterPath,
        'release_date': releaseDate,
        'runtime': runtime,
        'title': title,
        'vote_average': voteAverage,
        'vote_count': voteCount,
        'videos': videos != null ? videos!.toJson() : null,
        
      };

  MovieDetail toEntity() => MovieDetail(
        backdropPath: backdropPath,
        genres: genres.map((genre) => genre.toEntity()).toList(),
        id: id,
        overview: overview,
        posterPath: posterPath,
        releaseDate: releaseDate,
        runtime: runtime,
        title: title,
        voteAverage: voteAverage,
        voteCount: voteCount,
        videos: videos,
      );

  @override
  List<Object?> get props => [
        backdropPath,
        genres,
        id,
        overview,
        posterPath,
        releaseDate,
        runtime,
        title,
        voteAverage,
        voteCount,
        videos,
      ];
}
