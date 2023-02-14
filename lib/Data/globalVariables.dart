import 'dart:ui';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:freshli_delivery/Models/Item.dart';
import 'package:freshli_delivery/Models/category.dart';
import 'package:freshli_delivery/Models/childCategory.dart';
import 'package:freshli_delivery/Models/offerItem.dart';
import 'package:freshli_delivery/Models/promoCodeAmount.dart';

import '../Assistants/createMaterialColor.dart';
import '../Models/order.dart';
import '../Models/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

Color lightsky = const Color(0xFFA6C0FF);
Color whiteshade = const Color(0xFFF8F9FA);
Color blue = const Color(0xFF1137FF);
Color lightblueshade = const Color(0xFF758CC8);
Color grayshade = const Color(0xFF9FA4AF);
Color lightblue = const Color(0xFF4B68D1);
Color blackshade = const Color(0xFF555555);

final referenceGlobal = FirebaseDatabase.instance.ref();

User currentUser = User(firstName: "", lastName: "", address: "", landmark: "", personalPhoneNumber: "", phoneNumber: "", restaurantName: "", username: "", password: "", promoCodes: [], firebaseId: '');

Map<dynamic, dynamic> globalOrder = {};
List<dynamic> usedPromoCodes = [];

// double discountGlobal = 0;

// List userPromoCodes = currentUser.promoCodes.expand((e) => e.keys).toList();
// List userPromoValues = currentUser.promoCodes.expand((e) => e.values).toList();

List<Category> categories = [];
List<OfferItem> offerItems = [];
List<dynamic> promoCodes = [];

Color brandGreen = const Color(0xff3b7f32);
Color brandWhite = const Color(0xffe5e0e0);

final brandgreenCreateMaterialColor = CreateMaterialColor().createMaterialColor(Color(0xFF3b7f32));

final cloudinary = Cloudinary.full(
    apiKey:"<API_KEY>",
    apiSecret: "<API_SECRET>",
    cloudName:"<CLOUD_NAME>"
);