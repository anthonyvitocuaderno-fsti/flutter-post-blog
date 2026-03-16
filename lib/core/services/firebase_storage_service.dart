import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a file to Firebase Storage and returns the download URL
  Future<String?> uploadFile({
    required File file,
    required String folderName,
  }) async {
    try {
      // Create a unique filename
      String fileName = '${DateTime.now().millisecondsSinceEpoch}${p.extension(file.path)}';
      Reference ref = _storage.ref(folderName).child(fileName);

      // Upload file
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  /// Deletes a file from Firebase Storage
  Future<void> deleteFile(String fileUrl) async {
    try {
      await _storage.refFromURL(fileUrl).delete();
    } catch (e) {
      print('Error deleting file: $e');
    }
  }
}