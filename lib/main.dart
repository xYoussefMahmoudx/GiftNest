import 'package:flutter/material.dart';
import 'package:giftnest/view/HomePage.dart';
import 'dart:io';
import 'dart:typed_data';
import 'Core/UserHelper.dart';
import 'PopulateDB.dart';
import 'PopulateMoreDB.dart';
import 'model/User.dart';

import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

Future<Uint8List> getImageBytes(String assetPath) async {
  final ByteData bytes = await rootBundle.load(assetPath);
  return bytes.buffer.asUint8List();
}
void main() async {
  // Ensure Flutter bindings are initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Uncomment this line to populate the database.
  //await populateDatabase();
  //await populateMoreDatabase();
  var alice= await UserHelper().getUserById(1) as User;
  Uint8List imageBytes = await getImageBytes('assets/alice.jpg');
  alice.profileImage=imageBytes;
  print(alice.profileImage.toString());
  UserHelper().updateUser(alice);
  print("Done alice photo");
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
      home: const HomePage(title: 'Gift Nest'),

    );
  }
}

