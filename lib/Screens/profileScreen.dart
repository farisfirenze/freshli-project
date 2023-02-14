import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freshli_delivery/Screens/loginScreen.dart';

import '../Models/user.dart';
import '../Data/globalVariables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  static const String idScreen = "profile";

  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = currentUser;

    return Scaffold(
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
                            Icons.account_circle_outlined,
                            size: 40,
                            color: Colors.white,
                          ),
                          Text(
                            'Your Profile',
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
              const SizedBox(
                height: 100.0,
              ),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [

                    SizedBox(
                      height: 150,
                      child: Image.asset(
                        "assets/images/logo_white.png",
                      ),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "First Name (Purchasing Manager)",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  Container(
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          user.firstName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Last Name (Purchasing Manager)",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  Container(
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          user.lastName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Restaurant Name",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Container(
                            height: 40,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  user.restaurantName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                      child: buildAbout(user),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Phone Number (Company)",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Container(
                            height: 40,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  user.phoneNumber,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Phone Number (Personal)",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Container(
                            height: 40,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  user.personalPhoneNumber,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            onPressed: () {
                              showConfirmationDialog(context);

                            },
                            child: const Text(
                              "Log Out",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
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
          )
        ],
      ),
    );
  }

  Future<void> showConfirmationDialog(BuildContext contextMain){
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Log Out", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontFamily: "AwanZaman"),),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
              Text("Do you really want to log out ?", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontFamily: "AwanZaman"),),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Yes'),
              onPressed: () async{

                final prefs = await SharedPreferences.getInstance();
                final success = await prefs.remove('credentials');
                print(success);

                Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);

              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(String getValue, String title) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Container(
                width: 350,
                height: 40,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                    children: [

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              getValue,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                ),
              ),
            ],
          )
      );

  // Widget builds the About Me Section
  Widget buildAbout(User user) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Address',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
      const SizedBox(height: 1),
      Container(
          height: 80,
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ))),
          child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "${user.address} \nLandmark : ${user.landmark}",
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ),
              ]
          )
      )
    ],
  );

  // Refrshes the Page after updating user info.
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }
}