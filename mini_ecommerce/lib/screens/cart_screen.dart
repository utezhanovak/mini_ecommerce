import 'package:flutter/material.dart';
import '../models/cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<String, Map<String, dynamic>> groupedItems = {};

  @override
  void initState() {
    super.initState();
    _groupItems();
  }

  void _groupItems() {
    groupedItems.clear();
    for (var item in cartItems) {
      final name = item['name'];
      if (groupedItems.containsKey(name)) {
        groupedItems[name]!['quantity'] += 1;
        groupedItems[name]!['totalPrice'] += item['price'];
      } else {
        groupedItems[name] = {
          'price': item['price'],
          'quantity': 1,
          'totalPrice': item['price'],
        };
      }
    }
  }

  void _increaseQuantity(String name) {
    final item = groupedItems[name];
    if (item != null) {
      cartItems.add({'name': name, 'price': item['price'], 'category': ''});
      setState(() => _groupItems());
    }
  }

  void _decreaseQuantity(String name) {
    final index = cartItems.indexWhere((item) => item['name'] == name);
    if (index != -1) {
      cartItems.removeAt(index);
      setState(() => _groupItems());
    }
  }

  @override
  Widget build(BuildContext context) {
    _groupItems();
    final double total = groupedItems.values.fold(
        0, (sum, item) => sum + (item['price'] * item['quantity']));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8E44AD),
        title: const Text(
          'Cart',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  cartItems.clear();
                  groupedItems.clear();
                });
              },
              tooltip: 'Clear the cart',
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty
                ? const Center(child: Text('Your cart is empty'))
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: groupedItems.entries.map((entry) {
                      final name = entry.key;
                      final quantity = entry.value['quantity'];
                      final price = entry.value['price'];

                      return Dismissible(
                        key: Key(name),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.redAccent,
                          child: const Icon(Icons.delete, color: Colors.white, size: 30),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            cartItems.removeWhere((item) => item['name'] == name);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$name removed from cart')),
                          );
                        },
                        child: ListTile(
                          title: Text(name),
                          subtitle: Text('\$${price.toStringAsFixed(2)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => _decreaseQuantity(name),
                              ),
                              Text(
                                '$quantity',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => _increaseQuantity(name),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
          if (cartItems.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/payment'); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6F61),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Place Order',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF3EAFD),
        selectedItemColor: const Color(0xFF512DA8),
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/catalog');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/orders');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: 'Catalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}
