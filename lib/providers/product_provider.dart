import 'dart:convert';
import 'dart:math';

import 'package:cod3r_shop/data/dammy_data.dart';
import 'package:cod3r_shop/providers/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCTS;

  bool _showFavoriteOnly = false;

  // gera uma nova lista com o spreadOperator
  List<Product> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  Future<void> addProduct(Product newProduct) async {
    const url = 'https://general-api-d2532.firebaseio.com/products';

    final response = await post(
      url,
      body: json.encode({
        'id': Random().nextDouble().toString(),
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
        'isFavorite': newProduct.isFavorite,
      }),
    );

    _items.add(Product(
      id: json.decode(response.body)["name"],
      title: newProduct.title,
      description: newProduct.description,
      price: newProduct.price,
      imageUrl: newProduct.imageUrl,
    ));

    notifyListeners();
  }

  void updateProduct(Product product) {
    if (product != null || product.id != null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == product.id);
    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
