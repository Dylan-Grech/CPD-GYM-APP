import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  // Capture and save the image to the Pictures folder
  Future<void> _captureImage() async {
    // Capture the image from camera
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      // Get the directory for the external storage Pictures folder
      final directory = await getExternalStorageDirectory();

      if (directory != null) {
        // Create a path for the image to be saved
        final String formattedDate = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
        final String filePath = '${directory.path}/Pictures/IMG_$formattedDate.jpg'; // Picture folder path

        // Ensure the Pictures directory exists
        final picturesDirectory = Directory('${directory.path}/Pictures');
        if (!await picturesDirectory.exists()) {
          await picturesDirectory.create(recursive: true); // Create the Pictures directory if it doesn't exist
        }

        // Save the captured image to the Pictures directory
        final File localImage = File(image.path);
        await localImage.copy(filePath); // Copy the file to the Pictures folder

        // Optionally, you can display the saved image or navigate back with the path
        Navigator.pop(context, filePath); // Passing the saved file path back
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Capture Exercise Photo')),
      body: Center(
        child: ElevatedButton(
          onPressed: _captureImage,
          child: Text('Capture Image'),
        ),
      ),
    );
  }
}
