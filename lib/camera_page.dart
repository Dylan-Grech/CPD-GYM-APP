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

  Future<void> _captureImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final directory = await getExternalStorageDirectory();

      if (directory != null) {
        final String formattedDate = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
        final String filePath = '${directory.path}/Pictures/IMG_$formattedDate.jpg'; 

        final picturesDirectory = Directory('${directory.path}/Pictures');
        if (!await picturesDirectory.exists()) {
          await picturesDirectory.create(recursive: true); 
        }

        final File localImage = File(image.path);
        await localImage.copy(filePath); 

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
