import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Widgets/Divider.dart';
import '../Data/globalVariables.dart';
import 'orderConfirmed.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

class CheckoutScreen extends StatefulWidget {
  static const String idScreen = "checkout";
  final double subtotal;
  final double discount;
  final double deliveryCharge;
  final double totalPrice;
  final List orders;
  const CheckoutScreen({Key? key, required this.subtotal, required this.discount, required this.deliveryCharge, required this.totalPrice, required this.orders}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {

  String orderText = "Place Order";



  String generateRandomString() {
    var rand = Random();
    var characters = '0123456789';
    var result = '';

    for (var i = 0; i < 10; i++) {
      result += characters[rand.nextInt(characters.length)];
    }

    return result;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brandWhite,
      appBar: null,
      body: Stack(
        children: [
          Positioned(
            left: 0.0,
            right: 0.0,
            top: 0.0,
            child: Container(
              height: 100.0,
              decoration: BoxDecoration(
                color: brandGreen,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.keyboard_backspace_outlined,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 40,
                            color: Colors.white,
                          ),
                          Text(
                            'Your Cart',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "AwanZaman",
                                color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(child: SizedBox(width: double.infinity,)),
                  ],
                ),
              ),
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 100,),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Subtotal", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontFamily: "AwanZaman")),
                                Text("\u{20B9} ${widget.subtotal.toStringAsFixed(2)}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontFamily: "AwanZaman")),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                usedPromoCodes.isNotEmpty ?
                                Row(
                                  children: [
                                    Text("Discount (${usedPromoCodes[0].name})", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontFamily: "AwanZaman"),),

                                  ],
                                ) : Row(
                              children: const [
                                Text("Discount", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontFamily: "AwanZaman"),),

                              ],
                            ),
                                Text("\u{20B9} ${widget.discount.toStringAsFixed(2)}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontFamily: "AwanZaman")),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Delivery Charge", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontFamily: "AwanZaman")),
                                Text("\u{20B9} ${widget.deliveryCharge.toStringAsFixed(2)}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontFamily: "AwanZaman")),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Total Price", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "AwanZaman")),
                                Text("\u{20B9} ${widget.totalPrice.toStringAsFixed(2)}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "AwanZaman")),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DividerWidget(customColor: brandGreen,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 50.0, right: 50.0),
                      child: Container(
                        width: 100.0,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                        ),
                        child: ElevatedButton(
                          onPressed: () async {

                            setState(() {
                              orderText = "Placing order ...";
                            });

                            String key = referenceGlobal.child("users").child(currentUser.firebaseId).child("orders").push().key!;

                            List tempItems = [];
                            List tempItemsAmount = [];
                            for (var elements in widget.orders) {
                              tempItems.add(
                                "${elements.itemIdentifierString}<sep>${elements.quantity}"
                              );
                              
                              List itemIds = elements.itemIdentifierString.split("<sep>");

                              final event = await referenceGlobal.child("Categories").child(itemIds[0]).child("childCategories").child(itemIds[1]).child("item").child("variants").child(itemIds[2]).once(DatabaseEventType.value);
                              Map tempData = event.snapshot.value as Map<dynamic, dynamic>;
                              referenceGlobal.child("Categories").child(itemIds[0]).child("childCategories").child(itemIds[1]).child("item").child("variants").child(itemIds[2]).update({
                                "${itemIds[3]}Stock" : (int.parse(tempData["${itemIds[3]}Stock"].toString())) - elements.quantity
                              });
                              
                            }

                            String orderId = generateRandomString();
                            final event = await referenceGlobal.child("Id").once(DatabaseEventType.value);
                            List tempData = List.from(event.snapshot.value as List);

                            while (true) {
                              if (tempData.contains(orderId)) {
                                orderId = generateRandomString();
                              } else {
                                tempData.add(orderId);
                                break;
                              }
                            }

                            referenceGlobal.update({
                              "Id" : tempData
                            });



                            referenceGlobal.child("users").child(currentUser.firebaseId).child("orders").update({
                              key : {
                                "items": tempItems,
                                "orderedOn" : DateFormat.yMEd().add_jms().format(DateTime.now()),
                                "status" : "Ordered",
                                "total" : widget.totalPrice,
                                "orderId" : orderId

                              }
                            });

                            if (usedPromoCodes.isNotEmpty) {
                              final event = await referenceGlobal.once(DatabaseEventType.value);
                              Map firebaseData = event.snapshot.value as Map<dynamic, dynamic>;

                              List<dynamic> tempPromos = List.of(firebaseData["users"][currentUser.firebaseId]["promoCodes"]);

                              if (tempPromos.contains(usedPromoCodes[0].firebaseId)) {
                                tempPromos.remove(usedPromoCodes[0].firebaseId);
                              }

                              referenceGlobal.child("users").child(currentUser.firebaseId).child("promoCodes").set(tempPromos);
                              promoCodes.remove(promoCodes[promoCodes.indexWhere((element) => element.firebaseId == usedPromoCodes[0].firebaseId)]);
                              currentUser.promoCodes.remove(usedPromoCodes[0].name);
                              usedPromoCodes = [];
                            }
                            setState(() {
                              orderText = "Place Order";
                            });

                            Navigator.push(
                                context, MaterialPageRoute(builder: (_) => const OrderConfirmed()));

                          },
                          style: ElevatedButton.styleFrom(backgroundColor: brandGreen),
                          child: Text(
                            orderText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 120,),
                  ],
                ),
              ),
              const SizedBox(height: 60,),
            ],
          ),
          // const NavigationsBar(idScreen: "cart"),
        ],
      ),
    );
  }

  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}
