import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:global_infotech/Detail.dart';
import 'package:global_infotech/UserSession.dart';
import 'package:global_infotech/cart.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const CartScreen();
              }));
            },
            icon: Icon(Icons.trolley),
          )
        ],
      ),
      body: Column(children: [
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('products').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error loading products'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No products available'));
              }

              final products = snapshot.data!.docs;

              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        product['imageUrl'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(product['productName']),
                      subtitle: Text(product['description']),
                      trailing: Text('\$${product['rate'].toString()}'),
                      onTap: () async {
                      
 
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>Detail(
                              detail: product,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}
