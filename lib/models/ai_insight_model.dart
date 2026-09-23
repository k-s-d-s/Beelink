enum InsightSeverity { urgent, warning, optimal, info }

class AiInsightModel {
  final String id;
  final String hiveId;
  final String hiveName;
  final String title;
  final String category;
  final InsightSeverity severity;
  final String description;
  final String actionRecommendation;
  final int confidencePercent;
  final DateTime timestamp;

  const AiInsightModel({
    required this.id,
    required this.hiveId,
    required this.hiveName,
    required this.title,
    required this.category,
    required this.severity,
    required this.description,
    required this.actionRecommendation,
    required this.confidencePercent,
    required this.timestamp,
  });
}
