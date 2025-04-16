import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/cart.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  Future<void> _placeOrder(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    final ordersRef = FirebaseDatabase.instance.ref().child('orders');

    if (user != null && cartItems.isNotEmpty) {
      final total = cartItems.fold<double>(
        0,
        (sum, item) => sum + (item['price'] as double),
      );

      final orderData = {
        'items': {
          'timestamp': DateTime.now().toIso8601String(),
          'total': total,
        },
      };

      await ordersRef.child(user.uid).push().set(orderData);
      cartItems.clear();

      // Показываем диалог успеха
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Success!"),
          content: const Text("Your payment was successful."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Закрыть диалог
                Navigator.pushNamed(context, '/orders'); // Перейти к заказам
              },
              child: const Text("Check Order"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      hintStyle: const TextStyle(color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF8E44AD), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF8E44AD), width: 2),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8E44AD),
        title: const Text(
          'Payment',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            TextField(
              decoration: inputDecoration.copyWith(hintText: 'Card Number'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration:
                        inputDecoration.copyWith(hintText: 'Expiration date'),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: inputDecoration.copyWith(hintText: 'CVV/CVC'),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6F61),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => _placeOrder(context),
                child: const Text(
                  'Pay',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
