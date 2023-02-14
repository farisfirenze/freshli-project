import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:freshli_delivery/Widgets/navigationBar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Models/confirmedOrder.dart';
import '../Data/globalVariables.dart';
import 'package:firebase_database/firebase_database.dart';

class OrderScreen extends StatefulWidget {
  static const String idScreen = "orders";
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  TextEditingController promoCodeController = TextEditingController(text: "");
  List<ConfirmedOrder> orders = [];
  bool loaded = false;


  Future<void> updateOrderList() async{

    setState(() {
      loaded = false;
    });

    orders = [];

    final event = await referenceGlobal.once(DatabaseEventType.value);
    Map firebaseData = event.snapshot.value as Map<dynamic, dynamic>;

    Map<dynamic, dynamic> orderMap = {};

    if (firebaseData["users"][currentUser.firebaseId].containsKey("orders")){
      orderMap = firebaseData["users"][currentUser.firebaseId]["orders"];

    } else {
      orderMap = {};
    }

    for (var order in orderMap.entries) {
      List<Map<dynamic, dynamic>> tempItems = [];
      for (var item in order.value["items"]) {


        Map<dynamic, dynamic> itemMap = {};

        bool checked = false;

        for(var cate in categories) {
          if (cate.firebaseId == item.toString().split("<sep>")[0]) {
            checked = true;
            break;
          }
        }

        if (checked) {
          itemMap["category"] = categories.firstWhere((map) => map.firebaseId == item.toString().split("<sep>")[0]);
          itemMap["childCategory"] = itemMap["category"].childCategories.firstWhere((map) => map.firebaseId == item.toString().split("<sep>")[1]);
          itemMap["type"] = item.toString().split("<sep>")[3];
          itemMap["price"] = item.toString().split("<sep>")[4];
          itemMap["quantity"] = item.toString().split("<sep>")[5];

          tempItems.add(itemMap);
        }

      }
      setState(() {
        if (tempItems.isNotEmpty) {
          orders.add(
              ConfirmedOrder(
                  status: order.value["status"],
                  orderedOn: DateFormat('EEE, M/d/yyyy h:mm:ss a').parse(order.value["orderedOn"]),
                  firebaseId: order.key,
                  total: order.value["total"].toDouble(),
                  orderId: order.value["orderId"],
                  items: tempItems
              )
          );
        }

      });

      setState(() {
        orders.sort((a, b) => b.orderedOn.compareTo(a.orderedOn));
      });

    }

    setState(() {
      loaded = true;
      // orders= [];
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateOrderList();
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
                            Icons.check_box_outlined,
                            size: 40,
                            color: Colors.white,
                          ),
                          Text(
                            'My Orders',
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
              const SizedBox(height: 100,),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    loaded ? orders.isEmpty ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/emptyOrder.gif",
                          ),
                          const SizedBox(height: 10.0,),
                          Text("You have no orders.", style: TextStyle(color: brandGreen, fontWeight: FontWeight.bold, fontFamily: "AwanZaman", fontSize: 20.0),),
                        ],
                      ),
                    ) : Container() : const Padding(
                      padding: EdgeInsets.only(left: 175.0, right: 175.0),
                      child: CircularProgressIndicator(),
                    ),
                    for (var i=0; i<orders.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Order Id.: ${orders[i].orderId}",
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: "AwanZaman", fontSize: 18.0),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Ordered on.: ${DateFormat.yMEd().add_jms().format(orders[i].orderedOn).toString()}",
                                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: "AwanZaman", fontSize: 18.0),
                                    ),
                                    // int.parse(orders[i].orderedOn.toString().split(" ")[0].split(":")[0])Text(
                                    //   " AM",
                                    //   style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: "AwanZaman", fontSize: 18.0),
                                    // ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "Items: ",
                                  style: TextStyle(color: brandGreen, fontWeight: FontWeight.bold, fontFamily: "AwanZaman", fontSize: 18.0),
                                ),
                              ),
                              for (var k=0; k<orders[i].items.length; k++)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0, top: 4.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,

                                    children: [
                                      Text(
                                        "\t\t\t${k + 1}. ${orders[i].items[k]["category"].name.toUpperCase()} - ${orders[i].items[k]["childCategory"].name.toUpperCase()} - ${orders[i].items[k]["type"].toUpperCase()}\n\t\t\t\t\t\t\t\t Price: \u{20B9} ${orders[i].items[k]["price"]}, Quantity: ${orders[i].items[k]["quantity"]}",
                                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: "AwanZaman", fontSize: 15.0),
                                      ),

                                    ],
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Total Price: \u{20B9} ${orders[i].total}", style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontFamily: "AwanZaman", fontSize: 20.0),),
                                    const Text("Status: ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: "AwanZaman", fontSize: 20.0),),
                                    (orders[i].status == "Ordered") ?
                                    Text(orders[i].status, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontFamily: "AwanZaman", fontSize: 20.0),) :
                                    (orders[i].status == "Confirmed") ?
                                    Text(orders[i].status, style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontFamily: "AwanZaman", fontSize: 20.0),) :
                                    (orders[i].status == "Cancelled") ?
                                    Text(orders[i].status, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontFamily: "AwanZaman", fontSize: 20.0),) :
                                    (orders[i].status == "Requested") ?
                                    Text(orders[i].status, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontFamily: "AwanZaman", fontSize: 20.0),) :
                                    Text(orders[i].status, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontFamily: "AwanZaman", fontSize: 20.0),),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    (["Ordered", "Confirmed"].contains(orders[i].status)) ?
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            height: 40,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                showConfirmationDialog(context, orders[i].firebaseId);
                                              },
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(whiteshade),
                                                minimumSize: MaterialStateProperty.all(Size.zero),
                                                foregroundColor: MaterialStateProperty.all(Colors.red[600]),
                                                shape: MaterialStateProperty.all(
                                                  const StadiumBorder(
                                                    side: BorderSide(
                                                        color: Colors.red,
                                                        width: 1.0
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              child: const Text("Cancel Order"),
                                            ),
                                          ),
                                        ),
                                        const Text("Order cancellation not allowed after 7 PM"),
                                      ],
                                    ): Container(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 30,),
                    const SizedBox(height: 120,),
                  ],
                ),
              ),
              const SizedBox(height: 60,),
            ],
          ),
          const NavigationsBar(idScreen: "orders"),
        ],
      ),
    );
  }

  Future<void> showConfirmationDialog(BuildContext contextMain, String orderId){
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cancel Order", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontFamily: "AwanZaman"),),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text("Do you really want to cancel? \n\nYour items may have already been dispatched.", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontFamily: "AwanZaman"),),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("YES", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontFamily: "AwanZaman", fontSize: 20.0),),
              onPressed: () {
                referenceGlobal.child("users").child(currentUser.firebaseId).child("orders").child(orderId).update({"status" : "Requested"});
                Navigator.of(context).pop();
                updateOrderList();
                showConfirm(context);

              },
            ),
            TextButton(
              child: const Text("NO", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontFamily: "AwanZaman", fontSize: 20.0),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showConfirm(BuildContext contextMain){
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Order Cancellation Requested.", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontFamily: "AwanZaman"),),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text("Order cancellation has been requested. The status has been changed to RTC.", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontFamily: "AwanZaman"),),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("OK", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontFamily: "AwanZaman", fontSize: 20.0),),
              onPressed: () {
                Navigator.of(context).pop();

              },
            ),
          ],
        );

      },
    );
  }


  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}
