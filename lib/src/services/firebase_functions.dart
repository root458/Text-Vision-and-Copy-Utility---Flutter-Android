import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // CHeck if signed in
  bool signedIn() {
    if (_auth.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  // Sign in anon
  Future signInAnon() async {
    try {
      UserCredential userCred = await _auth.signInAnonymously();
      return userCred.user;
    } catch (e) {
      // Do nothing
    }
  }
}

class DataBase {
  
  // Users collection
  final CollectionReference textsCollection =
      FirebaseFirestore.instance.collection('texts_collection');

  // Update user data
  Future addCopiedText(Map<String, String> textDetails) async {
    await textsCollection.doc(textDetails['date']).set(textDetails);
  }

}
