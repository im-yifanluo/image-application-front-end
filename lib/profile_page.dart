import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package
import 'package:image_picker/image_picker.dart'; // Import image_picker package
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _hobbiesController = TextEditingController();
  String _profileImagePath = '';
  bool _isEdited = false; // Track if the user has edited any field
  String _filterPreference = 'None'; // Default filter preference

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Load profile data when the page is initialized
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _bioController.text = prefs.getString('bio') ?? '';
      _hobbiesController.text = prefs.getString('hobbies') ?? '';
      _profileImagePath = prefs.getString('profileImagePath') ?? '';
      _filterPreference = prefs.getString('filterPreference') ?? 'None';
    });
  }

  Future<void> _saveProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('bio', _bioController.text);
    await prefs.setString('hobbies', _hobbiesController.text);
    await prefs.setString('profileImagePath', _profileImagePath);
    await prefs.setString('filterPreference', _filterPreference);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Profile data saved successfully!'),
      duration: Duration(seconds: 2),
    ));
    setState(() {
      _isEdited = false; // Reset the edited state after saving
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImagePath = pickedFile.path;
        _isEdited = true; // Mark as edited
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Set background to white
        iconTheme: IconThemeData(color: Colors.red), // Make icon color red
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.red,           // Set the title text color to red
            fontWeight: FontWeight.bold, // Bold text
            fontSize: 30.0,              // Font size consistent with other pages
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImagePath.isNotEmpty
                      ? FileImage(File(_profileImagePath))
                      : null,
                  child: _profileImagePath.isEmpty
                      ? Icon(Icons.person, size: 50, color: Colors.grey)
                      : null,
                ),
              ),
              SizedBox(height: 16.0),

              // Name TextField
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red), // Red outline for enabled state
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0), // Red outline for focused state
                  ),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _isEdited = true; // Mark as edited
                  });
                },
              ),
              SizedBox(height: 16.0),

              // Email TextField
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red), // Red outline for enabled state
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0), // Red outline for focused state
                  ),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    _isEdited = true; // Mark as edited
                  });
                },
              ),
              SizedBox(height: 16.0),

              // Filter Preferences Section
              DropdownButtonFormField<String>(
                value: _filterPreference,
                items: [
                  'None',
                  'Black & White',
                  'Vintage',
                  'Sepia',
                  'Bright',
                  'Cool',
                  'Warm',
                  'High Contrast',
                  'Low Contrast',
                  'Soft Focus',
                  'Vivid',
                  'Muted Colors'
                ].map((filter) => DropdownMenuItem(
                  child: Text(filter),
                  value: filter,
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _filterPreference = value!;
                    _isEdited = true; // Mark as edited
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Filter Preferences',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red), // Red outline for enabled state
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0), // Red outline for focused state
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),

              // Bio TextField
              TextField(
                controller: _bioController,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red), // Red outline for enabled state
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0), // Red outline for focused state
                  ),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) {
                  setState(() {
                    _isEdited = true; // Mark as edited
                  });
                },
              ),
              SizedBox(height: 16.0),

              // Hobbies and Interests
              TextField(
                controller: _hobbiesController,
                decoration: InputDecoration(
                  labelText: 'Hobbies and Interests',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red), // Red outline for enabled state
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0), // Red outline for focused state
                  ),
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                onChanged: (value) {
                  setState(() {
                    _isEdited = true; // Mark as edited
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _isEdited
          ? FloatingActionButton.extended(
        onPressed: _saveProfileData,
        label: Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: Icon(Icons.save),
        backgroundColor: Colors.red,
      )
          : null, // Only show when edited
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}