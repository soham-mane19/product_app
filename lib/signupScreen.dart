import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:global_infotech/userprovider.dart';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  XFile? addressProof;
  bool isTextMatching = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? verificationId;
  bool verified = false;

  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text('Customer Registration'),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        labelText:  'Customer Name',
                      labelStyle: GoogleFonts.imprima(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                    validator: (value) {
                      if(value==null || value.isEmpty){
                              return 'please enter your name';
                      }else
                      {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   TextFormField(
                    controller: contactController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText:  'Contact Number',
                      suffixIcon: IconButton(onPressed: (){
                        verifyPhoneNumber();
                      },
                       icon: Text("Verify")),
                      labelStyle: GoogleFonts.imprima(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                      validator: (value) {
                      if(value==null || value.isEmpty ){
                              return 'please enter your number';
                      }else if(value.length!=10){
                        return 'please enter vaild number';
                      }
                      {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText:  'Email ID',
                      labelStyle: GoogleFonts.imprima(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                      validator: (value) {
                      if(value==null || value.isEmpty){
                              return 'please enter your mail';
                      }else if(!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)){
                                return 'please enter vaild mail';
                      }
                      {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   TextFormField(
                    obscureText: true,
                    obscuringCharacter: '*',
                    controller: passwordController,
                    decoration: InputDecoration(
                      suffixIcon:  const Icon(Icons.visibility_off),
                      labelText:  'Password',
                      labelStyle: GoogleFonts.imprima(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                      validator: (value) {
                      if(value==null || value.isEmpty){
                              return 'please enter your password';
                      }else
                      {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   TextFormField(
                    controller: pinCodeController,
                    onChanged: (value) {
                      if(value.length==6){
                        fetchpinCode(value);
                      }
                    },
                    decoration: InputDecoration(
                      labelText:  'Pin Code',
                      labelStyle: GoogleFonts.imprima(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.secondary,
                    
                      ),
                      
                      
                      enabledBorder: const UnderlineInputBorder(
                        
                          borderSide: BorderSide(color: Colors.black)),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   TextFormField(
                    controller: stateController,
                    decoration: InputDecoration(
                      labelText:  'State',
                      labelStyle: GoogleFonts.imprima(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   TextFormField(
                    controller: cityController,
                    decoration: InputDecoration(
                      labelText:  'City',
                      labelStyle: GoogleFonts.imprima(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   TextFormField(
                    controller:addressController,
                    decoration: InputDecoration(
                      labelText:  'Address',
                      labelStyle: GoogleFonts.imprima(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                      validator: (value) {
                      if(value==null || value.isEmpty){
                              return 'please enter your Address';
                      }else
                      {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: addressProoffile,
                      child: Text(addressProof==null?'Upload Address Proof':addressProof!.name),
                    ),
                  
                  ],
                ),
                 ElevatedButton(
                onPressed: register,
                child: Text('Register'),
              ),
              
                ],
              ),
            )),
      ),
    );
  }
  void fetchpinCode(String pinCode)async{
             
    Uri url = Uri.parse('http://www.postalpincode.in/api/pincode/$pinCode');
      final responce =  await  http.get(url);

    if(responce.statusCode==200){
   Map data =json.decode( responce.body);
 
 
    setState(() {
      stateController.text =  data['PostOffice'][0]['State'];
      cityController.text = data['PostOffice'][0]['District'];

    });
 
    }else{
      print("error");
    }

  }

  Future addressProoffile()async{
    
       final file   =  await picker.pickImage(source:ImageSource.gallery);
setState(() {
  addressProof = file;
});
if(file!=null){
recognize();
}
  }
  void recognize() async {
  print("Recognizing image...");
  var inputImage = InputImage.fromFilePath(addressProof!.path);
  final RecognizedText recognizedText = await TextRecognizer().processImage(inputImage);

  String extractedText = recognizedText.text.trim();
  print("Extracted Text: $extractedText");

  String expectedCity = cityController.text..trim();
  String expectedPinCode = pinCodeController.text.trim();

  setState(() {
    isTextMatching = extractedText.contains(expectedCity) && extractedText.contains(expectedPinCode);
  });

  if (!isTextMatching) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Image does not match the expected city and pin code.'),
    ));
  }
}

 void register() async {
  if (formKey.currentState!.validate()) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final alreadyUser = await firebaseFirestore
        .collection('users')
        .where('contactNO', isEqualTo: contactController.text)
        .get();

    if (alreadyUser.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You are already registered.")));
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Map<String, String> userData = {
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'pincode': pinCodeController.text,
        'state': stateController.text,
        'city': cityController.text,
        'contactNO': contactController.text,
        'Address': addressController.text,
      };

      firebaseFirestore.collection('users').add(userData).then((_) {
        print("Data added successfully!");

        // Store the contact number and address in the provider
        Provider.of<UserProvider>(context, listen: false).setUserDetails(
          contactController.text,
          addressController.text,
          nameController.text,
        );

        Navigator.of(context).pushReplacementNamed('/home');
      }).catchError((error) {
        print("Failed to add data: $error");
      });
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Please fill all the fields'),
    ));
  }
}

     Future<void> verifyPhoneNumber() async {
    final phoneNumber = "+91${contactController.text}";

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential authCredential)  {
          
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Error: ${e.code}");
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          this.verificationId = verificationId;
          showOTPDialog();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
        },
      );
    } catch (e) {
      print("Error verifying phone number: $e");
    }
  }


  void showOTPDialog() {
    TextEditingController otpController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter OTP'),
          content: TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter OTP',
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Verify'),
              onPressed: () async {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: verificationId!,
                  smsCode: otpController.text.trim(),
                );
                try {
                  await auth.signInWithCredential(credential);
                   setState(() {
                     verified = true;
                   });
                  register();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Failed to verify OTP: $e'),
                  ));
                }
              },
            ),
          ],
        );
      },
    );
  }
}
