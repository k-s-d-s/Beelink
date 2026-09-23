class TraceMilestone {
  final String title;
  final String description;
  final DateTime timestamp;
  final String actor;
  final bool isCompleted;

  const TraceMilestone({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.actor,
    this.isCompleted = true,
  });
}

class HoneyBatchModel {
  final String id;
  final String hiveId;
  final String hiveName;
  final String beekeeperName;
  final String apiaryLocation;
  final String floralSource;
  final DateTime harvestDate;
  final double netWeightKg;
  final double moisturePercent;
  final double purityScorePercent;
  final String pollenDna;
  final String flavorNotes;
  final String blockchainTxHash;
  final List<TraceMilestone> milestones;

  const HoneyBatchModel({
    required this.id,
    required this.hiveId,
    required this.hiveName,
    required this.beekeeperName,
    required this.apiaryLocation,
    required this.floralSource,
    required this.harvestDate,
    required this.netWeightKg,
    required this.moisturePercent,
    required this.purityScorePercent,
    required this.pollenDna,
    required this.flavorNotes,
    required this.blockchainTxHash,
    required this.milestones,
  });
}
