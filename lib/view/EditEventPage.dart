import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';
class EditEventPage extends StatefulWidget {
  String title;
  String location;
  String? description;
  String date;
  final Function(String title, String location, String? description, String date) onEdit;
  EditEventPage({super.key,required this.title, required this.location, required this.description, required this.date,required this.onEdit});

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController? _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  @override
  void initState() {
    super.initState();
    _titleController.text=widget.title;
    _locationController.text = widget.location;
    _descriptionController?.text = widget.description!;
    _selectedDate=DateFormat('yyyy-MM-dd').parse(widget.date);
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Event'),
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
        widget.onEdit(
        _titleController.text,
        _locationController.text,
        _descriptionController?.text,
        _selectedDate!.toIso8601String(),
        );
        Navigator.pop(context);
        }
      },

          child: const Text('Edit Event'),
        ),
      ],
    );
  }
}
