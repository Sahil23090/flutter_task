import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'login_token.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _searchProducts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // to get the products stored in sharedpreference
  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    String? encodedProducts = prefs.getString('products');

    if (encodedProducts != null) {
      List<dynamic> decodedProducts = jsonDecode(encodedProducts);
      _products = decodedProducts
          .map((product) => Map<String, dynamic>.from(product))
          .toList();
    }

    setState(() {
      _searchProducts = List.from(_products);
      _isLoading = false;
    });
  }

  // to delete a product from shared preference
  Future<void> _deleteProduct(int index) async {
    setState(() {
      _isLoading = true;
    });

    _products.removeAt(index);
    await _saveProducts();

    setState(() {
      _searchProducts = List.from(_products);
      _isLoading = false;
    });
  }

  Future<void> _saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    String encodedProducts = jsonEncode(_products);
    await prefs.setString('products', encodedProducts);
  }

  Future<void> logout() async {
    await loginData().clearToken();
    Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
  }

  void searchProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _searchProducts = List.from(_products);
      } else {
        _searchProducts = _products
            .where((product) =>
            product['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  bool searchClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: searchClicked
            ? TextField(
          onChanged: searchProducts,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
        )
            : const Text(
          'W e l c o m e',
          style: TextStyle(
              color: Colors.yellowAccent,
              fontSize: 23,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    searchClicked = !searchClicked;
                  });
                },
                child:
                Icon(searchClicked ? Icons.cancel : Icons.search_rounded),
              ),
              const SizedBox(width: 13),
              InkWell(
                onTap: logout,
                child: const Icon(Icons.logout_outlined),
              ),
            ],
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchProducts.isEmpty
          ? const Center(child: Text('No Product Found'))
          : SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Hi-Fi Shop & Service",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Audio shop on Rustaveli Ave 57.",
                  style:
                  TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "This shop offers both products and services",
                  style:
                  TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Products",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          _searchProducts.length.toString(),
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black54),
                        ),
                      ],
                    ),
                    const Text(
                      "Show all",
                      style:
                      TextStyle(color: Colors.blue, fontSize: 20),
                    )
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: _searchProducts.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2),
                  itemBuilder: (context, index) {
                    final product = _searchProducts[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: product['image'] != null
                                  ? Colors.white
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            height:
                            MediaQuery.of(context).size.height /
                                6,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              children: [

                                product['image'] != null
                                    ? ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(
                                      30.0),
                                  child: Image.file(
                                    File(product['image']),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                )
                                    : const Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 80,
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  left: 120,
                                  child: InkWell(
                                    onTap: ()=>_deleteProduct(index),
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.delete_outline,size: 20,),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            product['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            maxLines: 2,
                          ),
                          Text(
                            'Price: \$${product['price']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black54),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addProduct')
              .then((_) => _loadProducts());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
