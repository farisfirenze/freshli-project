import 'Item.dart';
import 'category.dart';
import 'childCategory.dart';

class Order {
  final Category category;
  final ChildCategory childCategory;
  final String item;
  final String itemIdentifierString;
  final double price;
  final int quantity;
  Order({
    required this.category,
    required this.childCategory,
    required this.item,
    required this.itemIdentifierString,
    required this.quantity,
    required this.price,
  });
}
