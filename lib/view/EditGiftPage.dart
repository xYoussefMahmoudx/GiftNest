import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../model/Event.dart';
import 'dart:typed_data';

class EditGiftPage extends StatefulWidget {
  final int eventId;
  final String title;
  final String? description;
  final double price;
  final String status;
  final List<Event> events; // List of available events
  final String category;
  final Uint8List giftImage;
  final Function(int eventId, String title, String? description, double price, String status,String category,Uint8List giftImage) onEdit;

  const EditGiftPage({
    Key? key,
    required this.eventId,
    required this.title,
    required this.description,
    required this.price,
    required this.status,
    required this.events,
    required this.onEdit,
    required this.category,
    required this.giftImage,
  }) : super(key: key);

  @override
  State<EditGiftPage> createState() => _EditGiftPageState();
}

class _EditGiftPageState extends State<EditGiftPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  String? _selectedStatus;
  Event? _selectedEvent;
  Uint8List? _giftImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    Uint8List? _giftImagepick=Uint8List.fromList(await image!.readAsBytes());
    if (image != null) {
      setState(()  {
        _giftImage = _giftImagepick;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title;
    _descriptionController.text = widget.description ?? '';
    _priceController.text = widget.price.toStringAsFixed(2);
    _selectedStatus = widget.status;
    _selectedEvent = widget.events.firstWhere((event) => event.id == widget.eventId);
    _categoryController.text=widget.category;
    _giftImage=widget.giftImage;
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
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _giftImage != null ? MemoryImage(_giftImage!) : null,
                  child: _giftImage == null
                      ? const Icon(Icons.add_a_photo, size: 30)
                      : null,
                ),
              ),
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
                items: ['Available']
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
                _categoryController.text,
                _giftImage!,
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
