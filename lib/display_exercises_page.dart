import 'package:flutter/material.dart';
import 'firestore_service.dart';

class DisplayExercisesPage extends StatefulWidget {
  @override
  _DisplayExercisesPageState createState() => _DisplayExercisesPageState();
}

class _DisplayExercisesPageState extends State<DisplayExercisesPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> _exercises = [];

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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      

                      SizedBox(width: 16), 

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exercise['name'],
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 4),
                            Text(
                              exercise['muscleGroup'],
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            SizedBox(height: 4),
                            Text(
                              exercise['description'],
                              style: TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis, 
                              maxLines: 2, 
                            ),
                            Text(
                              exercise['imagePath'],
                              style: TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis, 
                              maxLines: 2, 
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
