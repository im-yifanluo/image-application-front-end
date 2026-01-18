import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import './new_filter_screen.dart'; // Import your FilterScreen

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final ImagePicker _picker = ImagePicker(); // Create an instance of ImagePicker

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FilterScreen(imagePath: image.path),
          ),
        );
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Upload",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.red),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon slightly lower in the upper part
          Padding(
            padding: const EdgeInsets.only(top: 60.0), // Adjusted to position the icon slightly lower
            child: Icon(
              Icons.file_upload,
              color: Colors.red,
              size: 120.0,
            ),
          ),
          // Taller box containing the title, description, and button
          Container(
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0), // Made the box taller
            decoration: BoxDecoration(
              color: Colors.red[50], // Light red background for the box
              borderRadius: BorderRadius.circular(15.0), // Rounded corners
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
              children: [
                // Centered Title text
                Center(
                  child: Text(
                    "Select Image & Apply Filter",
                    style: TextStyle(
                      fontSize: 24.0, // Larger font for title
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Black color for title text
                    ),
                    textAlign: TextAlign.center, // Center align title text
                  ),
                ),
                SizedBox(height: 10),
                // Left-aligned body text
                Text(
                  "Easily choose an image from your local device gallery and apply AI-generated filters to enhance your photos. Press the button below to upload and start customizing your image with the various filter options we provide!",
                  textAlign: TextAlign.left, // Left align body text
                  style: TextStyle(
                    fontSize: 14.0, // Smaller font size for the body text
                    color: Colors.grey[800], // Grey color for body text
                  ),
                ),
                SizedBox(height: 20),
                // Upload button
                Center( // Center the button at the bottom
                  child: ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: Size(width * 0.7, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Upload Image",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}