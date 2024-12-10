import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _productController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _makePurchase() async {
    String phone = _phoneController.text.trim();
    String product = _productController.text.trim();

    if (phone.isNotEmpty && product.isNotEmpty) {
      await _firestore.collection('purchases').add({
        'userPhone': phone,
        'productName': product,
        'status': 'pending', // Indicates that the admin needs to process this
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Purchase completed successfully!')),
      );

      _phoneController.clear();
      _productController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User App")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: "Enter Your Phone Number"),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _productController,
              decoration: InputDecoration(labelText: "Enter Product Name"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _makePurchase,
              child: Text("Buy Product"),
            ),
          ],
        ),
      ),
    );
  }
}