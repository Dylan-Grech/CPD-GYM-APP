import 'package:flutter/material.dart';
import 'firestore_service.dart';

class DisplayExercisesPage extends StatefulWidget {
  @override
  _DisplayExercisesPageState createState() => _DisplayExercisesPageState();
}

class _DisplayExercisesPageState extends State<DisplayExercisesPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> _exercises = [];

  // Fetch exercises from Firestore
  void _loadExercises() async {
    var exercises = await _firestoreService.getExercises();
    setState(() {
      _exercises = exercises;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Exercises')),
      body: _exercises.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _exercises.length,
              itemBuilder: (context, index) {
                var exercise = _exercises[index];
                return ListTile(
                  title: Text(exercise['name']),
                  subtitle: Text(exercise['muscleGroup']),
                  trailing: Text(exercise['description']),
                );
              },
            ),
    );
  }
}
