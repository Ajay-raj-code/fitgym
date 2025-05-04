
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final dbRef = FirebaseDatabase.instance.ref();



  User? get user => _auth.currentUser;

  Future<bool> signInWithGoogle() async {

    bool res=false;
    try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      if(user != null){
        if(userCredential.additionalUserInfo!.isNewUser){

          await dbRef.child('users').child(user.uid).set({
            'username' : user.displayName,
            'email':user.email,
            'email_verified':user.emailVerified,
            'phone':user.phoneNumber,
            'uid':user.uid,
            'profilePhoto':user.photoURL,

          });

        }
        res = true;
      }
    } on FirebaseAuthException catch(e){

      res = false;
    }
    return res;
  }
  Future<bool> registerWithEmail({required String email,required String password,required String phone,required String name}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.toLowerCase(),
        password: password,
      );
      User? user = userCredential.user;

      if(user != null){
        user.sendEmailVerification();
        await dbRef.child('users').child(user.uid).set({
          'username' : name,
          'email':user.email,
          'email_verified':false,
          'phone':phone,
          'uid':user.uid,
          'profilePhoto':user.photoURL,

        });
      }

      return true;
    } on FirebaseAuthException catch (e){
      if(e.code == 'email-already-in-use'){

      }else {
      }
      return false;
    }
  }


  Future<bool> loginWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.toLowerCase(),
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      return false;
    }
  }


  Future<void> signOut() async {
    await _auth.signOut();
  }
}
Future<Map<String, String>> getAppSettings() async {
  final doc = await FirebaseFirestore.instance
      .collection('Document')
      .doc('appSettings')
      .get();

  Map<String, String> result = {'version': doc.data()!['app_version'].toString(), 'update_url': doc.data()!['update_url'].toString() };
  return result;
}