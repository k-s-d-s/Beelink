class ProductModel {
  final String id;
  final String batchId;
  final String name;
  final String description;
  final String floralSource;
  final double price;
  final String jarSize;
  int stockCount;
  final String beekeeperName;
  final double rating;
  final int reviewsCount;
  final bool isOrganic;
  final String iconEmoji;

  ProductModel({
    required this.id,
    required this.batchId,
    required this.name,
    required this.description,
    required this.floralSource,
    required this.price,
    required this.jarSize,
    required this.stockCount,
    required this.beekeeperName,
    required this.rating,
    required this.reviewsCount,
    required this.isOrganic,
    this.iconEmoji = '🍯',
  });
}
