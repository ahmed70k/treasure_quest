import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../services/firestore_service.dart';
import '../../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // التعديل هنا: استخدام الإعدادات الافتراضية بشكل صريح
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  final FireStoreService _fireStoreService = FireStoreService();

  // Stream to listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user UID
  String? get currentUserUid => _auth.currentUser?.uid;

  // Get current user object
  User? get currentUser => _auth.currentUser;

  // Sign in with Email and Password
  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        return await _fireStoreService.getUserData(credential.user!.uid);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign up with Email and Password
  Future<UserModel?> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      if (credential.user != null) {
        UserModel newUser = await _createInitialUserDocument(credential.user!.uid, username, email);
        return newUser;
      }

      return null;
    } on FirebaseAuthException catch (e) {
      // التعامل مع حالة الـ Race Condition:
      if (e.code == 'email-already-in-use' && _auth.currentUser?.email == email) {
        return await _fireStoreService.getUserData(_auth.currentUser!.uid);
      }
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  /// وظيفة داخلية لإنشاء مستند المستخدم الأولي
  Future<UserModel> _createInitialUserDocument(String uid, String username, String email) async {
    final newUser = UserModel(
      id: uid,
      name: username,
      email: email,
      createdAt: DateTime.now(),
      points: 0,
      treasures: [],
    );
    await _fireStoreService.saveUserData(newUser);
    return newUser;
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // تأكد من تسجيل الخروج أولاً لضمان ظهور قائمة الحسابات
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw 'Google Sign-In failed. Please try again.';
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Handle Firebase Exceptions
  String _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}