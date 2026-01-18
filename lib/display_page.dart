import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import './new_filter_screen.dart'; // Import the FilterScreen file

class DisplayPage extends StatefulWidget {
  const DisplayPage(
      {super.key, required this.filterName, required this.imagePath});

  final String filterName;
  final String imagePath;

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  Future<void> _downloadImage() async {
    final saveDirectory = await getDownloadsDirectory();

    if (saveDirectory == null) {
      throw Exception("Could not retrieve downloads directory");
    }
    DateFormat dateFormat = DateFormat("yyyy-MM-dd-HH-mm-ss");
    DateTime now = DateTime.now();
    String formattedDate = dateFormat.format(now);
    final downloadPath = "${saveDirectory.path}/filter_image_$formattedDate.png";
    final file = File(widget.imagePath);

    // Copy instead of renaming
    final newFile = await file.copy(downloadPath);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Image saved to $downloadPath"),
      duration: Duration(seconds: 2),
    ));
    print(downloadPath);
  }

  Future<void> _deleteImage() async {
    try {
      final file = File(widget.imagePath);
      if (await file.exists()) {
        await file.delete();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Image deleted"),
          duration: Duration(seconds: 2),
        ));
        Navigator.pop(context); // Go back after deleting
      }
    } catch (e) {
      print("Error deleting image: $e");
    }
  }

  void _reapplyFilter() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterScreen(imagePath: widget.imagePath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Set app bar background to white
        title: Text(
          "Image Viewer",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold), // Red text for title
        ),
        iconTheme: IconThemeData(color: Colors.red), // Red color for back button
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.file(
                File(widget.imagePath),
                fit: BoxFit.contain, // Ensure the full image is displayed
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Delete button
                ElevatedButton(
                  onPressed: _deleteImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[100], // Light red background
                    minimumSize: Size(50, 45), // Make delete button same height as the apply filter button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Icon(Icons.delete, color: Colors.red), // Red icon
                ),
                SizedBox(width: 16), // Add space between the buttons
                // Reapply filter button
                Expanded(
                  child: ElevatedButton(
                    onPressed: _reapplyFilter, // Call _reapplyFilter method
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: Size(width * 0.8, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Apply New Filter",
                      style: TextStyle(color: Colors.white),
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