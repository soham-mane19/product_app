import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:global_infotech/product.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
  import 'package:firebase_storage/firebase_storage.dart';

class ProductMasterScreen extends StatefulWidget {
  @override
  _ProductMasterScreenState createState() => _ProductMasterScreenState();
}

class _ProductMasterScreenState extends State<ProductMasterScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
 GlobalKey<FormState> globalKey = GlobalKey();
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const  Text('Add Product'),
      ),
      body: Padding(
        padding:const  EdgeInsets.all(16.0),
        child: Form(
          key: globalKey,
          child: Column(
            children: [
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(labelText: 'Product Name',
                
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                 errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
               validator: (value) {
                 if(value==null ||value.isEmpty){
                    return 'Enter product name';
                 }else{
                  return null;
                 }
               },  
              ),
                const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description',
                
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                 errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
               validator: (value) {
                 if(value==null ||value.isEmpty){
                    return 'Enter Description';
                 }else{
                  return null;
                 }
               },  
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _rateController,
                decoration: InputDecoration(labelText: 'enter rate',
                
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                 errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
               validator: (value) {
                 if(value==null ||value.isEmpty){
                    return ' enter rate';
                 }else{
                  return null;
                 }
               },  
              ),
            const   SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text(_image == null ? 'Pick Image' : 'Change Image'),
              ),
               const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                child:const  Text('Save Product'),
              ),
                
            ],
          ),
        ),
      ),
    );
  }


Future<String> _uploadImage(File image) async {
  try {
    FirebaseStorage storage = FirebaseStorage.instance;
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = storage.ref().child('product_images').child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    throw Exception('Image upload failed: $e');
  }
}

Future<void> _saveProduct() async {
  if (globalKey.currentState!.validate()) {
    try {
    String imageUrl = await _uploadImage(File(_image!.path));
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection('products').add({
      'productName': _productNameController.text,
      'description': _descriptionController.text,
      'rate': double.parse(_rateController.text),
      'imageUrl': imageUrl, 
     
    });

    ScaffoldMessenger.of(context).showSnackBar(
     const  SnackBar(content: Text('Product added successfully!')),
    );

    // Clear the input fields
    _productNameController.clear();
    _descriptionController.clear();
    _rateController.clear();
    setState(() {
      _image = null;
    });
  } catch (e) {
    print('Error saving product: $e');
    ScaffoldMessenger.of(context).showSnackBar(
    const   SnackBar(content: Text('Failed to save product. Please try again.')),
    );
  }
  
  }else{
     ScaffoldMessenger.of(context).showSnackBar(
    const  SnackBar(content: Text('Please fill all fields and upload an image')),
    );
  }

 
}

}
