import 'package:flutter/foundation.dart';
import 'package:freshli_delivery/Models/childCategory.dart';

class OfferItem {
  final String firebaseId;
  final String heading;
  final List<String> itemIdentifier;
  OfferItem({
    required this.firebaseId,
    required this.heading,
    required this.itemIdentifier
  });
}