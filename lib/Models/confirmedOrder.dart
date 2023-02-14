import 'Item.dart';
import 'category.dart';
import 'childCategory.dart';

class ConfirmedOrder {
  final List<Map<dynamic, dynamic>> items;
  final String status;
  final DateTime orderedOn;
  final String firebaseId;
  final double total;
  final String orderId;
  ConfirmedOrder({
    required this.items,
    required this.orderedOn,
    required this.status,
    required this.firebaseId,
    required this.orderId,
    required this.total
  });
}