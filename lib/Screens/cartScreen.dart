import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshli_delivery/Models/childCategory.dart';
import 'package:freshli_delivery/Screens/checkoutScreen.dart';
import 'package:freshli_delivery/Screens/itemScreen.dart';
import 'package:freshli_delivery/Widgets/navigationBar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/category.dart';
import '../Models/order.dart';
import '../Widgets/Divider.dart';
import '../Data/globalVariables.dart';
import 'package:firebase_database/firebase_database.dart';

class CartScreen extends StatefulWidget {
  static const String idScreen = "cart";
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  TextEditingController promoCodeController = TextEditingController(text: "");
  List<Order> orders = [];
  double subTotal = 0.0;
  double discount = 0.0;
  double deliveryCharge = 0.0;
  double totalPrice = 0.0;
  String statusText = "Proceed to Checkout";
  String promoCodeButtonText = "Apply";


  Future<Map> getStockCount(String categoryId, String childCategoryId, String variantId) async {

    Map<dynamic, dynamic> variantsData = {};

    final event = await referenceGlobal.child("Categories").child(categoryId).child("childCategories").child(childCategoryId).child("item").child("variants").child(variantId).once(DatabaseEventType.value);

    variantsData = event.snapshot.value as Map<dynamic, dynamic>;

    return variantsData;

  }

  Future<void> updateOrderList() async{
    orders = [];
    subTotal = 0.0;
    discount = 0.0;
    deliveryCharge = 0.0;
    // totalPrice = 0.0;

    final prefs = await SharedPreferences.getInstance();

    if (globalOrder.isEmpty) {
      if (prefs.containsKey("orders")) {
        globalOrder = jsonDecode(prefs.getString("orders")!);
      }
    }


    // print(prefs.getString("promoCode"));
    // if (prefs.containsKey("promoCode")) {
    //   dynamic promoCode = prefs.getString("promoCode");
    //   print(promoCode);
    //   // usedPromoCodes = [promoCodes[promoCodes.indexWhere((element) => element.name == )]];
    // }

    for(var elements in globalOrder.entries){
      Category targetCategory = categories.firstWhere((map) => map.firebaseId == elements.key.toString().split("<sep>")[0]);
      // print(targetCategory.name);
      ChildCategory targetChildCategory = targetCategory.childCategories.firstWhere((map) => map.firebaseId == elements.key.toString().split("<sep>")[1]);
      // print(targetChildCategory.name);
      // print(targetChildCategory.item.variants);
      // print(elements.key.toString().split("<sep>")[2]);
      setState(() {
        orders.add(
            Order(
                category: targetCategory,
                childCategory: targetChildCategory,
                itemIdentifierString: elements.key.toString(),
                item: targetChildCategory.item.variants[elements.key.toString().split("<sep>")[2]]["name"] + " - " + elements.key.toString().split("<sep>")[3],
                price: targetChildCategory.item.variants[elements.key.toString().split("<sep>")[2]]["${elements.key.toString().split("<sep>")[3]}Value"],
                quantity: elements.value
            )
        );

        subTotal += targetChildCategory.item.variants[elements.key.toString().split("<sep>")[2]]["${elements.key.toString().split("<sep>")[3]}Value"] * elements.value;
      });
    }

    if (usedPromoCodes.isNotEmpty) {
      dynamic selectedPromoCode = promoCodes[promoCodes.indexWhere((element) => element.name == usedPromoCodes[0].name.toUpperCase())];

      if (selectedPromoCode.parentType == "amount") {
        setState(() {
          if (subTotal >= selectedPromoCode.minAmount) {
            if (selectedPromoCode.type == "amount") {
              setState(() {
                discount = selectedPromoCode.offer;
              });
            } else {
              setState(() {
                discount = (subTotal * selectedPromoCode.offer);
              });
            }
          } else {
            setState(() {
              discount = 0.0;
            });
            usedPromoCodes = [];
          }
        });
      } else {
        print(selectedPromoCode.itemIdentifier);
        print(globalOrder.keys.toList());

        double tempTotal = 0.0;

        for (var item in selectedPromoCode.itemIdentifier) {
          if (globalOrder.keys.toList().contains(item)) {
            tempTotal += globalOrder[item] * double.parse(item.split("<sep>")[4]);
          }
        }

        print(tempTotal);

        if (tempTotal >= selectedPromoCode.minAmount) {

          if (selectedPromoCode.type == "amount") {
            setState(() {
              discount += selectedPromoCode.offer;
            });
          } else {
            setState(() {
              discount += (tempTotal * selectedPromoCode.offer);
            });
          }

          setState(() {
            totalPrice = subTotal - discount + deliveryCharge;
          });
        } else {
          setState(() {
            discount = 0.0;
          });
          usedPromoCodes = [];
        }

      }
    }

    setState(() {
      totalPrice = subTotal - discount + deliveryCharge;
    });

    if (orders.isEmpty){
      setState(() {

      });
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateOrderList();
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
                    orders.isEmpty ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/emptycartnobg.gif",
                          ),
                          const SizedBox(height: 10.0,),
                          Text("Oh no! Your cart is empty", style: TextStyle(color: brandGreen, fontWeight: FontWeight.bold, fontFamily: "AwanZaman", fontSize: 20.0),),
                        ],
                      ),
                    ) : Container(),
                    for (var i=0; i<orders.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ItemScreen(category: orders[i].category, childCategory: orders[i].childCategory)));
                                },
                                child: Container(
                                  height: 150,
                                  width: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        orders[i].childCategory.imageUrl,
                                      ),
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0, bottom: 10.0),
                                    child: GestureDetector(
                                      onTap: () async{
                                        globalOrder.remove(orders[i].itemIdentifierString);
                                        final prefs = await SharedPreferences.getInstance();

                                        await prefs.setString("orders", jsonEncode(globalOrder));
                                        updateOrderList();
                                      },
                                      child: const Icon(
                                        Icons.highlight_remove_sharp,
                                        color: Colors.red,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 30.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${orders[i].category.name} - ${orders[i].childCategory.name}",
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        SizedBox(
                                          height: 10.0,
                                          child: Text(
                                            orders[i].item.toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 10.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          "\u{20B9} ${orders[i].price}",
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Container(
                                            height: 30,
                                            width: 140,
                                            alignment: Alignment.center,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(color: brandGreen, width: 2),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.remove,
                                                      color: brandGreen,
                                                      size: 15,
                                                    ),
                                                    onPressed: () async{

                                                      String keyName = orders[i].itemIdentifierString;
                                                      if (globalOrder[keyName] > 1) {
                                                        globalOrder[keyName]--;
                                                      } else {
                                                        globalOrder.remove(keyName);

                                                      }
                                                      // if (usedPromoCodes.isNotEmpty) {
                                                      //   dynamic selectedPromoCode = promoCodes[promoCodes.indexWhere((element) => element.name == usedPromoCodes[0].name.toUpperCase())];
                                                      //   if (subTotal < usedPromoCodes[0].minAmount){
                                                      //     setState(() {
                                                      //       discount = 0.0;
                                                      //       usedPromoCodes = [];
                                                      //     });
                                                      //   }
                                                      // }

                                                      final prefs = await SharedPreferences.getInstance();

                                                      await prefs.setString("orders", jsonEncode(globalOrder));
                                                      updateOrderList();

                                                    },
                                                  ),
                                                  Text(orders[i].quantity.toString(), style: TextStyle(color: brandGreen),),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.add,
                                                      color: brandGreen,
                                                      size: 15,
                                                    ),
                                                    onPressed: () async {
                                                      String keyName = orders[i].itemIdentifierString;
                                                      globalOrder[keyName]++;
                                                      // if (usedPromoCodes.isNotEmpty) {
                                                      //   if (subTotal < usedPromoCodes[0].minAmount){
                                                      //     setState(() {
                                                      //       discount = 0.0;
                                                      //       usedPromoCodes = [];
                                                      //     });
                                                      //   }
                                                      // }
                                                      final prefs = await SharedPreferences.getInstance();

                                                      await prefs.setString("orders", jsonEncode(globalOrder));
                                                      updateOrderList();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )


                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DividerWidget(customColor: brandGreen,),
                    ),
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
                                Text("Subtotal", style: TextStyle(color: brandGreen, fontWeight: FontWeight.bold, fontFamily: "AwanZaman")),
                                Text("\u{20B9} ${subTotal.toStringAsFixed(2)}", style: TextStyle(color: brandGreen, fontWeight: FontWeight.bold, fontFamily: "AwanZaman")),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                discount > 0 ? Row(
                                  children: [
                                    Text("Discount (${usedPromoCodes[0].name})", style: TextStyle(color: brandGreen, fontWeight: FontWeight.bold, fontFamily: "AwanZaman"),),
                                    const SizedBox(width: 30.0,),
                                    SizedBox(
                                      height: 20.0,
                                      width: 100.0,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              discount = 0;
                                            });
                                            usedPromoCodes = [];
                                          },
                                          child: const Text("Remove", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "AwanZaman"),
                                          )
                                      ),
                                    ),
                                  ],
                                ) : Text("Discount", style: TextStyle(color: brandGreen, fontWeight: FontWeight.bold, fontFamily: "AwanZaman"),),
                                Text("\u{20B9} ${discount.toStringAsFixed(2)}", style: TextStyle(color: brandGreen, fontWeight: FontWeight.bold, fontFamily: "AwanZaman")),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Delivery Charge", style: TextStyle(color: brandGreen, fontWeight: FontWeight.bold, fontFamily: "AwanZaman")),
                                Text("\u{20B9} ${deliveryCharge.toStringAsFixed(2)}", style: TextStyle(color: brandGreen, fontWeight: FontWeight.bold, fontFamily: "AwanZaman")),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total Price", style: TextStyle(color: brandGreen, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "AwanZaman")),
                                Text("\u{20B9} ${totalPrice.toStringAsFixed(2)}", style: TextStyle(color: brandGreen, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "AwanZaman")),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                // focusNode: _textFieldFocus,
                                controller: promoCodeController,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                  hintText: 'Enter promo code',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              width: 120.0,
                              height: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                              ),
                              child: ElevatedButton(
                                onPressed: () async {

                                  setState(() {
                                    promoCodeButtonText = "Checking...";
                                  });

                                  final eventPromoCodes = await referenceGlobal.child("PromoCodes").once(DatabaseEventType.value);
                                  final eventPromoCodeItem = await referenceGlobal.child("PromoCodeItem").once(DatabaseEventType.value);

                                  Object eventPromoCodesMap = eventPromoCodes.snapshot.value ?? {};
                                  Object eventPromoCodeItemMap = eventPromoCodeItem.snapshot.value ?? {};

                                  List promoCodeList = [];

                                  if (eventPromoCodesMap != null) {
                                    eventPromoCodesMap = eventPromoCodesMap as Map<dynamic, dynamic>;
                                    for(var promo in eventPromoCodesMap.entries) {
                                      promoCodeList.add(promo.value["name"]);
                                    }
                                  }

                                  if (eventPromoCodeItemMap != null) {
                                    eventPromoCodeItemMap = eventPromoCodeItemMap as Map<dynamic, dynamic>;
                                    for(var promoItem in eventPromoCodeItemMap.entries) {
                                      promoCodeList.add(promoItem.value["name"]);
                                    }
                                  }

                                  if (promoCodeList.contains(promoCodeController.text.trim().toUpperCase())){
                                    // if(usedPromoCodes.isNotEmpty) {}
                                    if (usedPromoCodes.isEmpty) {
                                      dynamic selectedPromoCode = promoCodes[promoCodes.indexWhere((element) => element.name == promoCodeController.text.trim().toUpperCase())];
                                      if (selectedPromoCode.parentType == "amount") {
                                        if (subTotal >= selectedPromoCode.minAmount) {
                                          if (selectedPromoCode.type == "amount") {
                                            setState(() {
                                              discount += selectedPromoCode.offer;
                                            });
                                          } else {
                                            setState(() {
                                              discount += (subTotal * selectedPromoCode.offer);
                                            });
                                          }

                                          setState(() {
                                            totalPrice = subTotal - discount + deliveryCharge;
                                          });

                                          usedPromoCodes.add(selectedPromoCode);

                                          displayToastMessage("Applied Promo code : ${promoCodeController.text.trim().toUpperCase()}", context);
                                          // discountGlobal = discount;
                                        } else {
                                          displayToastMessage("Offer not eligible with this amount", context);
                                        }
                                      } else {

                                        double tempTotal = 0.0;

                                        for (var item in selectedPromoCode.itemIdentifier) {
                                          if (globalOrder.keys.toList().contains(item)) {
                                            tempTotal += globalOrder[item] * double.parse(item.split("<sep>")[4]);
                                          }
                                        }

                                        if (tempTotal >= selectedPromoCode.minAmount) {

                                          if (selectedPromoCode.type == "amount") {
                                            setState(() {
                                              discount += selectedPromoCode.offer;
                                            });
                                          } else {
                                            setState(() {
                                              discount += (tempTotal * selectedPromoCode.offer);
                                            });
                                          }

                                          setState(() {
                                            totalPrice = subTotal - discount + deliveryCharge;
                                          });

                                          usedPromoCodes.add(selectedPromoCode);

                                          displayToastMessage("Applied Promo code : ${promoCodeController.text.trim().toUpperCase()}", context);
                                          // discountGlobal = discount;

                                        } else {
                                          displayToastMessage("Offer not eligible with this amount", context);
                                        }

                                      }


                                    } else {
                                      displayToastMessage("Promo code Expired or Invalid.", context);
                                    }


                                  } else {
                                    displayToastMessage("Promo code Expired or Invalid.", context);
                                  }

                                  final prefs = await SharedPreferences.getInstance();

                                  await prefs.setString("promoCode", promoCodeController.text.trim().toUpperCase());

                                  setState(() {
                                    promoCodeButtonText = "Apply";
                                  });

                                },
                                style: ElevatedButton.styleFrom(backgroundColor: brandGreen),
                                child: Text(
                                  promoCodeButtonText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
          Positioned(
            bottom: 90,
            right: 10,
            left: 10,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                color: brandGreen,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        '\u{20B9} ${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontFamily: "AwanZaman",
                            color: Colors.white
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: TextButton(
                        child: Text(
                          statusText,
                          style: const TextStyle(
                              fontSize: 15,
                              fontFamily: "AwanZaman",
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        onPressed: () async {

                          setState(() {
                            statusText = "Checking availability ...";
                          });

                          String unavailableItem = "";

                          for (var elements in globalOrder.entries) {
                            Map variantData = await getStockCount(elements.key.split("<sep>")[0], elements.key.split("<sep>")[1], elements.key.split("<sep>")[2]);

                            print(variantData);

                            if (variantData["${elements.key.split("<sep>")[3]}Stock"] < elements.value) {
                              Category category = orders.firstWhere((e) => e.category.firebaseId == elements.key.split("<sep>")[0]).category;
                              ChildCategory childCategory = category.childCategories.firstWhere((e) => e.firebaseId == elements.key.split("<sep>")[1]);
                              unavailableItem = "${category.name.toUpperCase()} ${childCategory.name.toUpperCase()} ${variantData["name"].toUpperCase()} ${elements.key.split("<sep>")[3].toUpperCase()} not in stock for the specified quantity. Please reduce the quantity or remove the item.";
                              break;

                            }
                          }

                          setState(() {
                            statusText = "Proceed to Checkout";
                          });

                          if (unavailableItem != "") {
                            displayToastMessage(unavailableItem, context);
                          } else {
                            if (globalOrder.isNotEmpty) {
                              if (mounted) {
                                Navigator.push(context, PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 200),
                                  pageBuilder: (context, animation, secondaryAnimation) {
                                    return CheckoutScreen(subtotal: subTotal, discount: discount, deliveryCharge: deliveryCharge, totalPrice: totalPrice, orders: orders);
                                  },
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(1, 0),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    );
                                  },
                                ));
                              }

                            } else {
                              if (mounted) {
                                displayToastMessage("Please add some items to the cart before checking out.", context);

                              }
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const NavigationsBar(idScreen: "cart"),
        ],
      ),
    );
  }


  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}
