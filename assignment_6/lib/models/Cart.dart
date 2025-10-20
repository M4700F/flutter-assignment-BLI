import 'package:assignment_6/models/shoe.dart';
import 'package:flutter/cupertino.dart';

class Cart extends ChangeNotifier {
  // list the shoes for sale
  List<Shoe> shoeShop = [
    Shoe(
      name: 'Zoom',
      price: '236',
      description: 'The forward thinking design of this latest signature show',
      imagePath: 'assets/images/shoes 1.jpg',
    ),

    Shoe(
      name: 'Air Jordan',
      price: '220',
      description: 'You have the hops and the speed-lace up in the Air Jordan',
      imagePath: 'assets/images/shoes 2.jpg',
    ),

    Shoe(
      name: 'KD Treys',
      price: '250',
      description: 'A secure pair of the iconic Treys',
      imagePath: 'assets/images/shoes 3.jpg',
    ),

    Shoe(
      name: 'Kyrie 6',
      price: '239',
      description: 'Bouncy cushioning returns to the Kyrie 6',
      imagePath: 'assets/images/shoes 4.jpg',
    ),
  ];

  // list of the items in the cart
  List<Shoe> userCart = [];

  // get list of shoes for sale
  List<Shoe> getShoeList() {
    return shoeShop;
  }

  // get cart
  List<Shoe> getCart() {
    return userCart;
  }

  // adding items to cart
  void addItemToCart(Shoe shoe) {
    userCart.add(shoe);
    notifyListeners();
  }

  // remove items from the cart
  void removeItemFromCart(Shoe shoe) {
    userCart.remove(shoe);
    notifyListeners();
  }
}
