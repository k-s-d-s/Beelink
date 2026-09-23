class TelemetryPoint {
  final double hour; // 0 to 24
  final double value;

  const TelemetryPoint(this.hour, this.value);
}

class HiveModel {
  final String id;
  final String name;
  final String location;
  final double weightKg;
  final double temperatureC;
  final double humidityPercent;
  final String status; // 'Healthy', 'Attention', 'Inspecting'
  final int queenAgeMonths;
  final List<TelemetryPoint> weightHistory;
  final List<TelemetryPoint> tempHistory;
  final List<TelemetryPoint> humidityHistory;

  const HiveModel({
    required this.id,
    required this.name,
    required this.location,
    required this.weightKg,
    required this.temperatureC,
    required this.humidityPercent,
    required this.status,
    required this.queenAgeMonths,
    this.weightHistory = const [],
    this.tempHistory = const [],
    this.humidityHistory = const [],
  });
}