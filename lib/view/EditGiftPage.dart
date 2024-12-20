import 'package:flutter/material.dart';
import '../model/Event.dart';

class EditGiftPage extends StatefulWidget {
  final int eventId;
  final String title;
  final String? description;
  final double price;
  final String status;
  final List<Event> events; // List of available events
  final Function(int eventId, String title, String? description, double price, String status) onEdit;

  const EditGiftPage({
    Key? key,
    required this.eventId,
    required this.title,
    required this.description,
    required this.price,
    required this.status,
    required this.events,
    required this.onEdit,
  }) : super(key: key);

  @override
  State<EditGiftPage> createState() => _EditGiftPageState();
}

class _EditGiftPageState extends State<EditGiftPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _selectedStatus;
  Event? _selectedEvent;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title;
    _descriptionController.text = widget.description ?? '';
    _priceController.text = widget.price.toStringAsFixed(2);
    _selectedStatus = widget.status;
    _selectedEvent = widget.events.firstWhere((event) => event.id == widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Gift'),
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
              widget.onEdit(
                _selectedEvent!.id!,
                _titleController.text,
                _descriptionController.text,
                double.parse(_priceController.text),
                _selectedStatus!,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Edit Gift'),
        ),
      ],
    );
  }
}
