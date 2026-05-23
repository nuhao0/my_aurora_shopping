import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a file to Firebase Storage and returns the public download URL.
  Future<String?> uploadProfileImage(String uid, File file) async {
    try {
      // Create a reference to 'profile_images/UID.jpg'
      final ref = _storage.ref().child('profile_images').child('$uid.jpg');

      // Upload the file
      final uploadTask = ref.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      // Wait for completion
      final snapshot = await uploadTask.whenComplete(() => {});

      // Return the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      debugPrint('LOG: Image successfully uploaded to Firebase Storage: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('LOG ERROR: Failed to upload image to Firebase Storage: $e');
      return null;
    }
  }
  /// Uploads an image for the camera search feature to Firebase Storage.
  Future<String?> uploadSearchImage(File file) async {
    try {
      final fileName = 'search_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('image-search').child(fileName);

      final uploadTask = ref.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      debugPrint('LOG: Search Image uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('LOG ERROR: Failed to upload search image: $e');
      return null;
    }
  }
}
