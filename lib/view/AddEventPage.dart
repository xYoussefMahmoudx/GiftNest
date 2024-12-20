import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
class AddEventPage extends StatefulWidget {
  final Function(String title, String location, String? description, String date,String category) onAdd;

  const AddEventPage({Key? key, required this.onAdd}) : super(key: key);

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  DateTime? _selectedDate;



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Event'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Event Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 10),
              DateTimeFormField(
                decoration: const InputDecoration(
                  labelText: "Event Date",
                  border: OutlineInputBorder(),
                ),
                mode: DateTimeFieldPickerMode.date,
                initialValue: _selectedDate,
                onChanged: (DateTime? value) {
                  _selectedDate = value;
                },
                validator: (value) {
                  if (value == null) {
                    return "Please select a date";
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
            if (_formKey.currentState!.validate() && _selectedDate != null) {
              widget.onAdd(
                _titleController.text,
                _locationController.text,
                _descriptionController.text,
                _selectedDate!.toIso8601String(),
                _categoryController.text,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Add Event'),
        ),
      ],
    );
  }
}
