import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freshli_delivery/Models/childCategory.dart';
import 'package:freshli_delivery/Models/order.dart';
import 'package:freshli_delivery/Widgets/priceBar.dart';
import 'package:freshli_delivery/Data/globalVariables.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/category.dart';
import '../Widgets/navigationBar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ItemScreen extends StatefulWidget {

  static const String idScreen = "item";

  final Category category;
  final ChildCategory childCategory;

  const ItemScreen({super.key,
    required this.category,
    required this.childCategory
  });

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {


  Map<String, List> quantity = {};
  bool wholeValue = true;
  bool cleanValue = false;
  bool stockRetrieved = false;
  int totalQuantity = 0;
  double totalPrice = 0;
  List<Map<String, bool>> promoUsed = [];
  List<Category> categoriesTemp = [];
  List<Order> orders = [];
  Map variantsData = {};
  Map<dynamic, dynamic> orderMap = {};


  final _textFieldFocus = FocusNode();

  late final TextEditingController promoCodeController = TextEditingController(text: "");

  void getStockCount() async {

    setState(() {
      stockRetrieved = false;
    });

    final event = await referenceGlobal.child("Categories").child(widget.category.firebaseId).child("childCategories").child(widget.childCategory.firebaseId).child("item").child("variants").once(DatabaseEventType.value);
    setState(() {
      variantsData = event.snapshot.value as Map<dynamic, dynamic>;
    });

    
    setState(() {
      stockRetrieved = true;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(discountGlobal);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    getStockCount();
    quantity = {
      "whole": List<int>.generate(
          widget.childCategory.item.variants.length, (i) => 0),
      "cleaned": List<int>.generate(
          widget.childCategory.item.variants.length, (i) => 0)
    };
    // widget.childCategory.forEach((map) => promoUsed[map.firebaseId] = false));
    setState(() {
      categoriesTemp = categories;
    });
    // print(quantity);
    // print(widget.childCategory.item.variants[widget.childCategory.item.variants.values.toList()[1]]);
    // quantity = [0] * widget.childCategory.item.variants.length;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.childCategory.item.imageUrl,
                          placeholder: (context, url) => Image.asset("assets/images/fish.gif"),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          fit: BoxFit.fitWidth,

                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_circle_left_sharp,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.favorite_border_outlined,
                              size: 30,
                            ),
                            onPressed: () {
                              // handle favorite icon press
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              "${widget.category.name.toUpperCase()} - ${widget.childCategory.name.toUpperCase()}" ,
                              style: const TextStyle(
                                fontSize: 20.0, fontFamily: "AwanZaman", color: Colors.black, fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              widget.childCategory.item.description,
                              style: const TextStyle(
                                fontSize: 13.0, fontFamily: "AwanZaman", color: Colors.black, fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        //Text
                        widget.childCategory.item.wholeCleaned ? Row(
                          children: [ //Text
                            const SizedBox(width: 10), //SizedBox
                            /** Checkbox Widget **/
                            Checkbox(
                              value: wholeValue,
                              onChanged: (bool? wholeValue) {
                                setState(() {
                                  if (!this.wholeValue){
                                    this.wholeValue = wholeValue!;
                                    cleanValue = !cleanValue;
                                  }

                                });
                              },
                            ),
                            Text(
                              widget.childCategory.item.wholeName,
                              style: const TextStyle(
                                fontSize: 18.0, fontFamily: "AwanZaman", color: Colors.black, fontWeight: FontWeight.w500,
                              ),
                            ),
                            Checkbox(
                              value: cleanValue,
                              onChanged: (bool? cleanValue) {
                                setState(() {
                                  if (!this.cleanValue) {
                                    this.cleanValue = cleanValue!;
                                    wholeValue = !wholeValue;
                                  }
                                });
                              },
                            ),
                            Text(
                              widget.childCategory.item.cleanName,
                              style: const TextStyle(
                                fontSize: 18.0, fontFamily: "AwanZaman", color: Colors.black, fontWeight: FontWeight.w500,
                              ),
                            ),//Checkbox
                          ], //<Widget>[]
                        ) : Container(), //Row
                      ],
                    ), //C
                    DefaultTabController(
                      length: 1,
                      child: Column(
                        children: [
                          TabBar(
                            indicatorColor: brandGreen,
                            tabs: [
                              Tab(
                                child: Text(
                                  'Customize',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: brandGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 190.0 * widget.childCategory.item.variants.keys.length,
                            child: TabBarView(children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: Column(
                                  children: [
                                    for(var k=0; k<widget.childCategory.item.variants.length; k++)
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10.0),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xffececec),
                                                blurRadius: 10,
                                                spreadRadius: 1,
                                                offset: Offset(0, 0),
                                              ),
                                            ],
                                          ),
                                          child: Card(
                                            child: Container(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(0),
                                                          child: (widget.childCategory.item.variants[widget.childCategory.item.variants.keys.toList()[k]]["name"].toString().contains("/")) ? Text(
                                                            "${widget.childCategory.item.variants[widget.childCategory.item.variants.keys.toList()[k]]["name"]}",
                                                            style: const TextStyle(
                                                              fontSize: 18.0, fontFamily: "AwanZaman", color: Colors.black, fontWeight: FontWeight.w500,
                                                            ),
                                                          ) : Text(
                                                            "${widget.childCategory.item.variants[widget.childCategory.item.variants.keys.toList()[k]]["name"]}",
                                                            style: const TextStyle(
                                                              fontSize: 18.0, fontFamily: "AwanZaman", color: Colors.black, fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 10.0),
                                                          child: wholeValue ? Text(
                                                            "\u{20B9} ${widget.childCategory.item.variants[widget.childCategory.item.variants.keys.toList()[k]]["wholeValue"]} / Kg",
                                                            style: const TextStyle(
                                                              fontSize: 20.0, fontFamily: "AwanZaman", color: Colors.teal, fontWeight: FontWeight.w500,
                                                            ),
                                                          ) : Text(
                                                            "\u{20B9} ${widget.childCategory.item.variants[widget.childCategory.item.variants.keys.toList()[k]]["cleanValue"]} / Kg",
                                                            style: const TextStyle(
                                                              fontSize: 20.0, fontFamily: "AwanZaman", color: Colors.teal, fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        stockRetrieved ? wholeValue ? variantsData[widget.childCategory.item.variants.keys.toList()[k]]["wholeStock"] < 10 ? variantsData[widget.childCategory.item.variants.keys.toList()[k]]["wholeStock"] == 0 ? const Padding(
                                                          padding: EdgeInsets.all(8.0),
                                                          child: Text(
                                                            "Out Of Stock",
                                                            style: TextStyle(
                                                              fontSize: 20.0, fontFamily: "AwanZaman", color: Colors.red, fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ) : Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text(
                                                            "Only ${variantsData[widget.childCategory.item.variants.keys.toList()[k]]["wholeStock"]} left",
                                                            style: const TextStyle(
                                                              fontSize: 20.0, fontFamily: "AwanZaman", color: Colors.redAccent, fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ) : Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text(
                                                            "Available",
                                                            style: TextStyle(
                                                              fontSize: 20.0, fontFamily: "AwanZaman", color: brandGreen, fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ) : variantsData[widget.childCategory.item.variants.keys.toList()[k]]["cleanStock"] < 10 ? variantsData[widget.childCategory.item.variants.keys.toList()[k]]["cleanStock"] == 0 ? const Padding(
                                                          padding: EdgeInsets.all(8.0),
                                                          child: Text(
                                                            "Out Of Stock",
                                                            style: TextStyle(
                                                              fontSize: 20.0, fontFamily: "AwanZaman", color: Colors.red, fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ) : Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text(
                                                            "Only ${variantsData[widget.childCategory.item.variants.keys.toList()[k]]["cleanStock"]} left",
                                                            style: const TextStyle(
                                                              fontSize: 20.0, fontFamily: "AwanZaman", color: Colors.redAccent, fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ) : Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text(
                                                            "Available",
                                                            style: TextStyle(
                                                              fontSize: 20.0, fontFamily: "AwanZaman", color: brandGreen, fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ) : Container(),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      Stack(
                                                          children: [
                                                            Image.network(
                                                              widget.childCategory.item.imageUrl,
                                                              width: 200,
                                                              height: 100,
                                                              fit: BoxFit.fitWidth,
                                                            ),
                                                          ]
                                                      ),
                                                      stockRetrieved ? wholeValue ? variantsData[widget.childCategory.item.variants.keys.toList()[k]]["wholeStock"] != 0 ? Container(
                                                          height: 40,
                                                          width: 200,
                                                          alignment: Alignment.center,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              primary: Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(5),
                                                                side: BorderSide(color: brandGreen, width: 2),
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                IconButton(
                                                                  icon: Icon(Icons.remove, color: brandGreen,),
                                                                  onPressed: () async{
                                                                    setState(() {
                                                                      if (wholeValue) {
                                                                        if(quantity["whole"]![k] > 0) {
                                                                          quantity["whole"]![k]--;
                                                                          totalPrice -= widget.childCategory.item.variants[widget.childCategory.item.variants.keys.toList()[k]]["wholeValue"];
                                                                          totalQuantity--;
                                                                          String keyName = "${widget.category.firebaseId}<sep>${widget.childCategory.firebaseId}<sep>${widget.childCategory.item.variants.keys.toList()[k]}<sep>whole<sep>${widget.childCategory.item.variants[widget.childCategory.item.variants.keys.toList()[k]]["wholeValue"].toDouble()}";
                                                                          if (globalOrder.containsKey(keyName)){
                                                                            if (globalOrder[keyName] > 0) {
                                                                              globalOrder[keyName]--;
                                                                            }
                                                                          }
                                                                        }
                                                                      } else {
                                                                        if(quantity["cleaned"]![k] > 0) {
                                                                          quantity["cleaned"]![k]--;
                                                                          totalPrice -= widget.childCategory.item.variants[widget.childCategory.item.variants.keys.toList()[k]]["cleanValue"];
                                                                          totalQuantity--;
                                                                          String keyName = "${widget.category.firebaseId}<sep>${widget.childCategory.firebaseId}<sep>${widget.childCategory.item.variants.keys.toList()[k]}<sep>clean<sep>${widget.childCategory.item.variants[widget.childCategory.item.variants.keys.toList()[k]]["cleanValue"].toDouble()}";
                                                                          if (globalOrder.containsKey(keyName)){
                                                                            if (globalOrder[keyName] > 0) {
                                                                              globalOrder[keyName]--;
                                                                            }
                                                                          }
                                                                        }
                                                                      }

                                                                    });
                                                                    final prefs = await SharedPreferences.getInstance();

                                                                    await prefs.setString("orders", jsonEncode(globalOrder));

                                                                  },
                                                                ),
                                                                wholeValue ? Text("${quantity["whole"]![k]}", style: TextStyle(color: brandGreen),) : Text("${quantity["cleaned"]![k]}", style: const TextStyle(color: Colors.green),),
                                                                IconButton(
                                                                  icon: Icon(Icons.add, color: brandGreen,),
                                                                  onPressed: () async {
                                                                    setState(() {
                                                                      if (wholeValue) {
                                                                        quantity["whole"]![k]++;
                                                                        totalPrice += widget.childCategory.item.variants[widget.childCategory.item.variants.keys.toList()[k]]["wholeValue"];
                                                                        totalQuantity++;
                                                                        String keyName = "${widget.category.firebaseId}<sep>${widget.childCategory.firebaseId}<sep>${widget.childCategory.item.variants.keys.toList()[k]}<sep>whole<sep>${widget.childCategory.item.variants[widget.childCategory.item.variants.keys.toList()[k]]["wholeValue"].toDouble()}";
                                                                        if (globalOrder.containsKey(keyName)){
                                                                          globalOrder[keyName]++;
                                                                        } else {
                                                                          globalOrder[keyName] = 1;
                                                                        }
                                                                      } else {
                                                                        quantity["cleaned"]![k]++;
                                                                        totalPrice += widget.childCategory.item.variants[widget.childCategory.item.variants.keys.toList()[k]]["cleanValue"];
                                                                        totalQuantity++;
                                                                        String keyName = "${widget.category.firebaseId}<sep>${widget.childCategory.firebaseId}<sep>${widget.childCategory.item.variants.keys.toList()[k]}<sep>clean<sep>${widget.childCategory.item.variants[widget.childCategory.item.variants.keys.toList()[k]]["cleanValue"].toDouble()}";
                                                                        if (globalOrder.containsKey(keyName)){
                                                                          globalOrder[keyName]++;
                                                                        } else {
                                                                          globalOrder[keyName] = 1;
                                                                        }
                                                                      }
                                                                    });


                                                                    final prefs = await SharedPreferences.getInstance();

                                                                    await prefs.setString("orders", jsonEncode(globalOrder));

                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                            onPressed: () {},
                                                          )


                                                      ) : Container() : variantsData[widget.childCategory.item.variants.keys.toList()[k]]["cleanStock"] != 0 ? Container(
                                                          height: 40,
                                                          width: 200,
                                                          alignment: Alignment.center,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              primary: Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(5),
                                                                side: BorderSide(color: brandGreen, width: 2),
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                IconButton(
                                                                  icon: Icon(Icons.remove, color: brandGreen,),
                                                                  onPressed: () async{
                                                                    setState(() {
                                                                      if (wholeValue) {
                                                                        if(quantity["whole"]![k] > 0) {
                                                                          quantity["whole"]![k]--;
                                                                          totalPrice -= widget.childCategory.item.variants[widget.childCategory.item.variants.keys.toList()[k]]["wholeValue"];
                                                                          totalQuantity--;
                                                                          String keyName = "${widget.category.firebaseId}<sep>${widget.childCategory.firebaseId}<sep>${widget.childCategory.item.variants.keys.toList()[k]}<sep>whole<sep>${widget.childCategory.item.variants[widget.childCategory.item.variants.keys.toList()[k]]["wholeValue"].toDouble()}";
                                                                          if (globalOrder.containsKey(keyName)){
                                                                            if (globalOrder[keyName] > 0) {
                                                                              globalOrder[keyName]--;
                                                                            }
                                                                          }
                                                                        }
                                                                      } else {
                                                                        if(quantity["cleaned"]![k] > 0) {
                                                                          quantity["cleaned"]![k]--;
                                                                          totalPrice -= widget.childCategory.item.variants[widget.childCategory.item.variants.keys.toList()[k]]["cleanValue"];
                                                                          totalQuantity--;
                                                                          String keyName = "${widget.category.firebaseId}<sep>${widget.childCategory.firebaseId}<sep>${widget.childCategory.item.variants.keys.toList()[k]}<sep>clean<sep>${widget.childCategory.item.variants[widget.childCategory.item.variants.keys.toList()[k]]["cleanValue"].toDouble()}";
                                                                          if (globalOrder.containsKey(keyName)){
                                                                            if (globalOrder[keyName] > 0) {
                                                                              globalOrder[keyName]--;
                                                                            }
                                                                          }
                                                                        }
                                                                      }

                                                                    });
                                                                    final prefs = await SharedPreferences.getInstance();

                                                                    await prefs.setString("orders", jsonEncode(globalOrder));

                                                                  },
                                                                ),
                                                                wholeValue ? Text("${quantity["whole"]![k]}", style: TextStyle(color: brandGreen),) : Text("${quantity["cleaned"]![k]}", style: const TextStyle(color: Colors.green),),
                                                                IconButton(
                                                                  icon: Icon(Icons.add, color: brandGreen,),
                                                                  onPressed: () async {
                                                                    setState(() {
                                                                      if (wholeValue) {
                                                                        quantity["whole"]![k]++;
                                                                        totalPrice += widget.childCategory.item.variants[widget.childCategory.item.variants.keys.toList()[k]]["wholeValue"];
                                                                        totalQuantity++;
                                                                        String keyName = "${widget.category.firebaseId}<sep>${widget.childCategory.firebaseId}<sep>${widget.childCategory.item.variants.keys.toList()[k]}<sep>whole<sep>${widget.childCategory.item.variants[widget.childCategory.item.variants.keys.toList()[k]]["wholeValue"].toDouble()}";
                                                                        if (globalOrder.containsKey(keyName)){
                                                                          globalOrder[keyName]++;
                                                                        } else {
                                                                          globalOrder[keyName] = 1;
                                                                        }
                                                                      } else {
                                                                        quantity["cleaned"]![k]++;
                                                                        totalPrice += widget.childCategory.item.variants[widget.childCategory.item.variants.keys.toList()[k]]["cleanValue"];
                                                                        totalQuantity++;
                                                                        String keyName = "${widget.category.firebaseId}<sep>${widget.childCategory.firebaseId}<sep>${widget.childCategory.item.variants.keys.toList()[k]}<sep>clean<sep>${widget.childCategory.item.variants[widget.childCategory.item.variants.keys.toList()[k]]["cleanValue"].toDouble()}";
                                                                        if (globalOrder.containsKey(keyName)){
                                                                          globalOrder[keyName]++;
                                                                        } else {
                                                                          globalOrder[keyName] = 1;
                                                                        }
                                                                      }
                                                                    });


                                                                    final prefs = await SharedPreferences.getInstance();

                                                                    await prefs.setString("orders", jsonEncode(globalOrder));

                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                            onPressed: () {},
                                                          )


                                                      ) : Container() : Container(),
                                                    ],
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ]),
                          ),

                          const SizedBox(height: 30,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),


              PriceBar(idScreen: "item", price: totalPrice, id: '', quantity: totalQuantity),
              const SizedBox(height: 70.0,),
            ],
          ),

            const NavigationsBar(idScreen: "item"),
          ],
        ),

      ),
    );
  }
  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}