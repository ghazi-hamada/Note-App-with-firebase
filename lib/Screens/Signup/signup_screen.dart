import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import '../../SignInWithGoogle/signin_with_Google.dart';
import '../../constants.dart';
import '../../home.dart';
import '../../main.dart';
import 'components/singupBackground.dart';

class singupScreen extends StatefulWidget {
  @override
  State<singupScreen> createState() => _singupScreenState();
}

class _singupScreenState extends State<singupScreen> {
  final fromKey = GlobalKey<FormState>();

  late String email, password, userName;
  bool isx = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: singupBackground(
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            width: double.infinity,
            child: Form(
              key: fromKey,
              child: ListView(
                children: <Widget>[
                  const Text(
                    'SIGN UP',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/signup.svg',
                    height: size.height * 0.35,
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                            onChanged: (value) {
                              userName = value;
                            },
                            decoration: const InputDecoration(
                              icon: Icon(
                                Icons.person,
                                color: kPrimaryColor,
                              ),
                              hintText: 'Name',
                              border: InputBorder.none,
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (Name) {
                              if (Name!.length > 100) {
                                return 'Username must not be more than 100 characters';
                              } else if (Name.length < 2) {
                                return 'Username must not be a critical two-character';
                              }
                              return null;
                            }),
                        const SizedBox(height: 10),
                        TextFormField(
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.email,
                              color: kPrimaryColor,
                            ),
                            hintText: 'Your email',
                            border: InputBorder.none,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) =>
                              email != null && !EmailValidator.validate(email)
                                  ? 'Enter a valid Email'
                                  : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          onChanged: (value) {
                            password = value;
                          },
                          obscureText: isx,
                          decoration: InputDecoration(
                              icon: const Icon(
                                Icons.lock,
                                color: kPrimaryColor,
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isx = isx == true ? false : true;
                                    });
                                  },
                                  icon: isx
                                      ? const Icon(
                                          Icons.visibility,
                                          color: kPrimaryColor,
                                        )
                                      : const Icon(
                                          Icons.visibility_off,
                                          color: kPrimaryColor,
                                        )),
                              border: InputBorder.none,
                              hintText: 'password'),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (password) =>
                              password != null && password.length < 6
                                  ? 'Enter min. 6 characters'
                                  : null,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Don't have an Account ?",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, 'login');
                        },
                        child: const Text(
                          ' Log in',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      width: size.width * 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 40,
                            ),
                            backgroundColor: kPrimaryColor, // foreground
                          ),
                          onPressed: () async {
                            final isValid = fromKey.currentState!.validate();
                            if (!isValid) {
                              return;
                            }
                            showLoading(context);
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .add({
                                'username': userName,
                                'email': email,
                              });
                              // ignore: use_build_context_synchronously
                              Get.offNamedUntil('/home', (route) => false);
                            } on FirebaseAuthException catch (e) {
                              print(e);
                            }
                            navigatorKey.currentState!
                                .popUntil((route) => route.isFirst);
                          },
                          child: const Text('SIGNUP'),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      width: size.width * 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 40,
                            ),
                            backgroundColor: const Color.fromARGB(
                                31, 234, 234, 234), // foreground
                          ),
                          icon: const FaIcon(
                            FontAwesomeIcons.google,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            final provider = Provider.of<GoogleSignInPrpvider>(
                                context,
                                listen: false);
                            provider.signInWithGoogle();
                          },
                          label: const Text('Sign up with Google'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
