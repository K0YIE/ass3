import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class SensorDashboard extends StatefulWidget {
  const SensorDashboard({super.key});

  @override
  State<SensorDashboard> createState() => _SensorDashboardState();
}

class _SensorDashboardState extends State<SensorDashboard> {
  final DatabaseReference _sensorRef = FirebaseDatabase.instance.ref().child('Sensor');
  final DatabaseReference _actuatorRef = FirebaseDatabase.instance.ref().child('Actuator/pump');

  double temperature = 0;
  double humidity = 0;
  double moisture = 0;
  double light = 0;
  bool relayStatus = false;
  DateTime? lastUpdated;

  @override
  void initState() {
    super.initState();
    _setupFirebaseListeners();
  }

  void _setupFirebaseListeners() {
    _sensorRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      setState(() {
        temperature = (data['temperature'] ?? 0.0).toDouble();
        humidity = (data['humidity'] ?? 0.0).toDouble();
        moisture = (data['moisture'] ?? 0).toDouble();
        light = (data['light'] ?? 0).toDouble();
        lastUpdated = DateTime.now();
      });
    });

    _actuatorRef.onValue.listen((event) {
      setState(() {
        relayStatus = event.snapshot.value.toString().toUpperCase() == "ON" ||
            event.snapshot.value.toString() == "1";
      });
    });
  }

  void _toggleRelay() {
    _actuatorRef.set(!relayStatus ? "ON" : "OFF");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade900,
      appBar: AppBar(
        title: Text('Garden Monitor',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _sensorRef.get().then((snapshot) {
              final data = Map<String, dynamic>.from(snapshot.value as Map);
              setState(() {
                temperature = (data['temperature'] ?? 0.0).toDouble();
                humidity = (data['humidity'] ?? 0.0).toDouble();
                moisture = (data['moisture'] ?? 0).toDouble();
                light = (data['light'] ?? 0).toDouble();
                lastUpdated = DateTime.now();
              });
            }),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatusBar(),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildSensorCard(
                      icon: Icons.thermostat,
                      title: "Temperature",
                      value: temperature,
                      unit: "°C",
                      color: const Color(0xFFF44336),
                      minValue: 10,
                      maxValue: 40
                  ),
                  _buildSensorCard(
                      icon: Icons.water_drop,
                      title: "Humidity",
                      value: humidity,
                      unit: "%",
                      color: const Color(0xFF2196F3),
                      minValue: 0,
                      maxValue: 100
                  ),
                  _buildSensorCard(
                      icon: Icons.grass,
                      title: "Soil Moisture",
                      value: moisture,
                      unit: "%",
                      color: const Color(0xFF4CAF50),
                      minValue: 0,
                      maxValue: 100
                  ),
                  _buildSensorCard(
                      icon: Icons.light_mode,
                      title: "Light Level",
                      value: light,
                      unit: "%",
                      color: const Color(0xFFFFC107),
                      minValue: 0,
                      maxValue: 100
                  ),
                ],
              ),
            ),
            _buildControlPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text("Online", style: GoogleFonts.poppins(fontSize: 14)),
            ],
          ),
          Text(
            lastUpdated != null
                ? "Updated: ${DateFormat('HH:mm:ss').format(lastUpdated!)}"
                : "Waiting for data...",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorCard({
    required IconData icon,
    required String title,
    required double value,
    required String unit,
    required Color color,
    required double minValue,
    required double maxValue,
  }) {
    double percentage = ((value - minValue) / (maxValue - minValue)).clamp(0, 1);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                Text(
                  "$value$unit",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[200],
              color: color,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$minValue$unit",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "$maxValue$unit",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Water Pump Control",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: relayStatus ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: relayStatus ? Colors.green : Colors.red,
                    width: 1,
                  ),
                ),
                child: Text(
                  relayStatus ? "ACTIVE" : "INACTIVE",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: relayStatus ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _toggleRelay,
              style: ElevatedButton.styleFrom(
                backgroundColor: relayStatus ? Colors.red : Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                relayStatus ? "TURN OFF PUMP" : "TURN ON PUMP",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}