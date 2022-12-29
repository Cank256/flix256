import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerView extends StatelessWidget {
  final String videoUrl;


  const TrailerView({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context)  => YoutubePlayerBuilder(
    player: YoutubePlayer(
      controller: YoutubePlayerController(
          initialVideoId: videoUrl, //Add videoID.
      ),
    ), 
    builder: (context, player) => Scaffold(
      body: Column(
        children: [
          player
        ]
      ),
    )
  );
}


