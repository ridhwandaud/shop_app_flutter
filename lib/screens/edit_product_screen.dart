import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: ''
  );

  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': ''
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();  
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
      final productId = ModalRoute.of(context).settings.arguments;

      if(productId != null){
        _editedProduct = Provider.of<Products>(context, listen: false).findById(productId);

        _initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': ''
        };

        _imageUrlController.text = _editedProduct.imageUrl;
      }      
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl(){
    if(!_imageUrlFocusNode.hasFocus){
      setState(() {
        
      });
    }
  }

  void _saveForm(){
    final isValid = _form.currentState.validate();
    if(!isValid){
      return;
    }
    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    
    if(_editedProduct.id != null){
      Provider.of<Products>(context, listen: false).updateProduct(_editedProduct.id ,_editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      Provider.of<Products>(context, listen: false)
      .addProduct(_editedProduct)
      .catchError((error){
        return showDialog<Null>(
          context: context, 
          builder: (ctx) => AlertDialog(
            title: Text('An error occured!'), 
            content: Text('Something when wrong'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: (){
                  Navigator.of(ctx).pop();
                },
              )
            ],
          )
        );
      })
      .then((_){
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
     
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product'), actions: <Widget>[IconButton(icon: Icon(Icons.save), onPressed: _saveForm,)],),
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                validator: (val){
                  if(val.isEmpty){
                    return 'Please enter a product title';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value){
                  _editedProduct = Product(
                    title: value,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                validator: (val){
                  if(val.isEmpty){
                    return 'Please enter a product price';
                  }
                  if(double.tryParse(val) == null){
                    return 'Please enter a valid number';
                  }
                  if(double.tryParse(val) <= 0){
                    return 'Please enter a number greater than zero';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value){
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    price: double.parse(value),
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                validator: (val){
                  if(val.isEmpty){
                    return 'Please enter a product description';
                  }
                  if(val.length < 10){
                    return 'Should be at least 10 characters long';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value){
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    price: _editedProduct.price,
                    description: value,
                    imageUrl: _editedProduct.imageUrl
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100 ,
                    decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.only(top: 8, right: 10),
                    child: _imageUrlController.text.isEmpty ? Text('Enter a url') : FittedBox(child: Image.network(_imageUrlController.text, fit: BoxFit.cover,),),
                  ),
                  Expanded(
                    child: TextFormField(
                      validator: (val){
                        if(val.isEmpty){
                          return 'Please enter an image URL';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_){
                        _saveForm();
                      },
                      onSaved: (value){
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: value
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}