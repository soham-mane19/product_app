import 'package:flutter/material.dart';
import 'package:global_infotech/product.dart';
import 'package:global_infotech/product_master.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  const Text("Home Screen"),

        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                   ElevatedButton(onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                       return ProductMasterScreen();
                    },));
                   },
                    child:  const Text("Admin"),),
                    const SizedBox(
                      height: 20,
                    ),
                      ElevatedButton(onPressed: (){
                      
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return ProductListScreen();
                  }));
                
              
                      },
                    child:  const Text("Customer"),),
              ],
            )
          ],
        ),
    );
  }
}