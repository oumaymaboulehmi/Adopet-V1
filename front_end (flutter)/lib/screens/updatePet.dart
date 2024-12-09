import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/pet.dart';

class UpdateDogScreen extends StatefulWidget {
  final Dog dog;

  const UpdateDogScreen({required this.dog});

  @override
  _UpdateDogScreenState createState() => _UpdateDogScreenState();
}

class _UpdateDogScreenState extends State<UpdateDogScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  late TextEditingController _colorController;
  late TextEditingController _locationController;
  late TextEditingController _aboutController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.dog.name);
    _ageController = TextEditingController(text: widget.dog.age?.toString());
    _genderController = TextEditingController(text: widget.dog.gender);
    _colorController = TextEditingController(text: widget.dog.color);
    _locationController = TextEditingController(text: widget.dog.location);
    _aboutController = TextEditingController(text: widget.dog.about);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _colorController.dispose();
    _locationController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _updateDog() async {
    if (!_formKey.currentState!.validate()) return;

    Dog updatedDog = Dog(
      id: widget.dog.id,
      name: _nameController.text,
      age: int.tryParse(_ageController.text) ?? widget.dog.age,
      gender: _genderController.text,
      color: _colorController.text,
      weight: widget.dog.weight, // Assuming this field remains unchanged
      location: _locationController.text,
      about: _aboutController.text,
      owner: widget.dog.owner, // Assuming this field remains unchanged
      bio: widget.dog.bio, // Assuming this field remains unchanged
    );

    try {
      final response = await http.put(
        Uri.parse('http://localhost:5001/api/dogs/${updatedDog.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': updatedDog.name,
          'age': updatedDog.age,
          'gender': updatedDog.gender,
          'color': updatedDog.color,
          'weight': updatedDog.weight,
          'location': updatedDog.location,
          'about': updatedDog.about,
          'owner': updatedDog.owner,
          'bio': updatedDog.bio,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${updatedDog.name} has been updated')),
        );
        Navigator.of(context).pop(updatedDog); // Retourner le chien mis à jour
      } else {
        throw Exception('Failed to update dog. Status: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Dog'),
        centerTitle: true,
        backgroundColor: Color(0xFFF4D3B0), // Teinte beige
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Dog Name',
                    filled: true,
                    fillColor: Color(0xFFF9F3E4), // Crème
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFFB6A18C)), // Bordure taupe clair
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a dog name' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    filled: true,
                    fillColor: Color(0xFFF9F3E4),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFB6A18C)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter the age' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _genderController,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    filled: true,
                    fillColor: Color(0xFFF9F3E4),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFB6A18C)),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter the gender' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _colorController,
                  decoration: InputDecoration(
                    labelText: 'Color',
                    filled: true,
                    fillColor: Color(0xFFF9F3E4),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFB6A18C)),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter the color' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    filled: true,
                    fillColor: Color(0xFFF9F3E4),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFB6A18C)),
                    ),
                  ),
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter the location'
                      : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _aboutController,
                  decoration: InputDecoration(
                    labelText: 'About',
                    filled: true,
                    fillColor: Color(0xFFF9F3E4),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFB6A18C)),
                    ),
                  ),
                  maxLines: 4,
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _updateDog,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFFF4D3B0),
                    ),
                    child: Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
