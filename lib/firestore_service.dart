import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save a new exercise
  Future<void> saveExercise(String name, String description, String muscleGroup, String? imagePath) async {
    try {
      await _db.collection('exercises').add({
        'name': name,
        'description': description,
        'muscleGroup': muscleGroup,
        'imagePath': imagePath,  // Save the image path or URL
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      print("Error saving exercise: $e");
    }
  }

  // Get all exercises
  Future<List<Map<String, dynamic>>> getExercises() async {
    try {
      QuerySnapshot snapshot = await _db.collection('exercises').get();
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'name': data['name'],
          'description': data['description'],
          'muscleGroup': data['muscleGroup'],
          'imagePath': data['imagePath'],  // Retrieve image path or URL
        };
      }).toList();
    } catch (e) {
      print("Error fetching exercises: $e");
      return [];
    }
  }
}
