import 'childCategory.dart';

class Category {
  final String firebaseId;
  final String imageUrl;
  final String name;
  final String description;
  final List<ChildCategory> childCategories;
  Category({
    required this.imageUrl,
    required this.firebaseId,
    required this.name,
    required this.description,
    required this.childCategories,
  });
}
