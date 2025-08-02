import 'package:digit_market/signup_client.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class firstpage extends StatefulWidget {
  const firstpage({super.key});

  @override
  State<firstpage> createState() => _firstpageState();
}

class _firstpageState extends State<firstpage> {
  late Timer timer;
  void initState() {
    super.initState();
    timer = Timer(Duration(seconds: 3), () {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => SignupClient()));
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'images/logo.png', // Remplacez par l'URL de votre image
          width: 300.w,
          height: 300.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
