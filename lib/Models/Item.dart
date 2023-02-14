class Item {
  final String imageUrl;
  final String description;
  final String wholeName;
  final String cleanName;
  final Map variants;
  final bool wholeCleaned;
  Item({
    required this.imageUrl,
    required this.description,
    required this.variants,
    required this.wholeCleaned,
    required this.wholeName,
    required this.cleanName
  });
}