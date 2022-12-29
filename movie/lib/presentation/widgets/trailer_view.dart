import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerView extends StatelessWidget {
  final String? keyValue;
  final String? closeKeyValue;
  final String videoUrl;


  const TrailerView({
    Key? key,
    this.keyValue,
    this.closeKeyValue,
    required this.videoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:350.0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              key: Key(keyValue ?? '-'),
              onPressed: () => Navigator.pop(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.tv, size: 20.0),
                      SizedBox(width: 15.0),
                      Text(
                        'Trailer',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.close_sharp, size: 16.0),
                ],
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: YoutubePlayerBuilder(
              onExitFullScreen: () {
                // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
                SystemChrome.setPreferredOrientations(DeviceOrientation.values);
              },
              player: YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: videoUrl, //Add videoID.
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
        ],
      ),
    );
  }
}


