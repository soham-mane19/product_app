import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:global_infotech/UserSession.dart';
import 'package:global_infotech/chekout.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          FutureBuilder<String>(
            future: UserSession.getSessionId(),
            builder: (context, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (futureSnapshot.hasError) {
                return Center(child: Text('Error loading session ID'));
              }

              if (!futureSnapshot.hasData || futureSnapshot.data!.isEmpty) {
                return Center(child: Text('No session ID found'));
              }

              final sessionId = futureSnapshot.data!;

              return Expanded( // Use Expanded to ensure the StreamBuilder takes available space
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('carts')
                      .where('sessionId', isEqualTo: sessionId)
                      .snapshots(),
                  builder: (context, streamSnapshot) {
                    if (streamSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (streamSnapshot.hasError) {
                      return const Center(child: Text('Error loading cart items'));
                    }

                    if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No items in cart'));
                    }

                    final cartItems = streamSnapshot.data!.docs;

                    return ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Card(
                          child: ListTile(
                            leading: Image.network(
                              item['imageUrl'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(item['productName']),
                            subtitle: Text(item['description']),
                            trailing: Text('\$${item['rate'].toString()}'),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CheckoutScreen()),
                );
              },
              child: Text('Proceed to Checkout'),
            ),
          ),
        ],
      ),
    );
  }
}
