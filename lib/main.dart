
import 'package:audio_mix/pagetwo.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusicApp(),
    );
  }
}

class MusicApp extends StatefulWidget {
  @override
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  final audioPlayer= AudioPlayer();
  bool isPlaying = false;
  Duration duration = const Duration();
  Duration position = const Duration();

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying= state == PlayerState.playing;
      });
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration= newDuration;
      });
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position= newPosition;
      });
    });
  }

  List songList= [
    "audio/tone1.mp3",
    "audio/tone2.mp3",
    "assets/audio/tone3.mp3",
    "assets/audio/tone4.mp3",
  ];
  List musicList= [
    "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
    "https://goo.gl/5RQjTQ",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /*ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                "https://i.pinimg.com/originals/55/27/89/552789ccf1e4e919e17930976a5e62c9.jpg",
                height: 350,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),*/

            Container(
              alignment: Alignment.center,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      InkWell(
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(150),
                            ),
                            color: Colors.green.withOpacity(.2),
                          ),
                        ),
                        onTap: () async {
                          if(isPlaying){
                            await audioPlayer.pause();
                          } else {
                            await audioPlayer.play(UrlSource(musicList[0]));
                          }
                        },
                      ),

                      InkWell(
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(150),
                            ),
                            color: Colors.red.withOpacity(.2),
                          ),
                        ),
                        onTap: () async {
                          if(isPlaying){
                            await audioPlayer.pause();
                          } else {
                            await audioPlayer.play(UrlSource(musicList[1]));
                          }
                        },
                      ),

                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      InkWell(
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(150),
                            ),
                            color: Colors.red.withOpacity(.2),
                          ),
                        ),
                        onTap: () async {

                        },
                      ),

                      InkWell(
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(150),
                            ),
                            color: Colors.green.withOpacity(.2),
                          ),
                        ),
                        onTap: () async {

                        },
                      ),


                    ],
                  ),

                ],
              ),

            ),

            const SizedBox(height: 10,),
            const Text(
              "Flutter Music player",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) async{
                final position= Duration(seconds: value.toInt());
                await audioPlayer.seek(position);
                //await audioPlayer.resume();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(timerAttach(position)),
                  Text(timerAttach(duration - position)),
                ],
              ),
            ),
            CircleAvatar(
              radius: 35,
              child: IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                iconSize: 50,
                onPressed: () async {
                  if(isPlaying){
                    await audioPlayer.pause();
                  } else {
                    //String url= songList[1].toString();
                    //await audioPlayer.setSourceAsset(url);
                    await audioPlayer.play(UrlSource(musicList[1]));
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => PageTwo()));
              },
              child: const Text("Next",),
            ),

          ],
        ),
      ),
    );
  }

  String timerAttach(Duration duration){
    String towDigit(int d) => d.toString().padLeft(2, "0");
    final hour= towDigit(duration.inHours);
    final minute= towDigit(duration.inMinutes.remainder(60));
    final second= towDigit(duration.inSeconds.remainder(60));
    return [
      if(duration.inHours > 0) hour,
      minute, second,
    ].join(':');
  }

}