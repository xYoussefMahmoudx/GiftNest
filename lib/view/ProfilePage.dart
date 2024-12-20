import 'dart:typed_data'; //
import 'package:flutter/material.dart';
import 'package:giftnest/controller/UserHelper.dart';
import 'package:image_picker/image_picker.dart';

import '../model/User.dart';

class ProfilePage extends StatefulWidget {
final User user ;

  const ProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Uint8List? _userImage;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _userImage = widget.user.profileImage;
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phoneNumber);
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    Uint8List? _userimagepick=Uint8List.fromList(await image!.readAsBytes());
    if (image != null) {
      setState(()  {
        _userImage = _userimagepick;
      });
    }
  }

  void _saveChanges() {
    // Save changes logic here (e.g., send data to server or database)
    widget.user.profileImage=_userImage;
    widget.user.firstName=_firstNameController.text;
    widget.user.lastName=_lastNameController.text;
    widget.user.email=_emailController.text;
    widget.user.phoneNumber=_phoneController.text;
        UserHelper().updateUser(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Image
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _userImage != null ? MemoryImage(_userImage!) : null,
                child: _userImage == null
                    ? const Icon(Icons.add_a_photo, size: 30)
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            // First Name
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // Last Name
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // Email
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // Phone Number
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,

                ),
                onPressed: _saveChanges,
                child: Center(
                  widthFactor: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.save,color: Colors.black),
                      Text("Save Changes",style: TextStyle(color: Colors.black),),
                    ],
                  ) ,
                )
            )
          ],
        ),
      ),
    );
  }
}
