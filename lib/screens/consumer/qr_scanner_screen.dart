import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../mock_data/beelink_repository.dart';
import 'batch_details_screen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _isProcessing = false;
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _scannerController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? code = barcode.rawValue;
      if (code != null && code.isNotEmpty) {
        _handleCode(code);
        break;
      }
    }
  }

  void _handleCode(String code) {
    setState(() => _isProcessing = true);
    final repo = BeeLinkRepository();
    final batch = repo.getBatchById(code);

    if (batch != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BatchDetailsScreen(batch: batch),
        ),
      ).then((_) {
        if (mounted) setState(() => _isProcessing = false);
      });
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              SizedBox(width: 8),
              Text('Unrecognized Batch'),
            ],
          ),
          content: Text(
            'The scanned code "$code" is not registered in the BeeLink provenance network.\n\nTry selecting one of the verified demo batches below.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() => _isProcessing = false);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _showManualEntryDialog() {
    _textController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter Batch Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter the Batch ID printed near the QR label on your honey jar.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Batch ID',
                hintText: 'e.g. BATCH-RAW-HONEY-2026-001',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.qr_code),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final val = _textController.text.trim();
              Navigator.pop(ctx);
              if (val.isNotEmpty) {
                _handleCode(val);
              }
            },
            child: const Text('Verify Batch'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = BeeLinkRepository();
    final sampleBatches = repo.batches;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Honey Authenticity Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            tooltip: 'Toggle Flash',
            onPressed: () => _scannerController.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            tooltip: 'Switch Camera',
            onPressed: () => _scannerController.switchCamera(),
          ),
          IconButton(
            icon: const Icon(Icons.edit_note),
            tooltip: 'Enter Batch ID Manually',
            onPressed: _showManualEntryDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Camera Viewfinder / MobileScanner area
          Expanded(
            flex: 5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                MobileScanner(
                  controller: _scannerController,
                  onDetect: _onDetect,
                  errorBuilder: (context, error, child) {
                    return Container(
                      color: Colors.black87,
                      padding: const EdgeInsets.all(24),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.camera_alt_outlined, color: Colors.amber, size: 56),
                          const SizedBox(height: 12),
                          const Text(
                            'Camera Viewfinder Preview',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Camera access unavailable or on desktop/emulator.\nUse the quick demo buttons below to trace batches instantly.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // Reticle Overlay Box
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber, width: 3),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withValues(alpha: 0.15),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.qr_code_scanner, color: Colors.amber, size: 14),
                              SizedBox(width: 4),
                              Text('ALIGN QR CODE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (_isProcessing)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.amber),
                    ),
                  ),
              ],
            ),
          ),

          // 2. Demo & Quick-Verification Panel
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '⚡ Quick-Verify Demo Batches',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    TextButton.icon(
                      onPressed: _showManualEntryDialog,
                      icon: const Icon(Icons.keyboard, size: 16),
                      label: const Text('Type Code', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: sampleBatches.map((batch) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ActionChip(
                          avatar: const CircleAvatar(
                            backgroundColor: Colors.amber,
                            child: Icon(Icons.qr_code, size: 14, color: Colors.black87),
                          ),
                          label: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(batch.floralSource, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Text(batch.id, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                            ],
                          ),
                          onPressed: () => _handleCode(batch.id),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
