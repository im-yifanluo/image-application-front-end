import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img; // Import the image package for rotation
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class RotatedFilterScreen extends StatefulWidget {
  const RotatedFilterScreen({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<RotatedFilterScreen> createState() => _RotatedFilterScreenState();
}

class _RotatedFilterScreenState extends State<RotatedFilterScreen> {
  final client = http.Client(); // HTTP client for requests
  Map data = {}; // Store filter data
  Map<String, String> imagePaths = {}; // Store paths of processed images
  int _currentPage = 0; // Track the current page
  final PageController _pageController =
      PageController(); // Controller for the PageView

  @override
  void initState() {
    super.initState();
    _fetchFilter();
  }

  Future<void> _fetchFilter() async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://54.193.8.75:5000/get_filters'),
      );
      request.files
          .add(await http.MultipartFile.fromPath('image', widget.imagePath));

      final response =
          await client.send(request).timeout(Duration(seconds: 60));

      if (response.statusCode == 200) {
        final responseBody = await http.Response.fromStream(response);
        final responseData = responseBody.body;

        data = jsonDecode(responseData);

        for (String filterName in data.keys) {
          await _applyFilter(filterName, data[filterName]);
        }
      } else {
        print("Failed to process image: ${response.statusCode}");
        _fetchFilter();
      }
    } on TimeoutException {
      print("Request timed out.");
    } on http.ClientException {
      print("Malformed packet");
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  Future<void> _applyFilter(
      String filterName, Map<String, dynamic> filter) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://54.193.8.75:5000/get_image'),
      );
      request.files
          .add(await http.MultipartFile.fromPath('image', widget.imagePath));
      request.fields['filters'] = jsonEncode(filter['filters']);

      final response =
          await client.send(request).timeout(Duration(seconds: 60));

      if (response.statusCode == 200) {
        final responseBody = await http.Response.fromStream(response);
        final responseData = responseBody.body;
        final base64Image = jsonDecode(responseData)['image'];

        // Decode the base64 image
        Uint8List decodedImage = base64Decode(base64Image);

        // Load the image using the image package and rotate it 90 degrees clockwise
        img.Image? originalImage = img.decodeImage(decodedImage);
        if (originalImage != null) {
          img.Image rotatedImage = img.copyRotate(originalImage,
              angle: 90); // Rotate the image 90 degrees clockwise

          // Save the rotated image to a temporary file
          final tempDir = await getTemporaryDirectory();
          final filePath = '${tempDir.path}/$filterName.png';
          final file = File(filePath);
          await file.writeAsBytes(
              img.encodePng(rotatedImage)); // Save the rotated image

          setState(() {
            imagePaths[filterName] = file.path;
          });
        }
      } else {
        print("Image received in bad format");
      }
    } catch (error) {
      print("An error occurred: $error");
    }
  }

  Future<void> _downloadImage(String filterName) async {
    try {
      final imagePath = imagePaths[filterName];
      if (imagePath == null) return;

      final saveDirectory = await getDownloadsDirectory();
      if (saveDirectory == null) {
        throw Exception("Could not retrieve downloads directory");
      }

      DateFormat dateFormat = DateFormat("yyyy-MM-dd-HH-mm-ss");
      DateTime now = DateTime.now();
      String formattedDate = dateFormat.format(now);
      final downloadPath =
          "${saveDirectory.path}/filter_image_$formattedDate.png";
      final file = File(imagePath);

      // Copy the file instead of renaming
      await file.copy(downloadPath);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Image saved to $downloadPath"),
        duration: Duration(seconds: 2),
      ));
      print(downloadPath);
    } catch (e) {
      print("Error saving image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "AI-Generated Filters",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ),
      body: data.isNotEmpty
          ? Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          scrollDirection: Axis.horizontal,
                          itemCount: data.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            String filterName = data.keys.elementAt(index);
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  filterName,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10),
                                if (imagePaths[filterName] != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Container(
                                      width: width * 0.9,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Image.file(
                                        File(imagePaths[filterName]!),
                                        height: height * 0.55,
                                        fit: BoxFit
                                            .contain, // Ensure entire image is displayed
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Container(
                                    width: width * 0.9,
                                    color: Colors.grey[200],
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      data[filterName]['suggestion'],
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    minimumSize: Size(width * 0.8, 45),
                                    // Make button wider
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    "Save Image",
                                    style: TextStyle(
                                      color: Colors
                                          .white, // Set the text color to white
                                    ),
                                  ),
                                  onPressed: () {
                                    _downloadImage(filterName);
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        Positioned(
                          left: 10,
                          child: IconButton(
                            icon:
                                Icon(Icons.arrow_back_ios, color: Colors.black),
                            onPressed: () {
                              if (_currentPage > 0) {
                                _pageController.previousPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                          ),
                        ),
                        Positioned(
                          right: 10,
                          child: IconButton(
                            icon: Icon(Icons.arrow_forward_ios,
                                color: Colors.black),
                            onPressed: () {
                              if (_currentPage < data.length - 1) {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(data.length, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              _currentPage == index ? Colors.red : Colors.grey,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "The data used to apply the following filters to the image are AI-generated.",
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text(
                      'Fetching AI-generated filters\nThis might take a minute...'),
                ],
              ),
            ),
    );
  }
}
