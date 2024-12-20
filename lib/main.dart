import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:giftnest/view/SignInPage.dart';
import 'dart:typed_data';
import 'PopulateDB.dart';
import 'package:flutter/services.dart';


Future<Uint8List> getImageBytes(String assetPath) async {
  final ByteData bytes = await rootBundle.load(assetPath);
  return bytes.buffer.asUint8List();
}
void main() async {
  // Ensure Flutter bindings are initialized.
  WidgetsFlutterBinding.ensureInitialized();
  await populateDatabase();
  Firebase.initializeApp();
  // Uncomment this line to populate the database.

  //await populateMoreDatabase();
  /*var alice= await UserHelper().getUserById(1) as User;
  Uint8List imageBytes = await getImageBytes('assets/alice.jpg');
  alice.profileImage=imageBytes;
  print(alice.profileImage.toString());
  UserHelper().updateUser(alice);
  print("Done alice photo");*/
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignInPage(title: "Gift Nest",),

    );
  }
}

