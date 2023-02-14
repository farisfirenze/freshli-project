import 'package:flutter/material.dart';
import 'package:freshli_delivery/Screens/itemScreen.dart';
import 'package:freshli_delivery/Screens/searchScreen.dart';
import 'package:freshli_delivery/Widgets/navigationBar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Data/globalVariables.dart';
import 'categoryScreen.dart';

class HomeScreen extends StatefulWidget {
  static const String idScreen = "home";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(currentUser.promoCodes);
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.width ~/ 128);
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
                          Navigator.push(
                              context, MaterialPageRoute(builder: (_) => const SearchScreen()));
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
                          child: Row(
                            children: const [
                              SizedBox(width: 7.0,),
                              Icon(Icons.search, color: Colors.black,),
                              SizedBox(width: 10.0,),
                              Text(
                                "Search",
                              ),
                            ],
                          ),
                        ),

                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 150,),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(left: 30, right: 30, bottom: 10),
                          child: Text(
                            "Offer Items",
                            style: TextStyle(
                              fontSize: 15.0, fontFamily: "AwanZaman", color: Colors.black, fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    currentUser.promoCodes.isNotEmpty ? SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: promoCodes.length,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (_) => ItemScreen(itemId: "")));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: 250,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                        ),
                                        child: CachedNetworkImage(
                                          imageBuilder: (context, imageProvider) => Container(
                                            width: 240,
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ),
                                          imageUrl: promoCodes[index].imageUrl,
                                          placeholder: (context, url) => Image.asset("assets/images/fish.gif"),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                          fit: BoxFit.fitHeight,

                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: SizedBox(
                                        width: 230,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            promoCodes[index].description,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontFamily: "AwanZaman",

                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: SizedBox(
                                        width: 230,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Visit Cart to avail this offer.',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: "AwanZaman",

                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 20.0),
                                      child: SizedBox(
                                        width: 230,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              promoCodes[index].name,
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: brandGreen,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          );
                        },

                      ),
                    ) : const Center(
                      child: Padding(
                        padding: EdgeInsets.all(50.0),
                        child: Text(
                          "Sorry. No offers available for you.",
                          style: TextStyle(
                            fontSize: 15.0, fontFamily: "AwanZaman", color: Colors.black,
                          ),
                        ),
                      ),
                    ),


                    for(var offerItem=0; offerItem<offerItems.length; offerItem++)
                      Column(
                        children: [
                          const SizedBox(height: 20,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
                                child: Text(
                                  offerItems[offerItem].heading,
                                  style: const TextStyle(
                                    fontSize: 15.0, fontFamily: "AwanZaman", color: Colors.black, fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 320,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              children: [
                                for (var offer=0; offer<offerItems[offerItem].itemIdentifier.length; offer++)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 120,
                                      width: 250,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        elevation: 5,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 160,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      categories.firstWhere((element) => element.firebaseId == offerItems[offerItem].itemIdentifier[offer].split("<sep>")[0]).childCategories.firstWhere((element) => element.firebaseId == offerItems[offerItem].itemIdentifier[offer].split("<sep>")[1]).imageUrl
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  "${categories.firstWhere((element) => element.firebaseId == offerItems[offerItem].itemIdentifier[offer].split("<sep>")[0]).name} ${categories.firstWhere((element) => element.firebaseId == offerItems[offerItem].itemIdentifier[offer].split("<sep>")[0]).childCategories.firstWhere((element) => element.firebaseId == offerItems[offerItem].itemIdentifier[offer].split("<sep>")[1]).name}",
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                offerItems[offerItem].itemIdentifier[offer].split("<sep>")[2],
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.all(10),

                                              child: Row(
                                                children: [

                                                  Spacer(),
                                                  SizedBox(
                                                    width: 100,
                                                    height: 30,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        // Perform some action
                                                      },
                                                      style: ButtonStyle(
                                                        backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                                                        minimumSize: MaterialStateProperty.resolveWith((states) => Size(double.infinity, 50)),
                                                        shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5.0),
                                                          side: BorderSide(color: Colors.green),
                                                        )),
                                                      ),
                                                      child: Text(
                                                        'VIEW',
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                // Add more cards here as required
                              ],
                            ),
                          ),
                        ],
                      ),


                    const SizedBox(height: 20,),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                          child: Text(
                            "Categories",
                            style: TextStyle(
                              fontSize: 15.0, fontFamily: "AwanZaman", color: Colors.black, fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: (MediaQuery.of(context).size.width ~/ 128) > categories.length ? categories.length : MediaQuery.of(context).size.width ~/ 128,
                      shrinkWrap: true,
                      childAspectRatio: (MediaQuery.of(context).size.width ~/ 128) > categories.length ? 2 : 0.8,
                      children: List.generate(categories.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            if (categories[index].childCategories.length < 2) {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => ItemScreen(category: categories[index], childCategory: categories[index].childCategories[0])));
                            }
                            else {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryScreen(category: categories[index],)));

                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0.0, 2.0),
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: categories[index].imageUrl,
                                  imageBuilder: (context, imageProvider) => Container(
                                    height: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => Image.asset("assets/images/fish.gif"),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                  fit: BoxFit.cover,

                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  categories[index].name,
                                  style: const TextStyle(
                                    fontSize: 15.0, fontFamily: "AwanZaman", color: Colors.black,
                                  ),
                                ),
                              ),

                              // Container(
                              //   width: 100.0,
                              //   height: 100.0,
                              //   decoration: const BoxDecoration(
                              //       shape: BoxShape.circle
                              //   ),
                              //   child: CachedNetworkImage(
                              //     imageUrl: url,
                              //     imageBuilder: (context, imageProvider) => Container(
                              //       height: 200,
                              //       width: 200,
                              //       decoration: BoxDecoration(
                              //         shape: BoxShape.circle,
                              //         image: DecorationImage(
                              //           image: imageProvider,
                              //           fit: BoxFit.cover,
                              //         ),
                              //       ),
                              //     ),
                              //     placeholder: (context, url) => Image.asset("assets/images/fish.gif"),
                              //     errorWidget: (context, url, error) => const Icon(Icons.error),
                              //     fit: BoxFit.cover,
                              //
                              //   ),
                              // ),
                              // const SizedBox(height: 8.0),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                              //   child: Text(
                              //     textAlign: TextAlign.center,
                              //     name,
                              //     style: const TextStyle(
                              //       fontSize: 15.0, fontFamily: "AwanZaman", color: Colors.black,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          // Column(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //
                          //     Container(
                          //       width: 100.0,
                          //       height: 100.0,
                          //       decoration: const BoxDecoration(
                          //           shape: BoxShape.circle
                          //       ),
                          //       child: CachedNetworkImage(
                          //         imageUrl: categories[index].imageUrl,
                          //         imageBuilder: (context, imageProvider) => Container(
                          //           height: 200,
                          //           width: 200,
                          //           decoration: BoxDecoration(
                          //             shape: BoxShape.circle,
                          //             image: DecorationImage(
                          //               image: imageProvider,
                          //               fit: BoxFit.cover,
                          //             ),
                          //           ),
                          //         ),
                          //         placeholder: (context, url) => Image.asset("assets/images/fish.gif"),
                          //         errorWidget: (context, url, error) => const Icon(Icons.error),
                          //         fit: BoxFit.cover,
                          //
                          //       ),
                          //     ),
                          //     const SizedBox(height: 8.0),
                          //     Text(
                          //       textAlign: TextAlign.center,
                          //       categories[index].name,
                          //       style: const TextStyle(
                          //         fontSize: 15.0, fontFamily: "AwanZaman", color: Colors.black,
                          //       ),
                          //     ),
                          //
                          //   ],
                          // ),
                        );
                      }),
                    ),

                    // TEMPORARY - TO SHOW OFF - START

                    const SizedBox(height: 10.0,),
                    Row(
                      children: [
                        categoryItem(context, "Eri/Sheri", "https://res.cloudinary.com/dimuvfyj5/image/upload/v1675832962/assets/eri_sheri_we4a4m.jpg"),
                        categoryItem(context, "KingFish", "https://res.cloudinary.com/dimuvfyj5/image/upload/v1675834692/assets/king_fish_ypv9jm.jpg"),
                        categoryItem(context, "White and Black Pomfret/Avoli", "https://res.cloudinary.com/dimuvfyj5/image/upload/v1675834690/assets/white_and_black_pomfret_rbv3q3.jpg"),

                      ],
                    ),
                    const SizedBox(height: 10.0,),
                    Row(
                      children: [
                        categoryItem(context, "Malabar Trevally / Kadukappara / Vattappara", "https://res.cloudinary.com/dimuvfyj5/image/upload/v1675832962/assets/malabar_trevally_vdlhjc.jpg"),
                        categoryItem(context, "White Snapper", "https://res.cloudinary.com/dimuvfyj5/image/upload/v1675832961/assets/white_snapper_qt0aqu.jpg"),
                        categoryItem(context, "Malabar Kallumakkaya", "https://res.cloudinary.com/dimuvfyj5/image/upload/v1675832962/assets/kallummakai_ivn6tj.jpg"),

                      ],
                    ),

                    // TEMPORARY - TO SHOW OFF - END

                  ],
                ),
              ),
              const SizedBox(height: 80,),
            ],
          ),
          const NavigationsBar(idScreen: "home"),
        ],
      ),
    );
  }

  Widget categoryItem(BuildContext context, String name, String url) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100.0,
            height: 100.0,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: CachedNetworkImage(
              imageUrl: url,
              imageBuilder: (context, imageProvider) => Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Image.asset("assets/images/fish.gif"),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,

            ),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 5.0),
            child: Text(
              textAlign: TextAlign.center,
              name,
              style: const TextStyle(
                fontSize: 15.0, fontFamily: "AwanZaman", color: Colors.black,
              ),
            ),
          ),

          // Container(
          //   width: 100.0,
          //   height: 100.0,
          //   decoration: const BoxDecoration(
          //       shape: BoxShape.circle
          //   ),
          //   child: CachedNetworkImage(
          //     imageUrl: url,
          //     imageBuilder: (context, imageProvider) => Container(
          //       height: 200,
          //       width: 200,
          //       decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         image: DecorationImage(
          //           image: imageProvider,
          //           fit: BoxFit.cover,
          //         ),
          //       ),
          //     ),
          //     placeholder: (context, url) => Image.asset("assets/images/fish.gif"),
          //     errorWidget: (context, url, error) => const Icon(Icons.error),
          //     fit: BoxFit.cover,
          //
          //   ),
          // ),
          // const SizedBox(height: 8.0),
          // Padding(
          //   padding: const EdgeInsets.only(left: 10.0, right: 5.0),
          //   child: Text(
          //     textAlign: TextAlign.center,
          //     name,
          //     style: const TextStyle(
          //       fontSize: 15.0, fontFamily: "AwanZaman", color: Colors.black,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
