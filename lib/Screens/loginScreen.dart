import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:freshli_delivery/Models/order.dart';
import 'package:freshli_delivery/Models/user.dart';
import 'package:freshli_delivery/Screens/homeScreen.dart';
import '../Models/Item.dart';
import '../Models/category.dart';
import '../Models/childCategory.dart';
import '../Models/promoCodeAmount.dart';
import '../Models/promoCodeItem.dart';
import '../Data/globalVariables.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const String idScreen = "login";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  bool validCredentials = true;
  bool _visible = true;
  bool loaded = false;
  bool loginClicked = false;
  TextEditingController username = TextEditingController(text: "");
  TextEditingController password = TextEditingController(text: "");



  Future<void> checkFirebaseAndLoadData(username, password) async{

    promoCodes = [];

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {

        });
      }
    } on SocketException catch (_) {

    }

    setState(() {
      loaded = false;
    });

    final event = await referenceGlobal.once(DatabaseEventType.value);
    Map firebaseData = event.snapshot.value as Map<dynamic, dynamic>;

    bool validCredentialsTemp = false;

    List<String> promoTemp = [];

    if (firebaseData.containsKey("users")) {
      for (var users in firebaseData["users"].entries) {
        if (users.value["username"].toString().trim() == username) {
          if (users.value["password"].toString().trim() == password) {
            setState(() {
              validCredentials = true;
            });
            validCredentialsTemp = true;
            // List<Order> ordersTemp = [];
            if (users.value.containsKey("promoCodes")) {
              for (var promo in users.value["promoCodes"]) {
                promoTemp.add(promo.toString());
              }
            }

            currentUser = User(
                firstName: users.value["firstName"],
                lastName: users.value["lastName"],
                address: users.value["address"],
                landmark: users.value["landmark"],
                personalPhoneNumber: users.value["personalPhoneNumber"],
                phoneNumber: users.value["phoneNumber"],
                restaurantName: users.value["restaurantName"],
                username: users.value["username"],
                password: users.value["password"],
                promoCodes: [],
                firebaseId: users.key
            );

            final prefs = await SharedPreferences.getInstance();
            if (!prefs.containsKey("credentials")) {
              await prefs.setStringList("credentials", [currentUser.username, currentUser.password]);
            }
            break;
          }

        }
      }
    }



    if (!validCredentialsTemp) {
      setState(() {
        validCredentials = false;
        loginClicked = false;
      });

    }

    if (firebaseData.containsKey("PromoCodes")) {
      for (var promoElements in firebaseData["PromoCodes"].entries) {
        if (promoTemp.contains(promoElements.key)) {
          promoCodes.add(
              PromoCodeAmount(
                  name: promoElements.value["name"],
                  offer: promoElements.value["offer"].toDouble(),
                  type: promoElements.value["type"],
                  minAmount: promoElements.value["minAmount"].toDouble(),
                  parentType: promoElements.value["parentType"],
                  description: promoElements.value["description"],
                  imageUrl: promoElements.value["imageUrl"],
                  firebaseId: promoElements.key
              )
          );
          currentUser.promoCodes.add(promoElements.value["name"]);
        }
      }
    }


    if (firebaseData.containsKey("PromoCodeItem")) {
      for (var promoElements in firebaseData["PromoCodeItem"].entries) {
        if (promoTemp.contains(promoElements.key)) {

          List<String> promoTempItems = [];
          for (var items in promoElements.value["itemIdentifier"]) {
            String tempItem = "${items.toString().split("<sep>").sublist(0, 4).join("<sep>")}<sep>${double.parse(items.toString().split("<sep>")[4])}";
            promoTempItems.add(tempItem);
          }
          promoCodes.add(
              PromoCodeItem(
                  name: promoElements.value["name"],
                  offer: promoElements.value["offer"].toDouble(),
                  type: promoElements.value["type"],
                  minAmount: promoElements.value["minAmount"].toDouble(),
                  parentType: promoElements.value["parentType"],
                  itemIdentifier: promoTempItems,
                  description: promoElements.value["description"],
                  imageUrl: promoElements.value["imageUrl"],

                  firebaseId: promoElements.key
              )
          );
          currentUser.promoCodes.add(promoElements.value["name"]);
        }

      }
    }


    setState(() {
      loaded = true;
    });

    if(validCredentialsTemp) {
      setState(() {
        loginClicked = false;
      });

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
        displayToastMessage("Logged In. Welcome ${currentUser.firstName}", context);
      }

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: brandGreen,
              ),

              Column(
                children: [
                  const TopSginin(),

                  const SizedBox(height: 20.0,),
                  Expanded(
                    child: ListView(
                      physics: const ScrollPhysics(),
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: whiteshade,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(45),
                                bottomLeft: Radius.circular(45),
                              )
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: Center(
                                  child: SizedBox(
                                      height: MediaQuery.of(context).size.height / 6,
                                      child: Image.asset("assets/images/logo_white.png"),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      bottom: 10,
                                    ),
                                    child: const Text(
                                      "Username",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "AwanZaman"),
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(left: 20, right: 20),
                                      decoration: BoxDecoration(
                                        color: grayshade.withOpacity(0.5),
                                        // border: Border.all(
                                        //   width: 1,
                                        // ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                        child: TextField(
                                          scrollPadding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context).viewInsets.bottom + 15*4),
                                          decoration: const InputDecoration(
                                            hintText: "Username",
                                            border: InputBorder.none,

                                          ),
                                          controller: username,
                                        ),
                                      )
                                    //IntrinsicHeight

                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      bottom: 10,
                                    ),
                                    child: const Text(
                                      "Password",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "AwanZaman"),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 20, right: 20),
                                    decoration: BoxDecoration(
                                      color: grayshade.withOpacity(0.5),
                                      // border: Border.all(
                                      //   width: 1,
                                      // ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                      child: TextField(
                                        obscureText: _visible,
                                        controller: password,
                                        decoration: InputDecoration(
                                          hintText: "At least 8 Charecter",
                                          border: InputBorder.none,
                                          suffixIcon: IconButton(
                                              icon: Icon(
                                                _visible ? Icons.visibility : Icons.visibility_off,
                                                color: brandGreen,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _visible = !_visible;
                                                });
                                              }
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              InkWell(
                                onTap: () async{
                                  setState(() {
                                    loginClicked = true;
                                  });

                                  await checkFirebaseAndLoadData(username.text.toString().trim(), password.text.toString().trim());


                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height * 0.07,
                                  margin: const EdgeInsets.only(left: 20, right: 20),
                                  decoration: BoxDecoration(
                                      color: brandGreen,
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(10))),
                                  child: Center(
                                    child: !loginClicked ? Text(
                                      "Log in",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "AwanZaman",
                                          color: whiteshade
                                      ),
                                    ) : CircularProgressIndicator(color: whiteshade,),
                                  ),
                                ),
                              ),
                              validCredentials ? Container() : Center(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 50,
                                  ),
                                  child: const Text(
                                    "Username and password incorrect!",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "AwanZaman"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Text(
                    "Freshli Delivery v1.0 Build 20230206",
                    style: TextStyle(
                        color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: "AwanZaman"),
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}

class TopSginin extends StatelessWidget {
  const TopSginin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 15,
          ),
          Text(
            "Log In",
            style: TextStyle(color: whiteshade, fontSize: 25, fontWeight: FontWeight.bold, fontFamily: "AwanZaman"),
          )
        ],
      ),
    );
  }
}