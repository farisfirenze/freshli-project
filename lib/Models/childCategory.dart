import 'Item.dart';

class ChildCategory {
  final String firebaseId;
  final String imageUrl;
  final String name;
  final String description;
  final Item item;
  ChildCategory({
    required this.imageUrl,
    required this.firebaseId,
    required this.name,
    required this.description,
    required this.item,
  });
}
