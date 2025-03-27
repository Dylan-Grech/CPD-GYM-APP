import 'package:flutter/material.dart';
import 'firestore_service.dart';

class AddExercisePage extends StatefulWidget {
  @override
  _AddExercisePageState createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _muscleGroupController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  // Save the exercise
  void _saveExercise() {
    final name = _nameController.text;
    final description = _descriptionController.text;
    final muscleGroup = _muscleGroupController.text;

    if (name.isNotEmpty && description.isNotEmpty && muscleGroup.isNotEmpty) {
      _firestoreService.saveExercise(name, description, muscleGroup).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exercise saved!')));
        _nameController.clear();
        _descriptionController.clear();
        _muscleGroupController.clear();
      });
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
              onPressed: _saveExercise,
              child: Text('Save Exercise'),
            ),
          ],
        ),
      ),
    );
  }
}
