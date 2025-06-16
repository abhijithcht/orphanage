import 'package:flutter/material.dart';

class CraftDetails extends StatefulWidget {
  const CraftDetails({
    required this.craftID, required this.name, required this.price, required this.description, super.key,
    this.image,
  });

  final String craftID;
  final String name;
  final String price;
  final String description;
  final dynamic image;

  @override
  State<CraftDetails> createState() => _CraftDetailsState();
}

class _CraftDetailsState extends State<CraftDetails> {
  final _style = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 22,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ITEM DETAILS'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.name,
              style: _style,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.image,
                ),
              ),
            ),
            Text(
              'Price: ${widget.price}',
              style: _style,
            ),
            Text(
              'Description: ${widget.description}',
              style: _style,
            ),
          ],
        ),
      ),
    );
  }
}
