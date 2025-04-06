import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveExercise(String name, String description, String muscleGroup, String? imagePath) async {
    try {
      await _db.collection('exercises').add({
        'name': name,
        'description': description,
        'muscleGroup': muscleGroup,
        'imagePath': imagePath,  
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
          'imagePath': data['imagePath'],  
        };
      }).toList();
    } catch (e) {
      print("Error fetching exercises: $e");
      return [];
    }
  }
}
