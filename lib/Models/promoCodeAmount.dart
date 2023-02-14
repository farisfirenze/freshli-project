class PromoCodeAmount {
  final String name;
  final double offer;
  final String type;
  final double minAmount;
  final String parentType;
  final String description;
  final String firebaseId;
  final String imageUrl;
  PromoCodeAmount({
    required this.name,
    required this.offer,
    required this.type,
    required this.minAmount,
    required this.parentType,
    required this.description,
    required this.imageUrl,
    required this.firebaseId
  });
}
