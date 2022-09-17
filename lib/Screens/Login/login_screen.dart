import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../main.dart';
import 'components/Background.dart';

class loginScreen extends StatefulWidget {
  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  late String email, password;

  final fromKey = GlobalKey<FormState>();

  bool showSpinnar = false;

  bool isx = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BackgroundLogin(
      child: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: double.infinity,
          child: Form(
            key: fromKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'LOGIN',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.03),
                Center(
                  child: SvgPicture.asset(
                    'assets/icons/login.svg',
                    height: size.height * 0.35,
                  ),
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
                          email = value;
                        },
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.person,
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
                    ],
                  ),
                ),
                //Button
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
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
                              .signInWithEmailAndPassword(
                                  email: email, password: password);
                          // ignore: use_build_context_synchronously
                          Get.offNamedUntil('/home', (route) => false);
                        } on FirebaseAuthException catch (e) {
                          print(e);
                        }
                        navigatorKey.currentState!
                            .popUntil((route) => route.isFirst);
                      },
                      child: const Text('LOGIN'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'forgot'),
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 20,
                    ),
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
                        Navigator.pushReplacementNamed(context, 'singup');
                      },
                      child: const Text(
                        ' Sign up',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: kPrimaryColor),
                      ),
                    ),
                  ],
                ),
                //const OrDivider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
