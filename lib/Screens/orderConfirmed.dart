import 'package:flutter/material.dart';
import '../Data/globalVariables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homeScreen.dart';

class OrderConfirmed extends StatelessWidget {
  const OrderConfirmed({Key? key}) : super(key: key);

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
                child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.check_box,
                          size: 40,
                          color: Colors.white,
                        ),
                        Text(
                          'Order Status',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "AwanZaman",
                              color: Colors.white
                          ),
                        ),
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
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/order.gif",
                          ),
                          Text("Order Confirmed", style: TextStyle(color: brandGreen, fontWeight: FontWeight.bold, fontFamily: "AwanZaman", fontSize: 20.0),),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30,),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 200,
                          height: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Container(
                            width: 120.0,
                            height: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                globalOrder = {};

                                final prefs = await SharedPreferences.getInstance();

                                await prefs.remove("orders");

                                Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);


                              },
                              style: ElevatedButton.styleFrom(backgroundColor: brandGreen),
                              child: const Text(
                                'OK',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
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
}
