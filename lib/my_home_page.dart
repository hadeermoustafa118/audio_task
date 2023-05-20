import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //variables needed to functions logic
  late AudioPlayer player;
  late AudioCache cache;
  bool isPlaying = false;
  Duration duration = Duration();
  Duration position = Duration();

  //play method

  playMusic() {
    player.play(AssetSource('doaa.mp3'));
  }
// pause method
  stopMusic() {
    player.pause();
  }

  //starting and updating duration and position during playing
  setUp() {
    player.onDurationChanged.listen((currentDuration) {
      setState(() {
        duration = currentDuration;
      });
      player.onPositionChanged.listen((currentPosition) {
        setState(() {
          position = currentPosition;
        });
      });
    });
  }
// jumping forward or backward
  seekTo(int seconds) {
    player.seek(Duration(seconds: seconds));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cache = AudioCache();
    player = AudioPlayer();
    cache.load('doaa.mp3');
    setUp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            height: 400,
            width: double.infinity,
            child: const Center(
              child: Text(
                'Playing Now',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 34),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Slider(
            value: position.inSeconds.toDouble()< duration.inSeconds.toDouble()?  position.inSeconds.toDouble():0,
            onChanged: (value) {
              seekTo(value.toInt());
            },
            min: 0,
            max: duration.inSeconds.toDouble(),
          ),

          Padding(
            padding: const EdgeInsets.all(26),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      if (position.inSeconds == 0 || position.inSeconds < 10) {
                        seekTo(0);
                      } else if (position.inSeconds > 10) {
                        seekTo(position.inSeconds - 10);
                      }
                    },
                    icon: const Icon(
                      Icons.first_page,
                      size: 36,
                    )),
                IconButton(
                    onPressed: () {
                      if (isPlaying) {
                        setState(() {
                          isPlaying = false;
                        });
                        stopMusic();
                      } else {
                        setState(() {
                          isPlaying = true;
                        });
                        playMusic();
                      }
                    },
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 36,
                    )),
                IconButton(
                    onPressed: () {
                      if (position < duration - const Duration(seconds: 10)) {
                        seekTo(position.inSeconds + 10);
                      } else {
                        seekTo(duration.inSeconds);
                        setState(() {
                          isPlaying = false;
                        });
                        player.stop();
                      }
                    },
                    icon: const Icon(
                      Icons.last_page,
                      size: 36,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
