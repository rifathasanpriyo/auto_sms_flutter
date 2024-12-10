import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const platform = MethodChannel('com.example.auto_sms/sms');

  @override
  void initState() {
    super.initState();
    _listenToPurchases();
  }

  void _listenToPurchases() {
    _firestore.collection('purchases').snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          _processPurchase(change.doc);
        }
      }
    });
  }

  Future<void> _processPurchase(DocumentSnapshot purchase) async {
    String phone = purchase['userPhone'];
    String product = purchase['productName'];

    try {
      await platform.invokeMethod('sendSMS', {
        'number': phone,
        'message': "Thank you for purchasing $product from our store!",
      });

      await purchase.reference.update({'status': 'processed'});

      print("SMS sent to $phone");
    } catch (e) {
      print("Error sending SMS: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin App")),
      body: Center(
        child: Text(
          "Listening for purchases and sending SMS...",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}