import 'package:flutter/material.dart';


import '../model/Gift.dart';

class GiftDetailsPage extends StatelessWidget {
  final Gift gift;

  const GiftDetailsPage({Key? key, required this.gift}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gift Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [

            if (gift.image != null)
              Image.memory(
                gift.image!,
                height: 250,
                width: 250,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16.0),
            // Gift Title
            Text(
              gift.title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            // Gift Category
            Text(
              'Category: ${gift.category}',
              style: const TextStyle(
                fontSize: 18.0,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8.0),
            // Gift Description
            if (gift.description != null)
              Text(
                'Description: ${gift.description}',
                style: const TextStyle(fontSize: 16.0),
              ),
            if (gift.description == null)
              const Text(
                'No description available',
                style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
              ),
            const SizedBox(height: 16.0),
            // Gift Price
            Text(
              'Price: \$${gift.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8.0),
            // Gift Status
            Text(
              'Status: ${gift.status}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Event ID: ${gift.eventId}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            // Last Edited (if available)
            if (gift.lastEdited != null)
              Text(
                'Last Edited: ${gift.lastEdited}',
                style: const TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
            if (gift.lastEdited == null)
              const Text(
                'Last Edited: Not available',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
