import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

 GlobalKey<FormState> globalKey = GlobalKey();
  TextEditingController contactController  = TextEditingController();
 TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const  Text("Login"),
      centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: globalKey,
          child: Column(
            children: [
              TextFormField(
              controller: contactController,
                decoration:  const InputDecoration(
                     labelText: 'contact number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
               
                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)))
                ),
                 validator: (value) {
                  if( value==null || value.isEmpty  ){
                         return 'please enter your number';
                  }else{
                      return  null;
                  }
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: passwordController,
              obscureText: true,
              obscuringCharacter: '*',
                decoration:  const InputDecoration(
                     labelText: 'password',
                     suffixIcon: Icon(Icons.visibility_off),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
               
                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)))
                ),
                validator: (value) {
                  if( value==null || value.isEmpty  ){
                         return 'please enter your password';
                  }else{
                      return  null;
                  }
                },
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(onPressed: (){
                  validate();
              },
               child: const Text("Login"))
          
            ],
          ),
        ),
      ),
    );
  }
  void validate()async{
          if(globalKey.currentState!.validate()){
    FirebaseFirestore firebaseFirestore  = FirebaseFirestore.instance;
    final alreadyuser = await firebaseFirestore.collection('users').where('contactNO',isEqualTo: contactController.text).get();
          
          if(alreadyuser.docs.isEmpty){
           ScaffoldMessenger.of(context).showSnackBar(
              
             const  SnackBar(
              content: Text("No user found with this contact number please register")));
              return;
          }
           final userDoc = alreadyuser.docs.first;
      final storedPassword = userDoc['password'];

      if (passwordController.text == storedPassword) {
       
        
        Navigator.of(context).pushReplacementNamed('/home'); 
          
      }  else{
         ScaffoldMessenger.of(context).showSnackBar(
              
             const  SnackBar(
              content: Text("incorrect password")));
            
      }
          }
          else{
            ScaffoldMessenger.of(context).showSnackBar(
              
             const  SnackBar(content: Text("please fill all feild")));
          }
  }
}