import 'package:flutter/material.dart';
import 'package:global_infotech/userprovider.dart';
import 'package:provider/provider.dart';
 // import your UserProvider

class CheckoutScreen extends StatelessWidget {
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

 
    contactController.text = userProvider.contactNumber;
    addressController.text = userProvider.address;

    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: contactController,
              decoration: InputDecoration(labelText: 'Contact Number'),
            ),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
          
            ElevatedButton(
              onPressed: () {
              
              },
              child: Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
