// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// class AccountModel {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Stream<User?> get authChanges => _auth.authStateChanges();
//   Future<void> registerUser({required String email, required String password, required String number, required int age,}) async {
//     try{
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//
//       String uid = userCredential.user!.uid;
//
//       await _firestore.collection('users').doc(uid).set({
//         'email' : email,
//         'createAt':FieldValue.serverTimestamp(),
//         'number':number,
//         'age':age,
//       });
//
//       print('User registered: $uid');
//     } on FirebaseAuthException catch (e){
//       if(e.code == 'email-already-in-use'){
//         print("User already exists with this email");
//       }else {
//         print("Registration Failed: ${e.message}");
//       }
//     }
//   }
//
//   Future<bool> signInWithGoogle(BuildContext context) async {
//     bool res=false;
//     try{
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth?.accessToken,
//         idToken: googleAuth?.idToken,
//       );
//
//       UserCredential userCredential =await _auth.signInWithCredential(credential);
//       User? user = userCredential.user;
//       if(user != null){
//         if(userCredential.additionalUserInfo!.isNewUser){
//           print("Check7");
//           await _firestore.collection('users').doc(user.uid).set({
//             'username' : user.displayName,
//             'uid':user.uid,
//             'profilePhoto':user.photoURL,
//
//           });
//
//         }
//         res = true;
//       }
//     } on FirebaseAuthException catch(e){
//
//       res = false;
//     }
//     return res;
//   }
// }