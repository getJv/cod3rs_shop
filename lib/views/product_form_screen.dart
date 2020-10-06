import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/product_provider.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptonFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final product = ModalRoute.of(context).settings.arguments as Product;
      if (product != null) {
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['price'] = product.price.toString();
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;
        _imageUrlController.text = _formData['imageUrl'];
      } else {
        _formData['price'] = '';
      }
    }
  }

  void _updateUmageUrl() {
    if (!isValidImageUrl(_imageUrlController.text)) return;
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool isValidProtocol = url.toLowerCase().startsWith('http://') ||
        url.toLowerCase().startsWith('https://');
    bool endsWithPng = url.toLowerCase().endsWith('.png');
    bool endsWithJpeg = url.toLowerCase().endsWith('.jpg');
    return isValidProtocol && (endsWithPng || endsWithJpeg);
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateUmageUrl);
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptonFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateUmageUrl);
    _imageUrlFocusNode.dispose();
  }

  Future<Null> _saveForm() async {
    if (!_form.currentState.validate()) {
      return;
    }

    _form.currentState.save();
    final newProduct = Product(
      id: _formData['id'],
      title: _formData['title'],
      price: _formData['price'],
      description: _formData['description'],
      imageUrl: _imageUrlController.text,
    );

    setState(() {
      _isLoading = true;
    });

    final products = Provider.of<ProductsProvider>(context, listen: false);
    if (_formData['id'] == null) {
      try {
        await products.addProduct(newProduct);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Ocorreu um erro'),
                  content: Text(error.toString()),
                  actions: [
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('OK'),
                    ),
                  ],
                ));
      } finally {
        setState(() {
          _isLoading = true;
        });
        Navigator.of(context).pop();
      }
    } else {
      setState(() {
        _isLoading = true;
      });
      Navigator.of(context).pop();
      products.updateProduct(newProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario Produto'),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveForm();
              })
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['id'],
                      decoration: InputDecoration(
                        labelText: 'Título',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Campo é obrigatório';
                        }
                        return null;
                      },
                      onSaved: (value) => _formData['title'] = value,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price'].toString(),
                      decoration: InputDecoration(
                        labelText: 'Preço',
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptonFocusNode);
                      },
                      validator: (value) {
                        var newPrice = double.tryParse(value);
                        if (value.trim().isEmpty || newPrice <= 0) {
                          return 'Campo é obrigatório';
                        }

                        return null;
                      },
                      onSaved: (value) =>
                          _formData['price'] = double.parse(value),
                      focusNode: _priceFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                    ),
                    TextFormField(
                      initialValue: _formData['description'],
                      decoration: InputDecoration(
                        labelText: 'Descrição',
                      ),
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Campo é obrigatório';
                        }
                        return null;
                      },
                      onSaved: (value) => _formData['description'] = value,
                      focusNode: _descriptonFocusNode,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Url da Imagem ',
                            ),
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return 'Campo é obrigatório';
                              }
                              if (!isValidImageUrl(_imageUrlController.text))
                                return "Não é uma imagem valida";
                              return null;
                            },
                            controller: _imageUrlController,
                            onSaved: (value) => _formData['imagemUrl'] = value,
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(top: 8, left: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          alignment: Alignment.center,
                          child: _imageUrlController.text.isEmpty
                              ? Text('Informe a URL')
                              : Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
