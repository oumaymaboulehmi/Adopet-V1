import 'package:flutter/material.dart';
import 'screens/listPet.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adopt-a-Pet',
      theme: ThemeData(
        // Modernizing the color palette for a cleaner look
        primarySwatch:
            Colors.orange, // You can adjust this to a color you prefer
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyLarge:
              TextStyle(fontFamily: 'Arial', fontWeight: FontWeight.w400),
          bodyMedium:
              TextStyle(fontFamily: 'Arial', fontWeight: FontWeight.w400),
          titleLarge: TextStyle(
              fontFamily: 'Roboto', fontWeight: FontWeight.bold, fontSize: 20),
        ),
        // Button theme for modern UI feel
        buttonTheme: ButtonThemeData(
          buttonColor: const Color.fromARGB(
              255, 234, 194, 132), // Buttons with modern feel
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: DogListScreen(),
    );
  }
}
