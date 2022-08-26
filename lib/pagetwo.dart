import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PageTwo extends StatefulWidget {
  @override
  _PageTwo createState() => _PageTwo();
}

class _PageTwo extends State<PageTwo> {

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


  List? musicList= [
    "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
    "https://goo.gl/5RQjTQ",
    "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
    "https://goo.gl/5RQjTQ",
  ];

  final List<ChartData> chartData = [
    ChartData('David', 5, Colors.grey),
    ChartData('Steve', 5, Colors.red),
    ChartData('Jack', 5, Colors.green),
    ChartData('Others', 5, Colors.blue)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              children: [

                Container(
                    child: SfCircularChart(
                        series: <CircularSeries>[
                          // Render pie chart
                          PieSeries<ChartData, String>(
                              dataSource: chartData,
                              pointColorMapper:(ChartData data, _) => data.color,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              selectionBehavior: SelectionBehavior(
                                selectedBorderColor: Colors.black,
                              ),
                              enableTooltip: true,
                              legendIconType: LegendIconType.rectangle,
                              onPointTap: (value) async {
                                log("__ ${value.viewportPointIndex} and ${value.seriesIndex}");
                                  if(isPlaying){
                                    await audioPlayer.pause();
                                  } else {
                                    await audioPlayer.play(UrlSource(musicList![value.pointIndex!]));
                                  }

                              }
                          )
                        ]
                    )
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
                      /*if(isPlaying){
                        await audioPlayer.pause();
                      } else {
                        //String url= songList[1].toString();
                        //await audioPlayer.setSourceAsset(url);
                        await audioPlayer.play(UrlSource(musicList[1]));
                      }*/
                    },
                  ),
                ),


              ],
            ),

        )
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

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}