import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'data/Dog.dart';
import 'package:go_router/go_router.dart';

class DogListScreen extends StatefulWidget {
  @override
  _DogListScreenState createState() => _DogListScreenState();
}

class _DogListScreenState extends State<DogListScreen> {
  List<Dog> dogList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchDogs();
  }

  Future<void> fetchDogs() async {
    try {
      final response = await http.get(
          // bech tastit 3al teliphoun 7atit ip adresse mta3 lwifi
          Uri.parse('http://localhost:8078/dogs'));

      if (response.statusCode == 200) {
        final List<dynamic> dogJson = jsonDecode(response.body);

        setState(() {
          dogList = dogJson.map((json) => Dog.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load dogs');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        errorMessage = 'Failed to fetch dogs. Please try again.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Adopt a Pet',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 10,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(errorMessage,
                      style: TextStyle(color: Colors.red, fontSize: 16)))
              : ListView.builder(
                  itemCount: dogList.length,
                  itemBuilder: (context, index) {
                    final dog = dogList[index];
                    return GestureDetector(
                      onTap: () {
                        context.go('/dog/${dog.id}');
                      },
                      child: Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 8,
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  dog.imageUrl,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dog.name,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      dog.location,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Text(
                                          dog.gender,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: dog.gender == 'Female'
                                                ? Colors.pink
                                                : Colors.blue,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Spacer(),
                                        Icon(
                                          Icons.location_on,
                                          size: 20,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '${dog.age} years',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
