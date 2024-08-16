import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:global_infotech/UserSession.dart';

class Detail extends StatelessWidget {
  final DocumentSnapshot detail;

  Detail({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(detail['productName']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              detail['imageUrl'],
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              detail['productName'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(detail['description']),
            SizedBox(height: 16),
            Text(
              '\$${detail['rate'].toString()}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            ElevatedButton(
            onPressed: () async {
    String sessionId = await UserSession.getSessionId();

    // Add the product directly to the 'carts' collection
    FirebaseFirestore.instance
        .collection('carts')
        .add({
          'sessionId': sessionId,
          'productName': detail['productName'],
          'description': detail['description'],
          'rate': detail['rate'],
          'imageUrl': detail['imageUrl'],
        });

   

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added to cart!')),
                );
              },
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
