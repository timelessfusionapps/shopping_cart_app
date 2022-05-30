import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_app/provider/cart_provider.dart';
import 'package:shopping_cart_app/database/db_helper.dart';
import 'package:shopping_cart_app/model/cart_model.dart';
import 'package:shopping_cart_app/screens/cart_screen.dart';

class ProductList extends StatefulWidget {
  List<bool>? clicked = List.generate(10, (index) => false, growable: true);

  ProductList({Key? key, this.clicked}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  DBHelper? dbHelper = DBHelper();

  List<String> productName = [
    'Apple',
    'Mango',
    'Banana',
    'Grapes',
    'Water Melon',
    'Kiwi',
    'Orange',
    'Peach',
    'Strawberry',
    'Fruit Basket'
  ];
  List<String> productUnit = [
    'Kg',
    'Doz',
    'Doz',
    'Kg',
    'Kg',
    'Pc',
    'Doz',
    'Pc',
    'Box',
    'Kg'
  ];
  List<int> productPrice = [120, 300, 30, 50, 130, 40, 60, 40, 100, 300];
  List<String> productImage = [
    'assets/images/apple.png',
    'assets/images/mango.png',
    'assets/images/banana.png',
    'assets/images/grapes.png',
    'assets/images/watermelon.png',
    'assets/images/kiwi.png',
    'assets/images/orange.png',
    'assets/images/peach.png',
    'assets/images/strawberry.png',
    'assets/images/fruitBasket.png'
  ];
  List<bool> clicked = List.generate(10, (index) => false, growable: true);
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    void saveData(int index) {
      dbHelper!
          .insert(
        Cart(
          id: index,
          productId: index.toString(),
          productName: productName[index].toString(),
          initialPrice: productPrice[index],
          productPrice: productPrice[index],
          quantity: 1,
          unitTag: productUnit[index].toString(),
          image: productImage[index].toString(),
        ),
      )
          .then((value) {
        cart.addTotalPrice(double.parse(productPrice[index].toString()));
        cart.addCounter();
        print('Product Added to cart');
      }).onError((error, stackTrace) {
        print(error.toString());
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Product List'),
        actions: [
          Badge(
            badgeContent: Consumer<CartProvider>(
              builder: (context, value, child) {
                return Text(
                  value.getCounter().toString(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                );
              },
            ),
            position: const BadgePosition(start: 30, bottom: 30),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
        ],
      ),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
          shrinkWrap: true,
          itemCount: productName.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.blueGrey.shade200,
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image(
                      height: 80,
                      width: 80,
                      image: AssetImage(productImage[index].toString()),
                    ),
                    SizedBox(
                      width: 130,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5.0,
                          ),
                          RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            text: TextSpan(
                                text: 'Name: ',
                                style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0),
                                children: [
                                  TextSpan(
                                      text:
                                          '${productName[index].toString()}\n',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ]),
                          ),
                          RichText(
                            maxLines: 1,
                            text: TextSpan(
                                text: 'Unit: ',
                                style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0),
                                children: [
                                  TextSpan(
                                      text:
                                          '${productUnit[index].toString()}\n',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ]),
                          ),
                          RichText(
                            maxLines: 1,
                            text: TextSpan(
                                text: 'Price: ' r"$",
                                style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0),
                                children: [
                                  TextSpan(
                                      text:
                                          '${productPrice[index].toString()}\n',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ]),
                          ),
                        ],
                      ),
                    ),
                    clicked[index]
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueGrey.shade900),
                            onPressed: null,
                            child: const Text('Go to Cart'))
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueGrey.shade900),
                            onPressed: () {
                              setState(() {
                                clicked[index] = true;
                              });
                              saveData(index);
                            },
                            child: const Text('Add to Cart')),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
