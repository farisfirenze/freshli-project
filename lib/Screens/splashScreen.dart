import 'package:flutter/material.dart';
import 'package:freshli_delivery/Models/offerItem.dart';
import 'package:freshli_delivery/Models/promoCodeAmount.dart';
import 'package:freshli_delivery/Data/globalVariables.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:freshli_delivery/Screens/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/Item.dart';
import '../Models/category.dart';
import '../Models/childCategory.dart';
import '../Models/order.dart';
import '../Models/promoCodeItem.dart';
import '../Models/user.dart';
import 'homeScreen.dart';

class SplashScreen extends StatefulWidget {
  static String idScreen = "splash";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool loaded = false;



  updateItemDetails() async{

    // String id = referenceGlobal.child("OfferItems").push().key!;
    //
    // Map<String, Object> map = {
    //   id : {
    //     "itemIdentifier" : [
    //       "-NNGr2OxAAwSo99Be4-G<sep>-NNGr2Oyo_a3kZb63JA0<sep>Limited time offer on Hamoor Grouper. Check it out before the offer expires.",
    //       "-NNGrmx9pUO2RdbHSfb8<sep>-NNGrmxBBUdeDw9V0nO0<sep>Limited time offer on Red Snapper Type 2. Check it out before the offer expires.",
    //       "-NNGsMvXRVR7MyHZEeef<sep>-NO8hfNU5m4CfddGiw9I<sep>Limited time offer on Naran Fish. Check it out before the offer expires.",
    //     ],
    //     "heading" : "Limited Promotions",
    //   }
    // };
    //
    // referenceGlobal.child("OfferItems").update(map);

    final event = await referenceGlobal.once(DatabaseEventType.value);
    Map firebaseData = event.snapshot.value as Map<dynamic, dynamic>;

    if (firebaseData.containsKey("Categories")) {
      for (var catElements in firebaseData["Categories"].entries){
        List<ChildCategory> tempChildCategoryList = [];
        if (catElements.value.containsKey("childCategories")) {
          for (var childCatElements in catElements.value["childCategories"].entries) {
            // print(childCatElements.value["item"].entries);
            Map<dynamic, dynamic> tempVariants = {};
            if (childCatElements.value.containsKey("item")) {
              if (childCatElements.value["item"].containsKey("variants")) {
                for (var variants in childCatElements.value["item"]["variants"].entries) {
                  tempVariants.addAll(
                      {
                        variants.key : {
                          "name" : variants.value["name"],
                          "cleanImage" : variants.value["cleanImage"],
                          "wholeImage" : variants.value["wholeImage"],
                          "cleanValue" : variants.value["cleanValue"].toDouble(),
                          "wholeValue" : variants.value["wholeValue"].toDouble(),
                          "wholeStock" : variants.value["wholeStock"],
                          "cleanStock" : variants.value["cleanStock"],
                        }
                      }
                  );
                }
              } else {
                tempVariants.addAll(
                    {

                    }
                );
              }
              Item item = Item(
                imageUrl: childCatElements.value["item"]["imageUrl"],
                description: childCatElements.value["item"]["description"],
                variants: tempVariants,
                wholeCleaned: childCatElements.value["item"]["wholeCleaned"] as bool,
                wholeName: childCatElements.value["item"]["wholeName"],
                cleanName: childCatElements.value["item"]["cleanName"],

              );
              tempChildCategoryList.add(
                  ChildCategory(
                      imageUrl: childCatElements.value["imageUrl"],
                      firebaseId: childCatElements.key,
                      name: childCatElements.value["name"],
                      description: childCatElements.value["description"],
                      item: item
                  )
              );
            }
          }
        }
        tempChildCategoryList.sort((a, b) => a.name.compareTo(b.name));

        categories.add(
            Category(
                imageUrl: catElements.value["imageUrl"],
                firebaseId: catElements.key,
                name: catElements.value["name"],
                description: catElements.value["description"],
                childCategories: tempChildCategoryList
            )
        );
      }
    }

    categories.sort((a, b) => a.name.compareTo(b.name));

    if (firebaseData.containsKey("OfferItems")) {
      for (var offer in firebaseData["OfferItems"].entries) {
        List<String> itemIdentifiers = [];
        if (offer.value.containsKey("itemIdentifier")) {
          for (var items in offer.value["itemIdentifier"]) {
            itemIdentifiers.add(items.toString());
          }
        }

        offerItems.add(
            OfferItem(
                firebaseId: offer.key,
                heading: offer.value["heading"] ?? "",
                itemIdentifier: itemIdentifiers
            )
        );
      }
    }





    setState(() {
      loaded = true;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => updateItemDetails());

    updateItemDetails().whenComplete(() async {

      promoCodes = [];
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey("credentials")) {
        var username = prefs.getStringList('credentials')?.toList()[0];
        var password = prefs.getStringList('credentials')?.toList()[1];

        final event = await referenceGlobal.once(DatabaseEventType.value);
        Map firebaseData = event.snapshot.value as Map<dynamic, dynamic>;

        List<String> promoTemp = [];
        if (firebaseData.containsKey("users")) {
          for (var users in firebaseData["users"].entries) {
            if (users.value["username"].toString().trim() == username) {
              if (users.value["password"].toString().trim() == password) {


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

                  // orders: ordersTemp
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
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        }
      } else {
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: null,
      backgroundColor: brandGreen,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset("assets/images/splash.png", width: 395.0,),
          )

        ],
      ),
    );
  }
}
