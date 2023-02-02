import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_flutter/Models/user.dart' as model;
import 'package:instagram_flutter/resources/storage_method.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sign in  user

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "some erorr";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty) {
        final cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String strPhotoURL = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        model.User user = model.User(
          email: email,
          uid: cred.user!.uid.toString(),
          photoUrl: strPhotoURL,
          username: username,
          bio: bio,
          followers: [],
          following: [],
        );

        _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  //logging in user

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "some error";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "please enter all fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
