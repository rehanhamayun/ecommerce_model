import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Products {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rating;

  const Products(
      {required this.id,
      required this.title,
      required this.price,
      required this.description,
      required this.category,
      required this.image,
      required this.rating});

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rating: json['rating'],
    );
  }
}

class ProductController extends GetxController {
  List<Products> productData = [];

// Empty List used to store clicked add to cart values
  List<Products> cartItem = List<Products>.empty().obs;

  addtoCart(Products item) {
    cartItem.add(item);
  }

  double get totalPrice => cartItem.fold(0, (sum, item) => sum + item.price);
  int get count => cartItem.length;

  @override
  void onInit() {
    super.onInit();
  }
}

class Homepage extends StatelessWidget {
// getx

  ProductController productController = Get.put(ProductController());

  // LIVE API
  fetchProducts() async {
    final response =
        await http.get(Uri.parse("https://fakestoreapi.com/products"));
    final responseFinal = await json.decode(response.body);

    return responseFinal;
  }

  Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    fetchProducts();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("Products"),
      ),
      body: FutureBuilder(
          future: fetchProducts(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 250,
                        width: double.infinity,
                        child: Card(
                          elevation: 0,
                          color: Colors.white,
                          child: Container(
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Text(
                                          snapshot.data[index]['title']
                                              .toString(),
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 40, 20, 40),
                                        child: Text(
                                          "Price ${snapshot.data[index]['price'].toString()} \$ ",
                                          style: GoogleFonts.poppins(
                                            color: Colors.blueGrey,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // 1st Column
                                Expanded(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Image.network(
                                        snapshot.data[index]['image'],
                                        height: 100,
                                        width: 100,
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.blueGrey,
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          "Add to Cart",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              );
            }
            if (snapshot.hasError) {
              Text("Error");
            }

            return Text("Loading");
          }),
    );
  }
}
