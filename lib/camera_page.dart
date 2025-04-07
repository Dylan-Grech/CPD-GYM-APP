import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _captureImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final directory = await getApplicationDocumentsDirectory(); // Get app's documents directory

      if (directory != null) {
        // Define the file path for saving the image
        final String formattedDate = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
        final String filePath = '${directory.path}/Pictures/IMG_$formattedDate.jpg'; 

        // Ensure the Pictures directory exists
        final picturesDirectory = Directory('${directory.path}/Pictures');
        if (!await picturesDirectory.exists()) {
          await picturesDirectory.create(recursive: true); // Create the directory if it doesn't exist
        }

        // Save the image in the Pictures directory
        final File localImage = File(image.path);
        await localImage.copy(filePath);

        print("Image saved at: $filePath");

        // Pass the saved file path back to the previous page
        Navigator.pop(context, filePath);
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
          child: Text('Capture Exercise Photo'),
        ),
      ),
    );
  }
}
