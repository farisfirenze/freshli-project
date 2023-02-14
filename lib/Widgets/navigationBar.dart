import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freshli_delivery/Data/globalVariables.dart';
import 'package:freshli_delivery/Screens/orderScreen.dart';

import '../Screens/cartScreen.dart';
import '../Screens/homeScreen.dart';
import '../Screens/profileScreen.dart';

class NavigationsBar extends StatelessWidget {
  final idScreen;
  const NavigationsBar({Key? key, required this.idScreen}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        height: 70.0,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 5.0,
              spreadRadius: 0.1,
              offset: Offset(0.2, 0.2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                if (idScreen != "home"){
                  Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
                }
                else{
                  displayToastMessage("You are already home.", context);
                }
              },
              child: SizedBox(
                height: 45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.home_outlined,
                      size: 30,
                      color: brandGreen,
                    ),
                    const Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "AwanZaman",

                      ),
                    ),
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                if (idScreen != "cart"){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                }
                else{
                  displayToastMessage("You are already in cart.", context);
                }
              },
              child: SizedBox(
                height: 45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 30,
                      color: brandGreen,
                    ),
                    const Text(
                      'Cart',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "AwanZaman",

                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (idScreen != "orders"){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderScreen()));
                }
                else{
                  displayToastMessage("You are already in orders.", context);
                }
              },
              child: SizedBox(
                height: 45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.check_box_outlined,
                      size: 30,
                      color: brandGreen,
                    ),
                    const Text(
                      'Orders',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "AwanZaman",

                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (idScreen != "profile"){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                }
                else{
                  displayToastMessage("You are already home.", context);
                }
              },
              child: SizedBox(
                height: 45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.account_circle_outlined,
                      size: 30,
                      color: brandGreen,
                    ),
                    const Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "AwanZaman",

                      ),
                    ),
                  ],
                ),
              ),
            ),


            // Search screen
          ],
        ),
      ),
    );
  }

  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}
