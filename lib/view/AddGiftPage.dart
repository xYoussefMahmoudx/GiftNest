import 'package:flutter/material.dart';

import '../model/Event.dart';



class AddGiftPage extends StatefulWidget {
  final List<Event> events; // List of available events
  final Function(int eventId, String title, String? description, double price, String status ,String category) onAdd;

  const AddGiftPage({
    Key? key,
    required this.events,
    required this.onAdd,
  }) : super(key: key);

  @override
  State<AddGiftPage> createState() => _AddGiftPageState();
}

class _AddGiftPageState extends State<AddGiftPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  String? _selectedStatus;
  Event? _selectedEvent;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Gift'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Event>(
                value: _selectedEvent,
                decoration: const InputDecoration(labelText: 'Select Event'),
                items: widget.events
                    .map((event) => DropdownMenuItem(
                  value: event,
                  child: Text(event.title),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEvent = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an event';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Gift Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  final price = double.tryParse(value);
                  if (price == null || price <= 0) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'category'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: ['Available', 'Reserved', 'Purchased']
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a status';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate() && _selectedEvent != null) {
              widget.onAdd(
                _selectedEvent!.id!,
                _titleController.text,
                _descriptionController.text,
                double.parse(_priceController.text),
                _selectedStatus!,
                _categoryController.text
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Add Gift'),
        ),
      ],
    );
  }
}
