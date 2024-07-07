import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String _productName = '';
  String _productPrice = '';
  File? _productImage;
  bool _isLoading = false;
// to save product in shred preference
  _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final prefs = await SharedPreferences.getInstance();
      String? encodedProducts = prefs.getString('products');
      List<Map<String, dynamic>> products = [];

      if (encodedProducts != null) {
        List<dynamic> decodedProducts = jsonDecode(encodedProducts);
        products = decodedProducts
            .map((product) => Map<String, dynamic>.from(product))
            .toList();
      }

      if (products.any((product) => product['name'] == _productName)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Product with this name already exists')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      Map<String, dynamic> newProduct = {
        'name': _productName,
        'price': _productPrice,
        'image': _productImage?.path,
      };
      products.add(newProduct);

      String newEncodedProducts = jsonEncode(products);
      await prefs.setString('products', newEncodedProducts);

      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context);
    }
  }
//  to pick image from gallery
  _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _productImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration:
                  const InputDecoration(labelText: 'Product Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _productName = value;
                  },
                ),
                TextFormField(
                  decoration:
                  const InputDecoration(labelText: 'Product Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product price';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _productPrice = value;
                  },
                ),
                const SizedBox(height: 20),
                _productImage != null
                    ? Image.file(
                  _productImage!,
                  height: MediaQuery.sizeOf(context).height / 5,
                )
                    : ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Pick Image'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveProduct,
                  child: const Text('Add Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
