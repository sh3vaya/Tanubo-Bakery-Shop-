import 'package:flutter/material.dart';
import '../models/item.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback onTap;

  const ItemCard({Key? key, required this.item, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(item.imageUrl),
        title: Text(item.name),
        subtitle: Text(item.description),
        trailing: Text('Rp${item.price.toStringAsFixed(0)}'),
        onTap: onTap,
      ),
    );
  }
}