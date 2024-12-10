import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Define the MethodChannel
  static const platform = MethodChannel('com.example.auto_sms/sms'); // Match this with the Android CHANNEL

  // Function to call the MethodChannel
  Future<void> sendSMS(String number, String message) async {
    try {
      final result = await platform.invokeMethod('sendSMS', {
        'number': number, // Replace with the desired phone number
        'message': message, // Replace with the desired message
      });
      print(result); // Should print "SMS Sent Successfully"
      showSnackBar("SMS Sent Successfully");
    } catch (e) {
      print("Error sending SMS: $e");
      showSnackBar("Failed to send SMS: $e");
    }
  }

  // Helper method to show a snackbar
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Call the sendSMS function when the button is pressed
            sendSMS("+8801999455193", "Hello, this is an automated SMS!");
          },
          child: Text("Order"),
        ),
      ),
    );
  }
}
