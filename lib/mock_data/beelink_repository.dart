import 'package:flutter/foundation.dart';
import '../models/hive_model.dart';
import '../models/batch_model.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';
import '../models/ai_insight_model.dart';

class BeeLinkRepository extends ChangeNotifier {
  static final BeeLinkRepository _instance = BeeLinkRepository._internal();
  factory BeeLinkRepository() => _instance;

  BeeLinkRepository._internal() {
    _initData();
  }

  final List<HiveModel> _hives = [];
  final List<HoneyBatchModel> _batches = [];
  final List<ProductModel> _products = [];
  final List<OrderModel> _orders = [];
  final List<AiInsightModel> _insights = [];

  List<HiveModel> get hives => List.unmodifiable(_hives);
  List<HoneyBatchModel> get batches => List.unmodifiable(_batches);
  List<ProductModel> get products => List.unmodifiable(_products);
  List<OrderModel> get orders => List.unmodifiable(_orders);
  List<AiInsightModel> get insights => List.unmodifiable(_insights);

  HoneyBatchModel? getBatchById(String id) {
    try {
      return _batches.firstWhere(
        (b) => b.id.trim().toLowerCase() == id.trim().toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  HiveModel? getHiveById(String id) {
    try {
      return _hives.firstWhere((h) => h.id == id);
    } catch (_) {
      return null;
    }
  }

  void addHarvest(HoneyBatchModel batch) {
    _batches.insert(0, batch);
    notifyListeners();
  }

  void addProduct(ProductModel product) {
    _products.insert(0, product);
    notifyListeners();
  }

  void updateProductStock(String productId, int newStock) {
    final idx = _products.indexWhere((p) => p.id == productId);
    if (idx != -1) {
      _products[idx].stockCount = newStock.clamp(0, 9999);
      notifyListeners();
    }
  }

  void placeOrder({
    required ProductModel product,
    required int jarCount,
    required String deliveryAddress,
  }) {
    final orderId = 'ORD-2026-${1000 + _orders.length + 1}';
    final now = DateTime.now();

    final order = OrderModel(
      id: orderId,
      batchId: product.batchId,
      productName: '${product.name} (${product.jarSize})',
      jarCount: jarCount,
      totalPrice: product.price * jarCount,
      orderDate: now,
      status: 'Processing',
      deliveryAddress: deliveryAddress,
      carrier: 'EcoBee Express',
      trackingNumber: 'EBX-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
      steps: [
        OrderStep(
          title: 'Order Confirmed & Payment Verified',
          description: 'Payment processed and artisan packaging reserved.',
          timestamp: now,
          isDone: true,
        ),
        OrderStep(
          title: 'Direct Hive Provenance Attached',
          description: 'Batch #${product.batchId} cryptographic seal verified.',
          timestamp: now.add(const Duration(minutes: 5)),
          isDone: true,
        ),
        OrderStep(
          title: 'Cold Storage Packing',
          description: 'Packed in zero-waste thermal insulating glass container.',
          timestamp: now.add(const Duration(hours: 4)),
          isDone: false,
        ),
        OrderStep(
          title: 'Handed to Eco Courier',
          description: 'Dispatched with climate-controlled electric vehicle.',
          timestamp: now.add(const Duration(days: 1)),
          isDone: false,
        ),
        OrderStep(
          title: 'Delivered',
          description: 'Expected arrival at doorstep.',
          timestamp: now.add(const Duration(days: 3)),
          isDone: false,
        ),
      ],
    );

    product.stockCount = (product.stockCount - jarCount).clamp(0, 9999);
    _orders.insert(0, order);
    notifyListeners();
  }

  void _initData() {
    // 1. Initial Hives
    _hives.addAll([
      const HiveModel(
        id: 'HIVE-01',
        name: 'Golden Valley Queen #1',
        location: 'Meadow Ridge Apiary, Zone A',
        weightKg: 46.2,
        temperatureC: 34.8,
        humidityPercent: 54.5,
        status: 'Healthy',
        queenAgeMonths: 8,
        weightHistory: [
          TelemetryPoint(0, 44.5),
          TelemetryPoint(4, 44.6),
          TelemetryPoint(8, 44.8),
          TelemetryPoint(12, 45.4),
          TelemetryPoint(16, 45.9),
          TelemetryPoint(20, 46.2),
          TelemetryPoint(24, 46.2),
        ],
        tempHistory: [
          TelemetryPoint(0, 34.2),
          TelemetryPoint(4, 34.0),
          TelemetryPoint(8, 34.5),
          TelemetryPoint(12, 35.1),
          TelemetryPoint(16, 35.0),
          TelemetryPoint(20, 34.8),
          TelemetryPoint(24, 34.8),
        ],
        humidityHistory: [
          TelemetryPoint(0, 57.0),
          TelemetryPoint(4, 58.0),
          TelemetryPoint(8, 56.0),
          TelemetryPoint(12, 53.0),
          TelemetryPoint(16, 52.0),
          TelemetryPoint(20, 54.5),
          TelemetryPoint(24, 54.5),
        ],
      ),
      const HiveModel(
        id: 'HIVE-02',
        name: 'Wildflower Ridge #2',
        location: 'Sunnyside Hill Apiary, Box 3',
        weightKg: 49.8,
        temperatureC: 35.1,
        humidityPercent: 52.0,
        status: 'Healthy',
        queenAgeMonths: 14,
        weightHistory: [
          TelemetryPoint(0, 48.0),
          TelemetryPoint(4, 48.1),
          TelemetryPoint(8, 48.4),
          TelemetryPoint(12, 49.0),
          TelemetryPoint(16, 49.6),
          TelemetryPoint(20, 49.8),
          TelemetryPoint(24, 49.8),
        ],
        tempHistory: [
          TelemetryPoint(0, 34.9),
          TelemetryPoint(4, 34.7),
          TelemetryPoint(8, 35.0),
          TelemetryPoint(12, 35.4),
          TelemetryPoint(16, 35.2),
          TelemetryPoint(20, 35.1),
          TelemetryPoint(24, 35.1),
        ],
        humidityHistory: [
          TelemetryPoint(0, 55.0),
          TelemetryPoint(4, 56.0),
          TelemetryPoint(8, 54.0),
          TelemetryPoint(12, 51.0),
          TelemetryPoint(16, 51.5),
          TelemetryPoint(20, 52.0),
          TelemetryPoint(24, 52.0),
        ],
      ),
      const HiveModel(
        id: 'HIVE-03',
        name: 'Alpine Lavender Box #3',
        location: 'Cedar Wood Crest, Sector 2',
        weightKg: 42.1,
        temperatureC: 36.4,
        humidityPercent: 61.2,
        status: 'Attention',
        queenAgeMonths: 20,
        weightHistory: [
          TelemetryPoint(0, 44.0),
          TelemetryPoint(4, 43.8),
          TelemetryPoint(8, 43.2),
          TelemetryPoint(12, 42.8),
          TelemetryPoint(16, 42.4),
          TelemetryPoint(20, 42.1),
          TelemetryPoint(24, 42.1),
        ],
        tempHistory: [
          TelemetryPoint(0, 35.0),
          TelemetryPoint(4, 35.2),
          TelemetryPoint(8, 35.8),
          TelemetryPoint(12, 36.2),
          TelemetryPoint(16, 36.5),
          TelemetryPoint(20, 36.4),
          TelemetryPoint(24, 36.4),
        ],
        humidityHistory: [
          TelemetryPoint(0, 58.0),
          TelemetryPoint(4, 59.0),
          TelemetryPoint(8, 60.5),
          TelemetryPoint(12, 62.0),
          TelemetryPoint(16, 61.8),
          TelemetryPoint(20, 61.2),
          TelemetryPoint(24, 61.2),
        ],
      ),
      const HiveModel(
        id: 'HIVE-04',
        name: 'Forest Acacia #4',
        location: 'Oak Valley Grove, Stand D',
        weightKg: 51.4,
        temperatureC: 34.6,
        humidityPercent: 53.8,
        status: 'Healthy',
        queenAgeMonths: 6,
        weightHistory: [
          TelemetryPoint(0, 49.5),
          TelemetryPoint(4, 49.7),
          TelemetryPoint(8, 50.1),
          TelemetryPoint(12, 50.8),
          TelemetryPoint(16, 51.2),
          TelemetryPoint(20, 51.4),
          TelemetryPoint(24, 51.4),
        ],
        tempHistory: [
          TelemetryPoint(0, 34.4),
          TelemetryPoint(4, 34.3),
          TelemetryPoint(8, 34.6),
          TelemetryPoint(12, 34.9),
          TelemetryPoint(16, 34.7),
          TelemetryPoint(20, 34.6),
          TelemetryPoint(24, 34.6),
        ],
        humidityHistory: [
          TelemetryPoint(0, 55.0),
          TelemetryPoint(4, 56.0),
          TelemetryPoint(8, 54.0),
          TelemetryPoint(12, 53.0),
          TelemetryPoint(16, 53.5),
          TelemetryPoint(20, 53.8),
          TelemetryPoint(24, 53.8),
        ],
      ),
    ]);

    // 2. Initial Honey Batches
    _batches.addAll([
      HoneyBatchModel(
        id: 'BATCH-RAW-HONEY-2026-001',
        hiveId: 'HIVE-01',
        hiveName: 'Golden Valley Queen #1',
        beekeeperName: 'Marcus Vance (Certified Master Beekeeper)',
        apiaryLocation: 'Meadow Ridge, Cascade Foothills (Elev. 420m)',
        floralSource: 'Wild Mountain Blossom & Clover',
        harvestDate: DateTime.now().subtract(const Duration(days: 12)),
        netWeightKg: 18.5,
        moisturePercent: 16.8,
        purityScorePercent: 99.8,
        pollenDna: '84% Trifolium repens, 16% Rubus idaeus',
        flavorNotes: 'Rich buttery notes, delicate caramel undertones, floral aroma',
        blockchainTxHash: '0x3c8a91b427d11f8e65e490fa2e89d1b0987ceea3',
        milestones: [
          TraceMilestone(
            title: 'Harvested from Hive #1',
            description: 'Uncapped by hand and cold-spun extraction under 32°C.',
            timestamp: DateTime.now().subtract(const Duration(days: 12)),
            actor: 'Marcus Vance, Head Apiarist',
          ),
          TraceMilestone(
            title: 'Bio-Lab Purity & Moisture Analysis',
            description: 'Passed ISO 17025 certification with 16.8% moisture & 0% synthetic sugars.',
            timestamp: DateTime.now().subtract(const Duration(days: 10)),
            actor: 'BioTrace Alpine Laboratory',
          ),
          TraceMilestone(
            title: 'Cold Bottled & Sealed',
            description: 'Packaged into amber UV-protective glass jars with NFC & QR seal.',
            timestamp: DateTime.now().subtract(const Duration(days: 8)),
            actor: 'BeeLink Certified Packager',
          ),
          TraceMilestone(
            title: 'Batch Distributed to Marketplace',
            description: 'Cryptographically registered and ready for direct consumer dispatch.',
            timestamp: DateTime.now().subtract(const Duration(days: 7)),
            actor: 'BeeLink Protocol Registry',
          ),
        ],
      ),
      HoneyBatchModel(
        id: 'BATCH-ACACIA-2026-002',
        hiveId: 'HIVE-04',
        hiveName: 'Forest Acacia #4',
        beekeeperName: 'Elena Rostova (Sustainable Apiculture Lab)',
        apiaryLocation: 'Oak Valley Forest Sanctuary, Stand D',
        floralSource: 'Robinia Pseudoacacia (Black Locust)',
        harvestDate: DateTime.now().subtract(const Duration(days: 18)),
        netWeightKg: 24.0,
        moisturePercent: 15.9,
        purityScorePercent: 99.9,
        pollenDna: '92% Robinia pseudoacacia, 8% Acer campestre',
        flavorNotes: 'Ultra-light golden clarity, delicate sweet vanilla finish, zero bitterness',
        blockchainTxHash: '0x992fa44e761c028a17d84b90123feaa551d08771',
        milestones: [
          TraceMilestone(
            title: 'Acacia Bloom Harvest',
            description: 'Harvested during peak 10-day spring acacia blooming window.',
            timestamp: DateTime.now().subtract(const Duration(days: 18)),
            actor: 'Elena Rostova, Apiarist',
          ),
          TraceMilestone(
            title: 'Micro-Filtration & Pollen DNA Sequencing',
            description: 'Confirmed 92% monofloral purity with zero pesticide residues detected.',
            timestamp: DateTime.now().subtract(const Duration(days: 15)),
            actor: 'PollenDNA Analytical Labs',
          ),
          TraceMilestone(
            title: 'Certified Organic Bottling',
            description: 'Sealed in tamper-evident artisan jars with freshness validation.',
            timestamp: DateTime.now().subtract(const Duration(days: 14)),
            actor: 'EcoBee Fulfillment Hub',
          ),
        ],
      ),
      HoneyBatchModel(
        id: 'BATCH-LAVENDER-2026-003',
        hiveId: 'HIVE-03',
        hiveName: 'Alpine Lavender Box #3',
        beekeeperName: 'Sylvia Chen (Artisan Beekeeper)',
        apiaryLocation: 'High Provence Lavender Valleys',
        floralSource: 'Lavandula angustifolia',
        harvestDate: DateTime.now().subtract(const Duration(days: 25)),
        netWeightKg: 14.2,
        moisturePercent: 17.1,
        purityScorePercent: 99.6,
        pollenDna: '89% Lavandula, 11% Thymus vulgaris',
        flavorNotes: 'Herbaceous, calming lavender aroma, silky smooth crystallization',
        blockchainTxHash: '0x551be892a0149cc7e4367ef99901aa84b12c8190',
        milestones: [
          TraceMilestone(
            title: 'Alpine Harvest',
            description: 'Harvested at sunset when foraging bees have returned.',
            timestamp: DateTime.now().subtract(const Duration(days: 25)),
            actor: 'Sylvia Chen',
          ),
          TraceMilestone(
            title: 'Spectroscopy Quality Verification',
            description: 'Verified enzymatic diastase activity > 15 Schade units.',
            timestamp: DateTime.now().subtract(const Duration(days: 22)),
            actor: 'Alpine Quality Assurance',
          ),
        ],
      ),
    ]);

    // 3. Initial Marketplace Products
    _products.addAll([
      ProductModel(
        id: 'PROD-01',
        batchId: 'BATCH-RAW-HONEY-2026-001',
        name: 'Wild Mountain Raw Honey',
        description: 'Single-source raw wildflower honey cold-extracted from Meadow Ridge. Unpasteurized and unfiltered with live enzymes.',
        floralSource: 'Wildflower',
        price: 24.50,
        jarSize: '500g',
        stockCount: 28,
        beekeeperName: 'Marcus Vance',
        rating: 4.9,
        reviewsCount: 142,
        isOrganic: true,
        iconEmoji: '🍯',
      ),
      ProductModel(
        id: 'PROD-02',
        batchId: 'BATCH-ACACIA-2026-002',
        name: 'Pure Forest Monofloral Acacia',
        description: 'Ultra-clear, slow to crystallize, featuring soothing sweet notes of vanilla and acacia blossom. 100% trace-verified.',
        floralSource: 'Acacia',
        price: 32.00,
        jarSize: '500g',
        stockCount: 19,
        beekeeperName: 'Elena Rostova',
        rating: 5.0,
        reviewsCount: 88,
        isOrganic: true,
        iconEmoji: '🌼',
      ),
      ProductModel(
        id: 'PROD-03',
        batchId: 'BATCH-LAVENDER-2026-003',
        name: 'Artisan Alpine Lavender Honey',
        description: 'Rare monofloral lavender honey with intoxicating floral aroma and rich calming properties. Certified organic.',
        floralSource: 'Lavender',
        price: 28.50,
        jarSize: '350g',
        stockCount: 14,
        beekeeperName: 'Sylvia Chen',
        rating: 4.8,
        reviewsCount: 65,
        isOrganic: true,
        iconEmoji: '💜',
      ),
      ProductModel(
        id: 'PROD-04',
        batchId: 'BATCH-RAW-HONEY-2026-001',
        name: 'Raw Honeycomb Reserve Cut',
        description: 'Direct cut comb straight from the hive frame. Purest way to experience raw honey with natural beeswax wax cells.',
        floralSource: 'Wildflower',
        price: 36.00,
        jarSize: '400g comb',
        stockCount: 8,
        beekeeperName: 'Marcus Vance',
        rating: 4.95,
        reviewsCount: 47,
        isOrganic: true,
        iconEmoji: '🐝',
      ),
    ]);

    // 4. Initial Orders
    _orders.addAll([
      OrderModel(
        id: 'ORD-2026-0941',
        batchId: 'BATCH-RAW-HONEY-2026-001',
        productName: 'Wild Mountain Raw Honey (500g)',
        jarCount: 2,
        totalPrice: 49.00,
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
        status: 'In Transit',
        deliveryAddress: '742 Evergreen Terrace, Portland, OR',
        carrier: 'EcoBee Green Courier',
        trackingNumber: 'EBX-88492019',
        steps: [
          OrderStep(
            title: 'Order Confirmed',
            description: 'Payment processed and batch reserved.',
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
            isDone: true,
          ),
          OrderStep(
            title: 'Batch Trace Sealed',
            description: 'Jar labeled with Batch #BATCH-RAW-HONEY-2026-001 QR code.',
            timestamp: DateTime.now().subtract(const Duration(days: 2, hours: -3)),
            isDone: true,
          ),
          OrderStep(
            title: 'In Transit with Electric Fleet',
            description: 'Package departed local distribution hub.',
            timestamp: DateTime.now().subtract(const Duration(hours: 14)),
            isDone: true,
          ),
          OrderStep(
            title: 'Out for Delivery',
            description: 'Driver is on the way to your address.',
            timestamp: DateTime.now().add(const Duration(hours: 3)),
            isDone: false,
          ),
          OrderStep(
            title: 'Delivered',
            description: 'Direct delivery to customer hands.',
            timestamp: DateTime.now().add(const Duration(hours: 6)),
            isDone: false,
          ),
        ],
      ),
      OrderModel(
        id: 'ORD-2026-0889',
        batchId: 'BATCH-ACACIA-2026-002',
        productName: 'Pure Forest Monofloral Acacia (500g)',
        jarCount: 1,
        totalPrice: 32.00,
        orderDate: DateTime.now().subtract(const Duration(days: 8)),
        status: 'Delivered',
        deliveryAddress: '120 Market Street, Suite 400, Seattle, WA',
        carrier: 'EcoBee Express',
        trackingNumber: 'EBX-39184022',
        steps: [
          OrderStep(
            title: 'Order Placed & Confirmed',
            description: 'Order received by Elena Rostova apiary.',
            timestamp: DateTime.now().subtract(const Duration(days: 8)),
            isDone: true,
          ),
          OrderStep(
            title: 'Custom Inspected & Packed',
            description: 'Batch #BATCH-ACACIA-2026-002 cold seal inspected.',
            timestamp: DateTime.now().subtract(const Duration(days: 7)),
            isDone: true,
          ),
          OrderStep(
            title: 'Dispatched & Transported',
            description: 'Delivered via green carrier.',
            timestamp: DateTime.now().subtract(const Duration(days: 6)),
            isDone: true,
          ),
          OrderStep(
            title: 'Successfully Delivered',
            description: 'Received and authenticated via QR scan.',
            timestamp: DateTime.now().subtract(const Duration(days: 5)),
            isDone: true,
          ),
        ],
      ),
    ]);

    // 5. Initial AI Insights
    _insights.addAll([
      AiInsightModel(
        id: 'INS-01',
        hiveId: 'HIVE-03',
        hiveName: 'Alpine Lavender Box #3',
        title: 'Swarm Preparation Pattern Detected',
        category: 'Swarm Prediction',
        severity: InsightSeverity.urgent,
        description: 'Internal acoustic frequency peaked at 245 Hz with a 1.4°C brood nest rise. Weight curve flattening indicates pre-swarm reduction in foraging activity.',
        actionRecommendation: 'Inspect lower brood chambers for swarm cells immediately. Add a super box or prepare a split within 24 hours to prevent colony departure.',
        confidencePercent: 94,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      AiInsightModel(
        id: 'INS-02',
        hiveId: 'HIVE-02',
        hiveName: 'Wildflower Ridge #2',
        title: 'Peak Nectar Inflow & Optimal Harvest Window',
        category: 'Harvest Forecast',
        severity: InsightSeverity.optimal,
        description: 'Net hive weight gained +1.8 kg in past 36 hours. Capping rate has reached approximately 82%. Weather forecast predicts sunny 26°C conditions for the next 3 days.',
        actionRecommendation: 'Ideal extraction window opens in 48 hours. Ready for harvesting approximately 16-20 kg of premium grade wildflower honey.',
        confidencePercent: 91,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      AiInsightModel(
        id: 'INS-03',
        hiveId: 'HIVE-01',
        hiveName: 'Golden Valley Queen #1',
        title: 'Optimal Foraging & Thermoregulation',
        category: 'Colony Health',
        severity: InsightSeverity.info,
        description: 'Internal temperature remains locked within perfect 34.5°C–35.0°C range. Foraging flight patterns indicate strong pollen diversity with high vitality.',
        actionRecommendation: 'No intervention needed. Colony is in peak health.',
        confidencePercent: 98,
        timestamp: DateTime.now().subtract(const Duration(hours: 9)),
      ),
      AiInsightModel(
        id: 'INS-04',
        hiveId: 'HIVE-04',
        hiveName: 'Forest Acacia #4',
        title: 'High Humidity Microclimate Warning',
        category: 'Climate & Moisture',
        severity: InsightSeverity.warning,
        description: 'Nighttime humidity sustained above 58% may prolong honey ripening and moisture reduction in newly stored nectar.',
        actionRecommendation: 'Ensure upper hive ventilation slit is unobstructed to assist bees in fanning and moisture evaporation.',
        confidencePercent: 86,
        timestamp: DateTime.now().subtract(const Duration(hours: 14)),
      ),
    ]);
  }
}
