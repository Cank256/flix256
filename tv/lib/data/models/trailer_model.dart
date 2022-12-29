import 'package:equatable/equatable.dart';

import '../../domain/entities/video_results.dart';
import '../../domain/entities/videos.dart';

class TrailerModel extends Equatable {
  final List<Results> results;

  const TrailerModel({
    required this.results,
  });

  factory TrailerModel.fromJson(Map<List, dynamic> json) => TrailerModel(
        results: json['results'],
      );

  Map<List, dynamic> toJson() => {
        results: results,
      };

  Videos toEntity() => Videos(
        results: results,
      );

  @override
  List<Object?> get props => [results];
}
