import 'package:flutter/material.dart';
import 'package:flutter_pie_chart/flutter_pie_chart.dart';


class TestPie extends StatefulWidget {
  @override
  _TestPie createState() => _TestPie();
}

class _TestPie extends State<TestPie> {
  final List<Pie> pies = [
    Pie(color: const Color(0xFFFF6262), proportion: 8),
    Pie(color: const Color(0xFFFF9494), proportion: 3),
    Pie(color: const Color(0xFFFFDCDC), proportion: 8),
  ];
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter pie chart'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: deviceSize.width * 0.5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlutterPieChart(
                  pies: pies,
                  selected:1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}