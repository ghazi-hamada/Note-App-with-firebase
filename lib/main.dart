import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'Screens/Login/login_screen.dart';
import 'Screens/Signup/signup_screen.dart';
import 'Screens/crud/addNode.dart';
import 'Screens/crud/editNites.dart';
import 'Screens/forgot_password/forgot_Passwprd.dart';
import 'Screens/verify_Email/verify_email.dart';
import 'Screens/welcome/components/body.dart';
import 'Screens/welcome/welcome_screene.dart';
import 'SignInWithGoogle/signin_with_Google.dart';
import 'constants.dart';
import 'home.dart';

Future<void> _firebadeMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebadeMessagingBackgroundHandler);

  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInPrpvider(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        // scaffoldMessengerKey: Utils.messengerkey,
        navigatorKey: navigatorKey,
        title: 'Flutter Firebase',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const MainPage(),
        getPages: [
          GetPage(name: '/login', page: () => loginScreen()),
          GetPage(name: '/singup', page: () => singupScreen()),
          GetPage(name: '/forgot', page: () => const ForgotPassword()),
          GetPage(name: '/addNodes', page: () => const addNodes()),
          GetPage(name: '/home', page: () => const HomePage()),
          GetPage(name: '/welcome', page: () => const WelcomeScreen()),
          GetPage(name: '/editNodes', page: () => const EditNotes()),
        ],
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong!'),
              );
            } else if (snapshot.hasData) {
              return const VerifyEmail();
            } else {
              return body();
            }
          },
        ),
      );
}
