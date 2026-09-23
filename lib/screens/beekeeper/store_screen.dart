import 'package:flutter/material.dart';
import '../../mock_data/beelink_repository.dart';
import '../../models/product_model.dart';
import '../consumer/batch_details_screen.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  void _showAddProductDialog(BuildContext context) {
    final repo = BeeLinkRepository();
    final batches = repo.batches;

    if (batches.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log a harvest batch first before listing products!')),
      );
      return;
    }

    String selectedBatchId = batches.first.id;
    final nameController = TextEditingController(text: 'Artisan Raw ${batches.first.floralSource}');
    final priceController = TextEditingController(text: '26.00');
    final stockController = TextEditingController(text: '30');
    final descController = TextEditingController(text: 'Single-apiary cold extracted raw honey, 100% trace verified.');
    String selectedSize = '500g';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          final chosenBatch = repo.getBatchById(selectedBatchId) ?? batches.first;

          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.storefront, color: Colors.amber),
                SizedBox(width: 8),
                Text('List Harvest to Marketplace'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Source Harvest Batch:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: selectedBatchId,
                    isExpanded: true,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    items: batches.map((b) {
                      return DropdownMenuItem(
                        value: b.id,
                        child: Text('${b.floralSource} (${b.id})', overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() {
                          selectedBatchId = val;
                          final b = repo.getBatchById(val);
                          if (b != null) {
                            nameController.text = 'Artisan Raw ${b.floralSource}';
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Listing Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: priceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Price (\$)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: stockController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Jars in Stock',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    initialValue: selectedSize,
                    decoration: const InputDecoration(
                      labelText: 'Jar Packaging Size',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: '350g', child: Text('350g Artisan Jar')),
                      DropdownMenuItem(value: '500g', child: Text('500g Standard Jar')),
                      DropdownMenuItem(value: '1kg', child: Text('1kg Family Jar')),
                    ],
                    onChanged: (val) {
                      if (val != null) setDialogState(() => selectedSize = val);
                    },
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: descController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Description for Consumers',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade800, foregroundColor: Colors.white),
                onPressed: () {
                  final newProduct = ProductModel(
                    id: 'PROD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                    batchId: selectedBatchId,
                    name: nameController.text.trim(),
                    description: descController.text.trim(),
                    floralSource: chosenBatch.floralSource,
                    price: double.tryParse(priceController.text) ?? 24.0,
                    jarSize: selectedSize,
                    stockCount: int.tryParse(stockController.text) ?? 20,
                    beekeeperName: chosenBatch.beekeeperName.split('(').first.trim(),
                    rating: 5.0,
                    reviewsCount: 0,
                    isOrganic: true,
                    iconEmoji: '🍯',
                  );

                  repo.addProduct(newProduct);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green.shade800,
                      content: Text('Listed "${newProduct.name}" to BeeLink Marketplace!'),
                    ),
                  );
                },
                child: const Text('List on Marketplace'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = BeeLinkRepository();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beekeeper Store & Inventory'),
      ),
      body: ListenableBuilder(
        listenable: repo,
        builder: (context, _) {
          final products = repo.products;
          final totalInventory = products.fold<int>(0, (acc, p) => acc + p.stockCount);
          final orders = repo.orders;
          final totalRevenue = orders.fold<double>(0.0, (acc, o) => acc + o.totalPrice);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Revenue & Sales Stats
                Row(
                  children: [
                    _buildStatCard(
                      'Total Revenue',
                      '\$${totalRevenue.toStringAsFixed(2)}',
                      'Across ${orders.length} orders',
                      Icons.payments,
                      Colors.green.shade700,
                    ),
                    const SizedBox(width: 8),
                    _buildStatCard(
                      'Live Listings',
                      '${products.length}',
                      'Active products',
                      Icons.storefront,
                      Colors.amber.shade800,
                    ),
                    const SizedBox(width: 8),
                    _buildStatCard(
                      'Total Jars',
                      '$totalInventory',
                      'In stock now',
                      Icons.inventory_2,
                      Colors.blue.shade700,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Action to list new product
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade800,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Package Batch & List on Marketplace', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () => _showAddProductDialog(context),
                  ),
                ),
                const SizedBox(height: 24),

                // Inventory Listing
                const Text(
                  'Current Store Inventory',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final batch = repo.getBatchById(product.batchId);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(product.iconEmoji, style: const TextStyle(fontSize: 28)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      Text(
                                        '${product.jarSize} • Batch #${product.batchId}',
                                        style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepOrange),
                                ),
                              ],
                            ),
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text('Stock: ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline, size: 20),
                                      onPressed: product.stockCount > 0
                                          ? () => repo.updateProductStock(product.id, product.stockCount - 1)
                                          : null,
                                    ),
                                    Text('${product.stockCount}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline, size: 20),
                                      onPressed: () => repo.updateProductStock(product.id, product.stockCount + 1),
                                    ),
                                  ],
                                ),
                                if (batch != null)
                                  TextButton.icon(
                                    icon: const Icon(Icons.verified, size: 14),
                                    label: const Text('View Batch', style: TextStyle(fontSize: 12)),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BatchDetailsScreen(batch: batch),
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color) {
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
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 2),
            Text(title, style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
            Text(subtitle, style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }
}
