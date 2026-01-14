import 'package:repalogic_messanger/utilities/common_exports.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn();

  // Get current user
  User? getCurrentUser() {
    try {
      return _firebaseAuth.currentUser;
    } catch (e) {
      log('Error getting current user: $e');
      return null;
    }
  }

  // Auth state changes
  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  // Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        final userModel = UserModel.fromFirebaseUser(
          user.uid,
          user.email ?? '',
          user.displayName ?? AppConstants.unknownUser,
          user.photoURL,
        );

        await _saveUserToFirestore(userModel);

        return userModel;
      }

      return null;
    } catch (e) {
      log('Error signing in with Google: $e');
      throw Exception('Failed to sign in with Google: ${e.toString()}');
    }
  }

  // Save or update user in Firestore
  Future<void> _saveUserToFirestore(UserModel user) async {
    try {
      final userDoc = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        await userDoc.set(user.toMap());
      } else {
        await userDoc.update({
          'displayName': user.displayName,
          'photoUrl': user.photoUrl,
          'email': user.email,
        });
      }
    } catch (e) {
      log('Error saving user to Firestore: $e');
      throw Exception('Failed to save user data: ${e.toString()}');
    }
  }

  // Get user model from Firestore
  Future<UserModel?> getUserModel(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      log('Error getting user model: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      log('Error signing out: $e');
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }

  // Check if user is signed in
  bool isSignedIn() {
    return _firebaseAuth.currentUser != null;
  }
}
