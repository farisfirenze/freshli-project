import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshli_delivery/Screens/itemScreen.dart';
import 'package:freshli_delivery/Screens/searchScreen.dart';
import 'package:freshli_delivery/Widgets/navigationBar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Models/category.dart';
import '../Data/globalVariables.dart';

class CategoryScreen extends StatefulWidget {
  static const String idScreen = "category";
  final Category category;
  const CategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    print(widget.category);
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
                              IconButton(
                                  onPressed: () {

                                    print(currentUser.firstName);
                                  },
                                  icon: const Icon(
                                    Icons.drive_file_rename_outline_sharp,
                                    size: 30,
                                    color: Colors.white,
                                  )
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(
                                  currentUser.restaurantName,
                                  style: const TextStyle(fontSize: 20.0, fontFamily: "AwanZaman", color: Colors.white, fontWeight: FontWeight.w400),
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
                          )


                          // const SizedBox(
                          //   height: 30,
                          // ),
                          // Search screen
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
                  scrollDirection: Axis.vertical,
                  children: [

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 50),
                          child: Text(
                            widget.category.name,
                            style: const TextStyle(
                              fontSize: 15.0, fontFamily: "AwanZaman", color: Colors.black, fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: (MediaQuery.of(context).size.width ~/ 128) > widget.category.childCategories.length ? widget.category.childCategories.length : MediaQuery.of(context).size.width ~/ 128,
                      shrinkWrap: true,
                      childAspectRatio: (MediaQuery.of(context).size.width ~/ 128) > widget.category.childCategories.length ? 2 : 0.8,
                      children: List.generate(widget.category.childCategories.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => ItemScreen(category: widget.category, childCategory: widget.category.childCategories[index])));
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
                                  imageUrl: widget.category.childCategories[index].imageUrl,
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
                                  widget.category.childCategories[index].name,
                                  style: const TextStyle(
                                    fontSize: 15.0, fontFamily: "AwanZaman", color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Column(
                          //   children: [
                          //     Container(
                          //       width: 100.0,
                          //       height: 100.0,
                          //       decoration: const BoxDecoration(
                          //         shape: BoxShape.circle
                          //       ),
                          //       child: CachedNetworkImage(
                          //         imageUrl: widget.category.childCategories[index].imageUrl,
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
                          //       widget.category.childCategories[index].name,
                          //       style: const TextStyle(
                          //         fontSize: 15.0, fontFamily: "AwanZaman", color: Colors.black,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        );
                      }),
                    ),
                    SizedBox(height: 200,)

                  ],
                ),
              ),
            ],
          ),
          const NavigationsBar(idScreen: "category"),
        ],
      ),
    );
  }
}
