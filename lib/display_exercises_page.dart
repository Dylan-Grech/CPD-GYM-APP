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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image on the left
                      exercise['imagePath'] != null
                          ? Image.network(
                              exercise['imagePath'], // Use the image URL from Firestore
                              width: 60, // Adjust the size of the image as needed
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.image_not_supported, size: 60), // Default icon if image is missing

                      SizedBox(width: 16), // Space between image and text

                      // Text on the right
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
                              overflow: TextOverflow.ellipsis, // Prevent overflow
                              maxLines: 2, // Limit to 2 lines
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
