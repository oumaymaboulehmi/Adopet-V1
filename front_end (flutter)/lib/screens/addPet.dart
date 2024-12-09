import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class AddPetScreen extends StatefulWidget {
  @override
  _AddPetScreenState createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerBioController = TextEditingController();

  String _gender = 'Male'; // Default value for gender

  Uint8List? _pickedImageBytes;
  String? _pickedImageName;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _colorController.dispose();
    _weightController.dispose();
    _locationController.dispose();
    _aboutController.dispose();
    _ownerNameController.dispose();
    _ownerBioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _pickedImageBytes = bytes;
          _pickedImageName = image.name;
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final url = Uri.parse('http://localhost:5001/api/dogs');
      final request = http.MultipartRequest('POST', url);

      // Add form fields
      request.fields['name'] = _nameController.text.trim();
      request.fields['age'] = _ageController.text.trim();
      request.fields['gender'] = _gender;
      request.fields['color'] = _colorController.text.trim();
      request.fields['weight'] = _weightController.text.trim();
      request.fields['location'] = _locationController.text.trim();
      request.fields['about'] = _aboutController.text.trim();
      request.fields['owner'] = _ownerNameController.text.trim();
      request.fields['bio'] = _ownerBioController.text.trim();

      // Add image if selected
      if (_pickedImageBytes != null && _pickedImageName != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'image', // Correspond au champ attendu par l'API
          _pickedImageBytes!,
          filename: _pickedImageName,
        ));
      }

      try {
        final response = await request.send();
        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pet added successfully!')),
          );
          _formKey.currentState?.reset();
          setState(() {
            _pickedImageBytes = null;
            _pickedImageName = null;
          });
        } else {
          final responseBody = await response.stream.bytesToString();
          final errorMessage =
              json.decode(responseBody)['message'] ?? 'An error occurred.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add pet: $errorMessage')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Pet',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: Color(0xFFD1B2A1), // Nude beige background
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _pickedImageBytes != null
                    ? Image.memory(
                        _pickedImageBytes!,
                        height: 220,
                        width: 220,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 220,
                        width: 220,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image,
                          size: 100,
                          color: Colors.grey[700],
                        ),
                      ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Choose Image'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFFC49A6C), // Soft brown for the button
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 5,
                  ),
                ),
                SizedBox(height: 30),
                _buildTextField('Dog Name', _nameController, Icons.pets),
                _buildTextField('Age', _ageController, Icons.calendar_today,
                    isNumber: true),
                _buildTextField('Color', _colorController, Icons.palette),
                _buildTextField('Weight (kg)', _weightController, Icons.scale,
                    isNumber: true),
                _buildGenderDropdown(),
                _buildTextField(
                    'Location', _locationController, Icons.location_on),
                _buildTextField('About', _aboutController, Icons.description,
                    maxLines: 3),
                _buildTextField(
                    'Owner Name', _ownerNameController, Icons.person),
                _buildTextField('Owner Bio', _ownerBioController, Icons.info,
                    maxLines: 2),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 59, 32, 4), // Rich brown accent
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 8,
                    shadowColor: Colors.black.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon,
      {bool isNumber = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD1B2A1)),
          prefixIcon: Icon(icon, color: Color(0xFFD1B2A1)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30), gapPadding: 10),
          filled: true,
          fillColor: Colors.pink[50],
          contentPadding: EdgeInsets.symmetric(vertical: 18.0),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: DropdownButtonFormField<String>(
        value: _gender,
        onChanged: (value) => setState(() => _gender = value!),
        items: ['Male', 'Female'].map((gender) {
          return DropdownMenuItem(value: gender, child: Text(gender));
        }).toList(),
        decoration: InputDecoration(
          labelText: 'Gender',
          labelStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD1B2A1)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30), gapPadding: 10),
          filled: true,
          fillColor: Colors.pink[50],
        ),
      ),
    );
  }
}
