import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rendu/main.dart';
import '../models/pet.dart';
import 'detailPet.dart';
import 'addPet.dart';
import 'package:http/http.dart' as http;

class DogListScreen extends StatefulWidget {
  @override
  _DogListScreenState createState() => _DogListScreenState();
}

class _DogListScreenState extends State<DogListScreen> {
  List<Dog> dogs = [];

  @override
  void initState() {
    super.initState();
    fetchDogs();
  }

  Future<void> fetchDogs() async {
    final response =
        await http.get(Uri.parse('http://localhost:5001/api/dogs'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        dogs = data.map((dog) => Dog.fromJson(dog)).toList();
      });
    } else {
      throw Exception('Failed to load dogs');
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to log out: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adopt_a_pet'),
        backgroundColor: Colors.brown[200], // Updated to nude color
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPetScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: dogs.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: dogs.length,
              itemBuilder: (context, index) {
                final dog = dogs[index];
                return DogCard(
                  dog: dog,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetProfileScreen(dog: dog),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class DogCard extends StatelessWidget {
  final Dog dog;
  final VoidCallback onTap;

  DogCard({required this.dog, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.grey[50], // Nude beige color
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'http://localhost:5001${dog.image}',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dog.name ?? 'No name provided',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.brown[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${dog.age} years | ${dog.color}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.brown[500],
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 18, color: Colors.brown[300]),
                        SizedBox(width: 4),
                        Text(
                          dog.location ?? 'No location provided',
                          style: TextStyle(color: Colors.brown[400]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: dog.gender == 'Male'
                          ? Colors.blue[100]
                          : Colors.pink[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      dog.gender ?? 'No gender provided',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: dog.gender == 'Male'
                            ? Colors.blue[800]
                            : Colors.pink[800],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Just now',
                    style: TextStyle(fontSize: 12, color: Colors.brown[300]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
