import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../mock_data/beelink_repository.dart';
import '../../models/batch_model.dart';
import '../consumer/batch_details_screen.dart';

class HarvestLoggerScreen extends StatefulWidget {
  final String? initialHiveId;

  const HarvestLoggerScreen({super.key, this.initialHiveId});

  @override
  State<HarvestLoggerScreen> createState() => _HarvestLoggerScreenState();
}

class _HarvestLoggerScreenState extends State<HarvestLoggerScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _selectedHiveId;
  final TextEditingController _floralController = TextEditingController(text: 'Wild Mountain Blossom');
  final TextEditingController _weightController = TextEditingController(text: '16.5');
  final TextEditingController _moistureController = TextEditingController(text: '16.8');
  final TextEditingController _notesController = TextEditingController(text: 'Golden color, floral aroma with vanilla undertones.');

  late String _previewBatchId;

  @override
  void initState() {
    super.initState();
    final repo = BeeLinkRepository();
    _selectedHiveId = widget.initialHiveId ?? (repo.hives.isNotEmpty ? repo.hives.first.id : 'HIVE-01');
    _generateBatchId();
  }

  void _generateBatchId() {
    final randSuffix = (DateTime.now().millisecondsSinceEpoch % 1000).toString().padLeft(3, '0');
    _previewBatchId = 'BATCH-HARVEST-${DateTime.now().year}-$randSuffix';
  }

  @override
  void dispose() {
    _floralController.dispose();
    _weightController.dispose();
    _moistureController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitHarvest() {
    if (!_formKey.currentState!.validate()) return;

    final repo = BeeLinkRepository();
    final hive = repo.getHiveById(_selectedHiveId);
    final hiveName = hive?.name ?? 'Apiary Hive $_selectedHiveId';
    final weight = double.tryParse(_weightController.text) ?? 15.0;
    final moisture = double.tryParse(_moistureController.text) ?? 17.0;
    final now = DateTime.now();

    final newBatch = HoneyBatchModel(
      id: _previewBatchId,
      hiveId: _selectedHiveId,
      hiveName: hiveName,
      beekeeperName: 'Marcus Vance (Apiary Lead)',
      apiaryLocation: hive?.location ?? 'Meadow Ridge Apiary',
      floralSource: _floralController.text.trim(),
      harvestDate: now,
      netWeightKg: weight,
      moisturePercent: moisture,
      purityScorePercent: 99.8,
      pollenDna: '88% Monofloral verified by Lab PCR',
      flavorNotes: _notesController.text.trim(),
      blockchainTxHash: '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}fa19',
      milestones: [
        TraceMilestone(
          title: 'Harvested from $hiveName',
          description: 'Uncapped and cold-extracted under gentle centrifugation.',
          timestamp: now,
          actor: 'Marcus Vance',
        ),
        TraceMilestone(
          title: 'Immediate Refractometer Moisture Testing',
          description: 'Logged $moisture% moisture (Grade A Raw Honey standard).',
          timestamp: now.add(const Duration(minutes: 15)),
          actor: 'Apiary Lab QA',
        ),
        TraceMilestone(
          title: 'Cryptographic QR Label Created',
          description: 'Batch minted with tamper-evident serial QR verification.',
          timestamp: now.add(const Duration(minutes: 30)),
          actor: 'BeeLink Protocol',
        ),
      ],
    );

    repo.addHarvest(newBatch);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Harvest Batch Minted!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Batch ID: $_previewBatchId\nQR Label ready for jar packaging.'),
            const SizedBox(height: 16),
            SizedBox(
              width: 160,
              height: 160,
              child: QrImageView(
                data: _previewBatchId,
                version: QrVersions.auto,
                size: 160.0,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BatchDetailsScreen(batch: newBatch),
                ),
              );
            },
            child: const Text('View Batch Provenance'),
          ),
        ],
      ),
    );

    setState(() {
      _generateBatchId();
    });
  }

  @override
  Widget build(BuildContext context) {
    final repo = BeeLinkRepository();
    final hives = repo.hives;
    final batches = repo.batches;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Harvest Logger & QR Generator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber.shade700, Colors.orange.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.qr_code_2, color: Colors.white, size: 40),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Traceable Harvest Logging',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Every harvest generates an immutable QR passport tracing hive origin, moisture level, and botanical purity.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Form
            Form(
              key: _formKey,
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.withValues(alpha: 0.25)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Log New Harvest', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 16),

                      // Hive Selector Dropdown
                      DropdownButtonFormField<String>(
                        initialValue: _selectedHiveId,
                        decoration: const InputDecoration(
                          labelText: 'Source Hive',
                          prefixIcon: Icon(Icons.hive),
                          border: OutlineInputBorder(),
                        ),
                        items: hives.map((h) {
                          return DropdownMenuItem(
                            value: h.id,
                            child: Text('${h.name} (${h.id})'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedHiveId = val);
                        },
                      ),
                      const SizedBox(height: 14),

                      // Floral Source
                      TextFormField(
                        controller: _floralController,
                        decoration: const InputDecoration(
                          labelText: 'Floral Source / Botanical Variety',
                          prefixIcon: Icon(Icons.local_florist),
                          hintText: 'e.g. Monofloral Acacia, Wildflower',
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 14),

                      // Weight & Moisture Row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _weightController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Net Weight (kg)',
                                prefixIcon: Icon(Icons.scale),
                                border: OutlineInputBorder(),
                              ),
                              validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _moistureController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Moisture (%)',
                                prefixIcon: Icon(Icons.water_drop),
                                border: OutlineInputBorder(),
                              ),
                              validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Tasting Notes
                      TextFormField(
                        controller: _notesController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Sensory & Aroma Notes',
                          prefixIcon: Icon(Icons.rate_review),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // QR Preview Area
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber.shade200),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 64,
                              height: 64,
                              child: QrImageView(
                                data: _previewBatchId,
                                version: QrVersions.auto,
                                size: 64.0,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('AUTO-GENERATED BATCH ID', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                  Text(
                                    _previewBatchId,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'monospace'),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'QR code updates in real-time ready for printable labeling.',
                                    style: TextStyle(fontSize: 11, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade800,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.qr_code),
                          label: const Text('Mint Batch & Generate QR Label', style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: _submitHarvest,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Recent Harvest Batches
            const Text(
              'Recent Apiary Batches',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: batches.length,
              itemBuilder: (context, index) {
                final batch = batches[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 44,
                      height: 44,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.shade300),
                      ),
                      child: QrImageView(
                        data: batch.id,
                        version: QrVersions.auto,
                      ),
                    ),
                    title: Text(batch.floralSource, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text('${batch.netWeightKg} kg • Moisture ${batch.moisturePercent}%\n${batch.id}', style: const TextStyle(fontSize: 11)),
                    isThreeLine: true,
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BatchDetailsScreen(batch: batch),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
