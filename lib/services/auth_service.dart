import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final userCredential = await _auth.signInWithCredential(credential);

      // Create/update user document in Firestore
      await _createUserDocument(userCredential.user);

      return userCredential;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  // Send phone verification code
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  // Sign in with phone number verification code
  Future<UserCredential?> signInWithPhoneNumber(
      String verificationId,
      String smsCode,
      ) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // Create/update user document in Firestore
      await _createUserDocument(userCredential.user);

      return userCredential;
    } catch (e) {
      print('Error signing in with phone number: $e');
      return null;
    }
  }

  // Create user document in Firestore
  Future<void> _createUserDocument(User? user) async {
    if (user == null) return;

    final userDoc = _firestore.collection('users').doc(user.uid);
    final userData = await userDoc.get();

    if (!userData.exists) {
      // Get user info from authentication providers
      String displayName = user.displayName ?? 'HARK User';
      String photoURL = user.photoURL ?? '';
      String email = user.email ?? '';
      String phoneNumber = user.phoneNumber ?? '';

      // Create new user document
      await userDoc.set({
        'userId': user.uid,
        'displayName': displayName,
        'email': email,
        'phoneNumber': phoneNumber,
        'photoURL': photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'bio': '',
        'followers': 0,
        'following': 0,
      });
    } else {
      // Update existing user document
      await userDoc.update({
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}