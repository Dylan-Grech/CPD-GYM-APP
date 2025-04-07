import 'package:flutter/material.dart';
import 'firestore_service.dart';
import 'camera_page.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'image_gallery_page.dart';

class AddExercisePage extends StatefulWidget {
  @override
  _AddExercisePageState createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _muscleGroupController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  String? _imagePath;
  

  // Save the exercise
  void _saveExercise() {
    final name = _nameController.text;
    final description = _descriptionController.text;
    final muscleGroup = _muscleGroupController.text;

    if (name.isNotEmpty && description.isNotEmpty && muscleGroup.isNotEmpty && _imagePath != null) {
      _firestoreService.saveExercise(name, description, muscleGroup, _imagePath).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exercise saved!')));
        _nameController.clear();
        _descriptionController.clear();
        _muscleGroupController.clear();
      });
    } else if (_imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please capture a photo')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields and capture a photo')));
    }
  }

  Future<void> _requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();

    if (status.isGranted) {
      final imagePath = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraPage()),
      );

      if (imagePath != null) {
        setState(() {
          _imagePath = imagePath;
        });
      }
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Camera permission is required to capture a photo')));
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enable camera permission in settings')));
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Exercise')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Semantics(
              label: 'Enter Exercise Name',
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Exercise Name'),
              ),
            ),
            SizedBox(height: 16),
            Semantics(
              label: 'Enter Description of Exercise',
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description of Exercise'),
              ),
            ),
            SizedBox(height: 16),
            Semantics(
              label: 'Enter Muscle Group',
              child: TextField(
                controller: _muscleGroupController,
                decoration: InputDecoration(labelText: 'Muscle Group'),
              ),
            ),
            SizedBox(height: 16),
            Semantics(
              label: 'Capture Exercise Photo',
              button: true,
              child: ElevatedButton(
                onPressed: _requestCameraPermission,  
                child: Text('Capture Exercise Photo'),
              ),
            ),
            SizedBox(height: 16),
            Semantics(
              label: 'Save Exercise',
              button: true,
              child: ElevatedButton(
                onPressed: _saveExercise,
                child: Text('Save Exercise'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
