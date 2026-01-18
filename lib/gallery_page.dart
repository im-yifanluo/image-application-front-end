import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import './display_page.dart'; // Import the DisplayPage

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<File> _imageFiles = [];

  @override
  void initState() {
    super.initState();
    _loadSavedImages();
  }

  // Method to load saved images from the downloads directory that contain "filter_image" in the filename
  Future<void> _loadSavedImages() async {
    try {
      // Get the downloads directory
      final directory = await getDownloadsDirectory();
      if (directory == null) {
        throw Exception("Could not retrieve downloads directory");
      }

      // List all the files in the directory
      final List<FileSystemEntity> entities = directory.listSync();

      // Filter only files that contain "filter_image" in their name and end with ".png" or ".jpg"
      final List<File> imageFiles = entities
          .where((entity) =>
      entity is File &&
          entity.path.endsWith(".png") &&
          entity.path.contains(
              "filter_image")) // Check if the file name contains "filter_image"
          .map((entity) => File(entity.path))
          .toList();

      // Update the state with the loaded images
      setState(() {
        _imageFiles = imageFiles;
      });
    } catch (e) {
      print('Error loading images from directory: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gallery",
          style: TextStyle(
            color: Colors.red, // Red color
            fontWeight: FontWeight.bold, // Bold text
            fontSize: 30.0, // Larger font size (adjust as needed)
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.red), // Red back button
      ),
      body: _imageFiles.isEmpty
          ? const Center(child: Text("No images found"))
          : GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns in the grid
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: _imageFiles.length,
        itemBuilder: (context, index) {
          final File imageFile = _imageFiles[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DisplayPage(
                    imagePath: imageFile.path,
                    filterName: 'default', // Pass a default filter name or use appropriate logic
                  ),
                ),
              );
            },
            child: Image.file(
              imageFile,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}

// Remove the old ImageDisplayScreen as it is no longer needed.