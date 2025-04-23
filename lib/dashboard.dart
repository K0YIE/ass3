import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CyberPlant Dashboard',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.teal.shade900,
      ),
      home: const DashboardPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _sensorRef   = FirebaseDatabase.instance.ref('Sensor');
  final _actuatorRef = FirebaseDatabase.instance.ref('Actuator/pump');

  List<FlSpot> tempSpots     = [];
  List<FlSpot> humiditySpots = [];
  List<FlSpot> soilSpots     = [];
  List<FlSpot> lightSpots    = [];
  String relayStatus = "OFF";
  int counter        = 0;

  final Color darkBg      = const Color(0xFF121212);
  final Color tealAccent  = Colors.tealAccent;
  final Color tealShade   = Colors.teal.shade700;

  @override
  void initState() {
    super.initState();
    _sensorRef.onValue.listen((e) {
      final data = Map<String, dynamic>.from(e.snapshot.value as Map);
      setState(() {
        counter++;
        tempSpots.add(    FlSpot(counter.toDouble(), (data['temperature']   ?? 0).toDouble()));
        humiditySpots.add(FlSpot(counter.toDouble(), (data['humidity']      ?? 0).toDouble()));
        soilSpots.add(    FlSpot(counter.toDouble(), (data['moisture']      ?? 0).toDouble()));
        lightSpots.add(   FlSpot(counter.toDouble(), (data['light']         ?? 0).toDouble()));
      });
    });
    _actuatorRef.onValue.listen((e) {
      final val = e.snapshot.value.toString().toUpperCase();
      setState(() => relayStatus = (val == "ON" || val == "1") ? "ON" : "OFF");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade900,
      appBar: AppBar(
        title: Text('CYBERPLANT MONITOR',
            style: GoogleFonts.orbitron(color: tealAccent, letterSpacing: 2)),
        centerTitle: true,
        backgroundColor: Colors.teal.shade900,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: tealAccent),
            onPressed: () => setState(() {
              tempSpots.clear();
              humiditySpots.clear();
              soilSpots.clear();
              lightSpots.clear();
              counter = 0;
            }),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildChartCard(
            title: "TEMPERATURE (°C)",
            spots: tempSpots,
            lineColor: Colors.orangeAccent,
          ),
          const SizedBox(height: 16),
          _buildChartCard(
            title: "HUMIDITY (%)",
            spots: humiditySpots,
            lineColor: Colors.lightBlueAccent,
          ),
          const SizedBox(height: 16),
          _buildChartCard(
            title: "SOIL MOISTURE",
            spots: soilSpots,
            lineColor: Colors.greenAccent,
          ),
          const SizedBox(height: 16),
          _buildChartCard(
            title: "LIGHT LEVEL",
            spots: lightSpots,
            lineColor: Colors.amberAccent,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required List<FlSpot> spots,
    required Color lineColor,
  }) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: darkBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tealShade.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: lineColor.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.orbitron(
                    color: tealAccent, fontSize: 14, letterSpacing: 1.2)),
            const SizedBox(height: 4),
            Expanded(
              child: LineChart(LineChartData(
                minX: 0,
                maxX: counter.toDouble() < 1 ? 1 : counter.toDouble(),
                titlesData: FlTitlesData(show: false),
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: darkBg.withOpacity(0.5), strokeWidth: 0.5),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: lineColor,
                    barWidth: 2,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [lineColor.withOpacity(0.3), Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    dotData: FlDotData(show: false),
                  )
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
