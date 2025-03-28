import 'package:flutter/material.dart';
import 'firestore_service.dart';
import 'camera_page.dart';
import 'dart:io';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Exercise')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Exercise Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description of Exercise'),
            ),
            TextField(
              controller: _muscleGroupController,
              decoration: InputDecoration(labelText: 'Muscle Group'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final imagePath = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraPage()),
                );

                if (imagePath != null) {
                  setState(() {
                    _imagePath = imagePath;  
                  });
                }
              },
              child: Text('Capture Exercise Photo'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveExercise,
              child: Text('Save Exercise'),
            ),
          ],
        ),
      ),
    );
  }
}
