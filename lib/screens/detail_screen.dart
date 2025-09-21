import 'package:flutter/material.dart';
import '../models/item.dart';

class DetailScreen extends StatelessWidget {
  final Item item;

  DetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(item.imageUrl),
            SizedBox(height: 20),
            Text(
              item.name,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              item.description,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Harga: Rp${item.price.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 20, color: Colors.brown[700]),
            ),
          ],
        ),
      ),
    );
  }
}