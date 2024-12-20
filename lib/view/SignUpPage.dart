import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:giftnest/view/SignInPage.dart';
import '../Core/UserHelper.dart';
import '../model/User.dart'as LocalUser;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  //final _database = FirebaseDatabase.instance.reference();

  // Controllers for form fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Uint8List? profileImageBlob;

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Uint8List imageBytes = await image.readAsBytes();
      setState(() {
        profileImageBlob = imageBytes;
      });
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      if (profileImageBlob == null) {
        _showSnackbar('Please select a profile image.');
        return;
      }

      try {
        final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        /*final User? user = userCredential.user;
        if (user != null) {
          await _database.child('users').child(user.uid).set({
            'firstName': firstNameController.text.trim(),
            'lastName': lastNameController.text.trim(),
            'email': emailController.text.trim(),
            'phoneNumber': phoneController.text.trim(),
            'profileImage': profileImageBlob,
          });*/
        var user=
        UserHelper().insertUser(
            LocalUser.User(
                firstName: firstNameController.text.trim(),
                lastName: lastNameController.text.trim(),
                email:emailController.text.trim(),
                profileImage:profileImageBlob
            )
        );

        _showSnackbar('Sign-up successful! Redirecting to Sign-In.');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage(title: 'Gift Nest',)),
          );

      } catch (e) {
        _showSnackbar('Sign-up failed: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                  profileImageBlob != null ? MemoryImage(profileImageBlob!) : null,
                  child: profileImageBlob == null
                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 16.0),

              // First Name Field
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Last Name Field
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Email Field
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Password Field
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Phone Number Field
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length > 11) {
                    return 'Phone number must not exceed 11 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Sign-Up Button
              ElevatedButton(
                onPressed:(){
                  if (_formKey.currentState!.validate()&&profileImageBlob!=null) {
                    _signUp();
                  }else{
                    _showSnackbar("please fill all the data");
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  fixedSize: const Size(150, 40),
                ),
                child: const Text('Sign Up'),
              ),

              // Navigate to Sign-In Page
              TextButton(
                onPressed: () {

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage(title: 'Gift Nest',)),
                  );
                },
                child: const Text(
                  'Already have an account? Sign In',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
