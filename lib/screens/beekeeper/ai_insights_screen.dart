import 'package:flutter/material.dart';
import '../../mock_data/beelink_repository.dart';
import '../../models/ai_insight_model.dart';

class AiInsightsScreen extends StatefulWidget {
  const AiInsightsScreen({super.key});

  @override
  State<AiInsightsScreen> createState() => _AiInsightsScreenState();
}

class _AiInsightsScreenState extends State<AiInsightsScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Urgent', 'Warnings', 'Optimal'];

  Color _getSeverityColor(InsightSeverity severity) {
    switch (severity) {
      case InsightSeverity.urgent:
        return Colors.red.shade700;
      case InsightSeverity.warning:
        return Colors.orange.shade800;
      case InsightSeverity.optimal:
        return Colors.green.shade700;
      case InsightSeverity.info:
        return Colors.blue.shade700;
    }
  }

  IconData _getSeverityIcon(InsightSeverity severity) {
    switch (severity) {
      case InsightSeverity.urgent:
        return Icons.warning_rounded;
      case InsightSeverity.warning:
        return Icons.priority_high_rounded;
      case InsightSeverity.optimal:
        return Icons.stars_rounded;
      case InsightSeverity.info:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = BeeLinkRepository();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Colony Health & Insights'),
      ),
      body: ListenableBuilder(
        listenable: repo,
        builder: (context, _) {
          final allInsights = repo.insights;
          final filtered = allInsights.where((ins) {
            if (_selectedFilter == 'Urgent') return ins.severity == InsightSeverity.urgent;
            if (_selectedFilter == 'Warnings') return ins.severity == InsightSeverity.warning;
            if (_selectedFilter == 'Optimal') return ins.severity == InsightSeverity.optimal;
            return true;
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AI Banner
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo.shade900, Colors.purple.shade900],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.auto_awesome, color: Colors.amber, size: 14),
                                SizedBox(width: 6),
                                Text(
                                  'ACOUSTIC & TELEMETRY AI',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          const Text('Live Analysis Active', style: TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Predictive Apiary Diagnostics',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Neural model monitors hive audio spectrum, temperature micro-fluctuations, and weight curves to detect swarms, brood diseases, and nectar flows.',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12, height: 1.3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          selected: isSelected,
                          label: Text(filter),
                          selectedColor: Colors.amber.shade200,
                          onSelected: (_) => setState(() => _selectedFilter = filter),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // Insight cards
                if (filtered.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    alignment: Alignment.center,
                    child: const Text('No insights match this filter.', style: TextStyle(color: Colors.grey)),
                  )
                else
                  ...filtered.map((insight) {
                    final color = _getSeverityColor(insight.severity);
                    final icon = _getSeverityIcon(insight.severity);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: color.withValues(alpha: 0.4), width: 1.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: color.withValues(alpha: 0.15),
                                  child: Icon(icon, color: color, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        insight.title,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Text(
                                            '${insight.hiveName} • ',
                                            style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            insight.category,
                                            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.indigo.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${insight.confidencePercent}% conf.',
                                    style: TextStyle(color: Colors.indigo.shade900, fontWeight: FontWeight.bold, fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Description
                            Text(
                              insight.description,
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.85), fontSize: 13, height: 1.3),
                            ),
                            const SizedBox(height: 14),

                            // Recommendation Box
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: color.withValues(alpha: 0.2)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.lightbulb, color: color, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Recommended Action:',
                                          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          insight.actionRecommendation,
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Actions
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Acknowledged: ${insight.title}')),
                                    );
                                  },
                                  child: const Text('Acknowledge'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: color,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  ),
                                  icon: const Icon(Icons.check, size: 14),
                                  label: const Text('Mark Resolved', style: TextStyle(fontSize: 12)),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Marked "${insight.title}" as resolved!')),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          );
        },
      ),
    );
  }
}
