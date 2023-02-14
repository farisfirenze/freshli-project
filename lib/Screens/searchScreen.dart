import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freshli_delivery/Screens/itemScreen.dart';
import 'package:freshli_delivery/Widgets/navigationBar.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../Widgets/Divider.dart';
import '../Data/globalVariables.dart';

class SearchScreen extends StatefulWidget {
  static const String idScreen = "search";
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  List<Map<dynamic, dynamic>> itemList = [];
  TextEditingController searchTextEditingController = TextEditingController(text: "");

  void updateSearchList(val) {

    List<Map<dynamic, dynamic>> tempItemList = [];

    for (var category in categories) {
      for (var childCategory in category.childCategories) {
        List<double> priceRange = [];
        if ((category.name.toString() + childCategory.name.toString()).toLowerCase().contains(val.toLowerCase())) {
          for(var item in childCategory.item.variants.entries) {
            priceRange.add(item.value["wholeValue"]);
            priceRange.add(item.value["cleanValue"]);
          }
          priceRange.removeWhere((double element) => element == 0.0);
          tempItemList.add({
          "category" : category,
          "childCategory" : childCategory,
          "priceRange" : "\u{20B9} ${priceRange.reduce(min)} to \u{20B9} ${priceRange.reduce(max)}"
          });
        }
      }
    }
    print(tempItemList);

    if (val == "") {
      tempItemList = [];
    }

    setState(() {
      itemList = tempItemList;
    });
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
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                const SizedBox(height: 140.0,),

                ListView.builder(
                    shrinkWrap: true,
                    itemCount: itemList.length,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index){
                      return GestureDetector(
                        onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ItemScreen(category: itemList[index]["category"], childCategory: itemList[index]["childCategory"])));

                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: CachedNetworkImage(
                                        imageUrl: itemList[index]["childCategory"].imageUrl,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${itemList[index]["category"].name} - ${itemList[index]["childCategory"].name}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 20.0,
                                                  fontFamily: "Candarai"
                                              ),
                                            ),
                                            Text(
                                              "Price range: ${itemList[index]["priceRange"]}",
                                              style: const TextStyle(
                                                color: Color(0xFF3F3F42),
                                                fontSize: 17.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10.0,),
                              DividerWidget(customColor: Colors.green,),
                            ],
                          ),
                        ),
                      );
                    }
                ),

                const SizedBox(height: 80.0,),

              ],
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: 0.0,
            child: Container(
              height: 140.0,
              decoration: BoxDecoration(
                color: brandGreen,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: SizedBox(
                                  width: 200,
                                  child: Text(
                                    currentUser.restaurantName,
                                    style: const TextStyle(fontSize: 20.0, fontFamily: "AwanZaman", color: Colors.white, fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, right: 20),
                            child: Image.asset(
                              "assets/images/logo.png",
                              height: 60,
                              width: 60,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: GestureDetector(
                        onTap: (){

                        },
                        child : Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                              ),
                            ],
                          ),
                          height: 35.0,
                          width: double.infinity,
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: const BorderRadius.all(Radius.circular(25)),
                            ),
                            child: TextField(
                              onChanged: (val) {
                                if (val.trim() == "") {
                                  print("EPTY");
                                  setState(() {
                                    itemList = [];
                                  });
                                }
                                updateSearchList(val);
                              },
                              autofocus: true,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                border: InputBorder.none,
                                hintText: "Search",
                              ),
                            ),
                          )
                        ),

                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),

          const NavigationsBar(idScreen: "search"),
        ],
      ),
    );
  }
}
