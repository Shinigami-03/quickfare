import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Sign up with email and password
  Future<String?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user data in Firestore
      await _db.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        // Add additional fields as needed
      });

      return userCredential.user!.uid; // Return user UID on success
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }

  // Sign in with email and password
  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if user exists in Firestore
      DocumentSnapshot userDoc =
          await _db.collection('users').doc(userCredential.user!.uid).get();
      if (!userDoc.exists) {
        throw Exception('User data not found');
      }

      return userCredential.user!.uid; // Return user UID on success
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Check if user is authenticated
  bool isAuthenticated() {
    return _auth.currentUser != null;
  }
}
