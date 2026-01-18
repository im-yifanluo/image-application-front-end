import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import './upload_page.dart'; // Make sure these imports correspond to your files
import './camera_page.dart';
import './gallery_page.dart';
import './profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> tips = [
    "Trust the AI’s Suggestions: Start by exploring the AI-recommended filters, as they are tailored to enhance specific elements of your photo.",
    "Mix and Match Filters: Don’t be afraid to try different filters to achieve a unique style.",
    "Use Filters to Highlight Your Subject: Apply filters that emphasize the main subject of your photo by enhancing colors or softening the background.",
    "Experiment with Different Lighting: Use filters to simulate different lighting conditions, like golden hour or soft indoor lighting.",
    "Understand What Each Filter Does: Take a moment to read the filter descriptions to understand what each one is designed to achieve.",
    "Enhance Portraits with AI Filters: Use AI-recommended filters that soften skin tones or highlight facial features for stunning portraits.",
    "Try Cinematic Filters for a Dramatic Effect: Select cinematic filters to add a dramatic, movie-like quality to your photos.",
    "Use AI for Black & White Photography: Convert your photos to black and white with AI filters to create timeless, classic images.",
    "Apply AI Filters for Seasonal Effects: Use filters to add seasonal effects like warm tones for autumn or cool blues for winter.",
    "Save Favorite Filters for Quick Access: Use the “Save Image” feature to keep a record of your favorite filters and easily access them for future use.",
    "Enhance Colors and Contrast with AI: Let the AI optimize colors and contrast automatically for more vibrant photos.",
    "Transform Everyday Shots into Art: Use creative filters to turn ordinary images into eye-catching, artistic compositions.",
    "Experiment with Retro or Vintage Looks: Apply retro or vintage filters to give your photos a nostalgic feel.",
    "Use AI Filters for Different Moods: Choose filters based on the mood you want to convey — happy, mysterious, calm, or energetic.",
    "Make Use of Nature Filters: Try filters designed specifically for nature shots to enhance greens, blues, and earthy tones.",
    "Apply Filters Sparingly for a Natural Look: Sometimes, less is more. Apply filters subtly to retain the natural essence of your photo.",
    "Preview Filters Before Saving: Always preview the filters before saving to find the perfect look for your photo.",
    "Try AI Filters for Night Photography: Use filters to enhance low-light photos, bringing out details that might otherwise be lost.",
    "Follow Trends with AI Filters: Keep up with popular photography trends by experimenting with new filters suggested by the AI.",
    "Learn from Filter Recommendations: Observe which filters the AI suggests and learn how different filters affect different types of photos.",
  ];

  late String selectedTip;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    selectedTip = getRandomTip();
    _startTipTimer(); // Start the timer to switch tips every 5 seconds
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Function to get a random tip
  String getRandomTip() {
    final random = Random();
    return tips[random.nextInt(tips.length)];
  }

  // Function to start a timer that changes the tip every 5 seconds
  void _startTipTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      setState(() {
        selectedTip = getRandomTip();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double buttonSize = MediaQuery.of(context).size.width / 2 - 30; // Calculate button size to be square and responsive

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
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
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.count(
                crossAxisCount: 2, // Create a grid with 2 columns
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                children: [
                  // Upload button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[100], // Light red background
                      minimumSize: Size(buttonSize, buttonSize),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UploadPage()),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.file_upload, size: 50, color: Colors.red),
                        SizedBox(height: 10),
                        Text(
                          "Upload",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Camera button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[100], // Light red background
                      minimumSize: Size(buttonSize, buttonSize),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CameraPage()),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 50, color: Colors.red),
                        SizedBox(height: 10),
                        Text(
                          "Camera",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Gallery button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[100], // Light red background
                      minimumSize: Size(buttonSize, buttonSize),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GalleryPage()),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo, size: 50, color: Colors.red),
                        SizedBox(height: 10),
                        Text(
                          "Gallery",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Profile button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[100], // Light red background
                      minimumSize: Size(buttonSize, buttonSize),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person, size: 50, color: Colors.red),
                        SizedBox(height: 10),
                        Text(
                          "Profile",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Tips and Tutorials Section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200], // Light grey background for tips
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tips and Tutorials",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    selectedTip,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}