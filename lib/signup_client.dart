import 'package:digit_market/firstpage.dart';
import 'package:digit_market/homepage.dart';
import 'package:digit_market/homepagecontent.dart';
import 'package:digit_market/signin_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupClient extends StatefulWidget {
  const SignupClient({super.key});

  @override
  State<SignupClient> createState() => _SignupClientState();
}

class _SignupClientState extends State<SignupClient> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController username = TextEditingController();

  bool _obscurePassword = true;

  // Email validation regex
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        color: const Color(0X00ffffff),
        child: Padding(
          padding: EdgeInsets.all(15.10.r),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  30.verticalSpace,
                  Image.asset(
                    'images/logo.png',
                    width: 200.w,
                    height: 200.h,
                    fit: BoxFit.cover,
                  ),
                  30.verticalSpace,
                  // Username Field
                  TextFormField(
                    controller: username,
                    decoration: InputDecoration(
                      hintText: "Entrer votre nom d’utilisateur",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(75.r),
                        borderSide: const BorderSide(color: Color(0XFF0F2F63)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(75.r),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 243, 240, 240),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(75.r),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 243, 240, 240),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un nom d\'utilisateur';
                      }
                      return null;
                    },
                  ),
                  30.verticalSpace,
                  // Email Field
                  TextFormField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Entrer votre e-mail",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(75.r),
                        borderSide: const BorderSide(color: Color(0XFF0F2F63)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(75.r),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 243, 240, 240),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(75.r),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 243, 240, 240),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un email';
                      } else if (!isValidEmail(value)) {
                        return 'Adresse e-mail invalide';
                      }
                      return null;
                    },
                  ),
                  30.verticalSpace,
                  // Password Field
                  TextFormField(
                    controller: password,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: "Entrer votre mot de passe",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color(0XFF0F2F63),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(75.r),
                        borderSide: const BorderSide(color: Color(0XFF0F2F63)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(75.r),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 243, 240, 240),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(75.r),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 243, 240, 240),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre mot de passe';
                      } else if (value.length < 6) {
                        return 'Le mot de passe doit contenir au moins 6 caractères';
                      }
                      return null;
                    },
                  ),
                  50.verticalSpace,
                  // Sign Up Button
                  SizedBox(
                    height: 60.h,
                    width: 300.w,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F2F63),
                        foregroundColor: const Color(0xFF0F2F63),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(75.r),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                  email: email.text.trim(),
                                  password: password.text,
                                );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePageClient(),
                              ),
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              _showError('Le mot de passe est trop faible.');
                            } else if (e.code == 'email-already-in-use') {
                              _showError(
                                'Un compte existe déjà pour cet email.',
                              );
                            }
                          } catch (e) {
                            _showError('Erreur inconnue: $e');
                          }
                        }
                      },
                      child: const Text(
                        'S’inscrire',
                        style: TextStyle(
                          fontFamily: 'LibreCaslonText',
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  30.verticalSpace,
                  Row(
                    children: [
                      Text(
                        "Vous avez déjà un compte ?",
                        style: TextStyle(
                          fontSize: 17.sp,
                          color: const Color.fromARGB(255, 0, 1, 4),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SigninClient(),
                            ),
                          );
                        },
                        child: Text(
                          "Se connecter",
                          style: TextStyle(
                            color: const Color(0xFF0F2F63),
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
