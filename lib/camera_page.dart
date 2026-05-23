import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import './display_page.dart';
import './rotated_filter_screen.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller; // Make the controller nullable
  Future<void>? _initializeControllerFuture;
  late String _lastCapturedImage;
  late List<CameraDescription> _cameras; // List to hold available cameras
  int _selectedCameraIndex = 0; // Track which camera is selected
  bool _isSwitchingCamera = false; // Flag to indicate camera switching
  String? _cameraError;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _lastCapturedImage = ''; // Placeholder for the last captured image
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras(); // Get available cameras
      if (!mounted) return;
      if (_cameras.isEmpty) {
        setState(() {
          _cameraError = 'No camera is available on this device.';
        });
        return;
      }
      _onNewCameraSelected(_cameras[_selectedCameraIndex]); // Initialize with the selected camera
    } catch (e) {
      print('Error initializing cameras: $e');
      if (!mounted) return;
      setState(() {
        _cameraError = 'Unable to access the camera.';
      });
    }
  }

  void _onNewCameraSelected(CameraDescription cameraDescription) async {
    if (!mounted) return;
    setState(() {
      _isSwitchingCamera = true; // Set flag to true when switching camera
    });

    if (_controller != null) {
      await _controller!.dispose(); // Dispose of the previous controller safely
    }
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
    );

    try {
      _initializeControllerFuture = _controller!.initialize();
      if (!mounted) return;
      setState(() {
        _isSwitchingCamera = false; // Reset flag after initializing the camera
      });
    } catch (e) {
      print('Error initializing the selected camera: $e');
      if (!mounted) return;
      setState(() {
        _cameraError = 'Unable to start the camera.';
        _isSwitchingCamera = false;
      });
    }
  }

  void _switchCamera() {
    if (_cameras.isEmpty) return;
    setState(() {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length; // Switch between cameras
      _onNewCameraSelected(_cameras[_selectedCameraIndex]); // Update camera
    });
  }

  @override
  void dispose() {
    _controller?.dispose(); // Dispose of the camera controller safely
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _cameraError != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  _cameraError!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            )
          : _initializeControllerFuture == null || _isSwitchingCamera
          ? Container(color: Colors.black) // Display black screen while switching cameras
          : FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                if (_controller != null && _controller!.value.isInitialized) // Check if the controller is initialized
                  Positioned.fill(
                    child: CameraPreview(_controller!),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.black.withOpacity(0.5), // Semi-transparent black surface
                    height: 120.0,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Last captured image preview (go to gallery)
                        GestureDetector(
                          onTap: () {
                            if (_lastCapturedImage.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DisplayPage(
                                    imagePath: _lastCapturedImage,
                                    filterName: 'default',
                                  ),
                                ),
                              );
                            }
                          },
                          child: _lastCapturedImage.isEmpty
                              ? Icon(Icons.photo_library, color: Colors.white, size: 40.0)
                              : Image.file(
                            File(_lastCapturedImage),
                            width: 40.0,
                            height: 40.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Shutter button as a white ring
                        GestureDetector(
                          onTap: () async {
                            try {
                              if (_controller != null && _controller!.value.isInitialized) {
                                final image = await _controller!.takePicture();
                                if (!mounted || !context.mounted) return;
                                setState(() {
                                  _lastCapturedImage = image.path; // Update last captured image
                                });

                                // Navigate to FilterScreen after the image is captured
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RotatedFilterScreen(imagePath: _lastCapturedImage),
                                  ),
                                );
                              }
                            } catch (e) {
                              print('Error taking picture: $e');
                            }
                          },
                          child: Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 5.0),
                              color: Colors.transparent,
                            ),
                            child: Center(
                              child: Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Camera switch button
                        IconButton(
                          icon: Icon(Icons.switch_camera, color: Colors.white, size: 40.0),
                          onPressed: _switchCamera, // Call the switch camera method
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Container(color: Colors.black); // Display black screen on error
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}
