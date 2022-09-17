import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../home.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final user = FirebaseAuth.instance.currentUser;

  bool isEmailVerifed = false;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    isEmailVerifed = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerifed) {
      sendVerificationEmail();
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerifief,
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      print(e.toString());
    }
  }

  Future checkEmailVerifief() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(
      () {
        isEmailVerifed = FirebaseAuth.instance.currentUser!.emailVerified;
      },
    );
    if (isEmailVerifed) timer?.cancel();
  }

  @override
  Widget build(BuildContext context) =>
  //قمت بتوقيف عملية المصادقة ✅
      // isEmailVerifed ?
      const HomePage();
  // :
  //      Scaffold(
  //         appBar: AppBar(
  //           actions: [
  //             IconButton(
  //                 onPressed: () async => await FirebaseAuth.instance.signOut(),
  //                 icon: const Icon(Icons.close))
  //           ],
  //           title: const Text('Verify Email'),
  //         ),
  //         body: Center(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(
  //                 user!.email!,
  //                 style: const TextStyle(
  //                     fontSize: 20, fontWeight: FontWeight.bold),
  //               ),
  //               ElevatedButton(
  //                 onPressed: sendVerificationEmail,
  //                 child: const Text(
  //                   'verify',
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
}
