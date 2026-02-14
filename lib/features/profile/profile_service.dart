import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/firestore_service.dart';

class ProfileService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FireStoreService _firestoreService = FireStoreService();
  final ImagePicker _picker = ImagePicker();

  /// Pick an image from gallery or camera
  Future<XFile?> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70, // Image compression
      );
      return image;
    } catch (e) {
      throw 'Error picking image: $e';
    }
  }

  /// Upload image to Firebase Storage and update Firestore
  Future<String> uploadProfileImage(String uid, File imageFile) async {
    try {
      // 1. Create storage reference
      final Reference ref = _storage.ref().child('users').child(uid).child('profile_image.jpg');

      // 2. Upload file
      final UploadTask uploadTask = ref.putFile(imageFile);
      
      // 3. Wait for completion and get download URL
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      // 4. Update Firestore user document
      await _firestoreService.updateUserField(uid, 'profileImageUrl', downloadUrl);

      return downloadUrl;
    } catch (e) {
      throw 'Failed to upload profile image: $e';
    }
  }
}
