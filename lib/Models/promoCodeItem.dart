class PromoCodeItem {
  final String name;
  final double offer;
  final String type;
  final double minAmount;
  final String parentType;
  final List<String> itemIdentifier;
  final String description;
  final String firebaseId;
  final String imageUrl;

  PromoCodeItem({
    required this.name,
    required this.offer,
    required this.type,
    required this.minAmount,
    required this.parentType,
    required this.itemIdentifier,
    required this.description,
    required this.imageUrl,
    required this.firebaseId

  });
}
