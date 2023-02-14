import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freshli_delivery/Data/globalVariables.dart';

import '../Models/order.dart';
import '../Screens/homeScreen.dart';

class PriceBar extends StatelessWidget {
  final String idScreen, id;
  final double price;
  final int quantity;
  const PriceBar({Key? key, required this.idScreen, required this.price, required this.id, required this.quantity}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      decoration: const BoxDecoration(
        color: Color(0xffefffea),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0, left: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Price: \u{20B9} $price",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: brandGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Total Quantity: $quantity",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: brandGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            quantity > 0 ? Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Center(
                child: Text(
                  'Added $quantity more to cart!',
                  style: TextStyle(
                    color: brandGreen,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ) : Container(),

          ],
        ),
      ),
    );
  }

  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}
