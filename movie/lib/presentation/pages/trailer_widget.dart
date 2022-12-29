import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerWidget extends StatefulWidget {
  const TrailerWidget({Key? key, required String videoId}) : super(key: key);

  @override
  _TrailerWidgetState createState() => _TrailerWidgetState();
}

class _TrailerWidgetState extends State<TrailerWidget> {
  late YoutubePlayerController controller;
  late String videoId = '';

  @override
  void initState(){
    super.initState();

    controller = YoutubePlayerController(
      initialVideoId: 'GQyWIur03aw'
      // initialVideoId: videoId
    );
  }

  @override
  Widget build(BuildContext context)  => YoutubePlayerBuilder(
    player: YoutubePlayer(
      controller: controller,
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