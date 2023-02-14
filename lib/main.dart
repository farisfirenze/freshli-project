import 'package:flutter/material.dart';
import 'package:freshli_delivery/Screens/cartScreen.dart';
import 'package:freshli_delivery/Screens/checkoutScreen.dart';
import 'package:freshli_delivery/Screens/itemScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freshli_delivery/Screens/profileScreen.dart';
import 'package:freshli_delivery/Screens/loginScreen.dart';

import 'Screens/homeScreen.dart';
import 'Screens/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Freshli Business',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: SplashScreen.idScreen,
      routes:{
        // SplashScreen.idScreen: (context) => SplashScreen(),
        SplashScreen.idScreen: (context) => const SplashScreen(),

        HomeScreen.idScreen: (context) => const HomeScreen(),
        ProfileScreen.idScreen: (context) => const ProfileScreen(),
        LoginScreen.idScreen: (context) => const LoginScreen(),
        CartScreen.idScreen: (context) => const CartScreen(),
        // ItemScreen.idScreen: (context) => const ItemScreen(),
      },
    );
  }
}


