import 'package:digit_market/homepagecontent.dart';
import 'package:digit_market/signup_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SigninClient extends StatefulWidget {
  const SigninClient({super.key});

  @override
  State<SigninClient> createState() => _SigninClientState();
}

class _SigninClientState extends State<SigninClient> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool _obscurePassword = true;

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
                  const SizedBox(height: 30),
                  Image.asset(
                    'images/logo.png',
                    width: 200.w,
                    height: 200.h,
                    fit: BoxFit.cover,
                  ),
                  30.verticalSpace,
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
                          color: const Color(0xFF0F2F63),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(75.r),
                        borderSide: const BorderSide(color: Color(0xFF0F2F63)),
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
                      }
                      return null;
                    },
                  ),
                  20.verticalSpace,
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Mot de passe oublié ? ",
                        style: TextStyle(
                          color: const Color(0xFF0F2F63),
                          fontSize: 17.sp,
                        ),
                      ),
                    ),
                  ),
                  50.verticalSpace,
                  SizedBox(
                    height: 60.h,
                    width: 300.w,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F2F63),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(75.r),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
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
                            if (e.code == 'user-not-found') {
                              _showError(
                                "Aucun utilisateur trouvé pour cet e-mail.",
                              );
                            } else if (e.code == 'wrong-password') {
                              _showError("Mot de passe incorrect.");
                            } else {
                              _showError("Erreur: ${e.message}");
                            }
                          } catch (e) {
                            _showError("Erreur inconnue: $e");
                          }
                        }
                      },
                      child: const Text(
                        'Se connecter',
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
                        "Vous n’avez pas de compte ?",
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
                              builder: (context) => const SignupClient(),
                            ),
                          );
                        },
                        child: Text(
                          "S’inscrire",
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
