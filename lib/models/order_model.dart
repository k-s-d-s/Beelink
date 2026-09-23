class OrderStep {
  final String title;
  final String description;
  final DateTime timestamp;
  final bool isDone;

  const OrderStep({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.isDone,
  });
}

class OrderModel {
  final String id;
  final String batchId;
  final String productName;
  final int jarCount;
  final double totalPrice;
  final DateTime orderDate;
  final String status; // 'Processing', 'In Transit', 'Delivered'
  final String deliveryAddress;
  final String carrier;
  final String trackingNumber;
  final List<OrderStep> steps;

  const OrderModel({
    required this.id,
    required this.batchId,
    required this.productName,
    required this.jarCount,
    required this.totalPrice,
    required this.orderDate,
    required this.status,
    required this.deliveryAddress,
    required this.carrier,
    required this.trackingNumber,
    required this.steps,
  });
}
