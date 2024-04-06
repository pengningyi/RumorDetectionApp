import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // AuthService() {
  //   initializeFirebaseApp();
  // }

  // Future<void> initializeFirebaseApp() async {
  //   try {
  //     await Firebase.initializeApp(
  //       name: 'perfectcv-60a9f',
  //       options: DefaultFirebaseOptions.currentPlatform,
  //     );
  //     print("Firebase initialized successfully!");
  //   } catch (e) {
  //     print('Failed to initialize Firebase: $e');
  //   }
  // }

  Future<User?> signInWithEmailAndPassword(String emailOrUsername, String password) async {
    try {
      UserCredential result;
      if (emailOrUsername.contains('@')) {
        result = await _auth.signInWithEmailAndPassword(email: emailOrUsername, password: password);
      } else {
        // 使用用户名登录
        result = await _auth.signInWithEmailAndPassword(email: '$emailOrUsername@perfectcv.com', password: password);
      }
      print("Sign In Successfully!");
      return result.user;
    } catch (e) {
      print('Failed to sign in: $e');
      return null;
    }
  }

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      // 显示提示消息
      print("Sign Up Successfully!");

      return result.user;
    } catch (e) {
      print('Failed to sign up: $e');
      return null;
    }
  }

  // 用户注销
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 获取当前登录用户
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // 监听认证状态变化
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}
