import 'package:cloud_firestore/cloud_firestore.dart';

/// Provides a single reference to Firestore throughout the app.
///
/// Access via `FirestoreService.instance`.
class FirestoreService {
  FirestoreService._();

  static final FirebaseFirestore instance = FirebaseFirestore.instance;
}
