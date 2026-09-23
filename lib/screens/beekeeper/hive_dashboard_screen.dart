import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../mock_data/beelink_repository.dart';
import '../../models/hive_model.dart';
import 'harvest_logger_screen.dart';

class HiveDashboardScreen extends StatefulWidget {
  const HiveDashboardScreen({super.key});

  @override
  State<HiveDashboardScreen> createState() => _HiveDashboardScreenState();
}

class _HiveDashboardScreenState extends State<HiveDashboardScreen> {
  String _selectedHiveId = 'HIVE-01';
  int _selectedChartMetric = 0; // 0: Weight, 1: Temperature, 2: Humidity

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'healthy':
        return Colors.green;
      case 'attention':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = BeeLinkRepository();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive IoT Telemetry'),
      ),
      body: ListenableBuilder(
        listenable: repo,
        builder: (context, _) {
          final hives = repo.hives;
          final currentHive = repo.getHiveById(_selectedHiveId) ?? hives.first;

          // Calculate overview aggregates
          final double avgWeight = hives.fold(0.0, (acc, h) => acc + h.weightKg) / hives.length;
          final double avgTemp = hives.fold(0.0, (acc, h) => acc + h.temperatureC) / hives.length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Apiary Overview Metrics
                Row(
                  children: [
                    _buildTopCard(
                      title: 'Active Hives',
                      value: '${hives.length}',
                      subtitle: 'All online',
                      icon: Icons.grid_view_rounded,
                      color: Colors.amber.shade800,
                    ),
                    const SizedBox(width: 8),
                    _buildTopCard(
                      title: 'Avg Weight',
                      value: '${avgWeight.toStringAsFixed(1)} kg',
                      subtitle: '+1.4kg this week',
                      icon: Icons.scale,
                      color: Colors.orange.shade700,
                    ),
                    const SizedBox(width: 8),
                    _buildTopCard(
                      title: 'Brood Temp',
                      value: '${avgTemp.toStringAsFixed(1)}°C',
                      subtitle: 'Ideal: 34-35°C',
                      icon: Icons.thermostat,
                      color: Colors.red.shade600,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 2. Select Hive Selector
                const Text(
                  'Select Apiary Hive',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: hives.map((hive) {
                      final isSelected = hive.id == currentHive.id;
                      final statusColor = _getStatusColor(hive.status);

                      return GestureDetector(
                        onTap: () => setState(() => _selectedHiveId = hive.id),
                        child: Container(
                          width: 170,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.amber.shade50 : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? Colors.amber.shade700 : Colors.grey.withValues(alpha: 0.25),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? Colors.amber.withValues(alpha: 0.2)
                                    : Colors.black.withValues(alpha: 0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    hive.id,
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.amber.shade900 : Colors.grey.shade600,
                                      fontSize: 11,
                                    ),
                                  ),
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: statusColor),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                hive.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${hive.weightKg} kg', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                  Text('${hive.temperatureC}°C', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // 3. Selected Hive Detail Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.amber.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(currentHive.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(currentHive.location, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(currentHive.status).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              currentHive.status.toUpperCase(),
                              style: TextStyle(
                                color: _getStatusColor(currentHive.status),
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildHiveSubStat('Weight', '${currentHive.weightKg} kg', Icons.scale),
                          _buildHiveSubStat('Temperature', '${currentHive.temperatureC}°C', Icons.thermostat),
                          _buildHiveSubStat('Humidity', '${currentHive.humidityPercent}%', Icons.water_drop),
                          _buildHiveSubStat('Queen Age', '${currentHive.queenAgeMonths} mo', Icons.cruelty_free),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 4. Telemetry Graph Header & Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('24h Telemetry Trend', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SegmentedButton<int>(
                      segments: const [
                        ButtonSegment(value: 0, label: Text('Weight', style: TextStyle(fontSize: 11))),
                        ButtonSegment(value: 1, label: Text('Temp', style: TextStyle(fontSize: 11))),
                        ButtonSegment(value: 2, label: Text('Humidity', style: TextStyle(fontSize: 11))),
                      ],
                      selected: {_selectedChartMetric},
                      onSelectionChanged: (set) => setState(() => _selectedChartMetric = set.first),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 5. Line Chart Card
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 20, 14),
                    child: SizedBox(
                      height: 220,
                      child: LineChart(_buildChartData(currentHive)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 6. Quick Action: Log Harvest for this hive
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade800,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.add_box),
                    label: Text('Log Honey Harvest from ${currentHive.name}'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HarvestLoggerScreen(initialHiveId: currentHive.id),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 2),
            Text(title, style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
            Text(subtitle, style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }

  Widget _buildHiveSubStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.amber.shade800),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
      ],
    );
  }

  LineChartData _buildChartData(HiveModel hive) {
    List<FlSpot> spots = [];
    Color lineColor;
    Color gradientColor;
    double minY;
    double maxY;

    if (_selectedChartMetric == 0) {
      // Weight
      spots = hive.weightHistory.map((p) => FlSpot(p.hour, p.value)).toList();
      lineColor = Colors.orange.shade700;
      gradientColor = Colors.amber.shade200;
      minY = 38;
      maxY = 55;
    } else if (_selectedChartMetric == 1) {
      // Temp
      spots = hive.tempHistory.map((p) => FlSpot(p.hour, p.value)).toList();
      lineColor = Colors.red.shade600;
      gradientColor = Colors.red.shade100;
      minY = 32;
      maxY = 38;
    } else {
      // Humidity
      spots = hive.humidityHistory.map((p) => FlSpot(p.hour, p.value)).toList();
      lineColor = Colors.blue.shade600;
      gradientColor = Colors.blue.shade100;
      minY = 45;
      maxY = 70;
    }

    if (spots.isEmpty) {
      spots = const [FlSpot(0, 45), FlSpot(12, 46), FlSpot(24, 46.2)];
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.grey.withValues(alpha: 0.15),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: 4,
            getTitlesWidget: (val, meta) => Text('${val.toInt()}h', style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            getTitlesWidget: (val, meta) => Text('${val.toInt()}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: lineColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: gradientColor.withValues(alpha: 0.35),
          ),
        ),
      ],
    );
  }
}
