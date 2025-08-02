import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digit_market/notification.dart';
import 'package:digit_market/paimentpage.dart';
import 'package:digit_market/passwordsecurity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePageClient extends StatefulWidget {
  const ProfilePageClient({super.key});

  @override
  State<ProfilePageClient> createState() => _ProfilePageClientState();
}

class _ProfilePageClientState extends State<ProfilePageClient> {
  User? user;
  Map<String, dynamic>? userData;
  Map<String, dynamic>? boutiqueData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  bool forceTestMode = true; //

  Future<void> fetchData() async {
    try {
      if (forceTestMode) {
        userData = {
          'nom': 'Client Test',
          'email': 'client@test.com',
          'boutiqueId': null,
        };
        boutiqueData = {'nom': 'Boutique Test'};
        setState(() {
          isLoading = false;
          errorMessage = null;
        });
        return;
      }

      user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        setState(() {
          errorMessage = "Non connecté";
          isLoading = false;
        });
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      userData = userDoc.data();

      if (userData == null) {
        setState(() {
          errorMessage = "Utilisateur introuvable dans Firestore.";
          isLoading = false;
        });
        return;
      }

      final boutiqueId = userData!['boutiqueId'];
      if (boutiqueId != null) {
        final boutiqueDoc = await FirebaseFirestore.instance
            .collection('boutiques')
            .doc(boutiqueId)
            .get();
        if (boutiqueDoc.exists) {
          boutiqueData = boutiqueDoc.data();
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Erreur : $e";
        isLoading = false;
      });
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Text(errorMessage!, style: TextStyle(color: Colors.red)),
        ),
      );
    }

    final nom = userData?['nom'] ?? 'Client';
    final email = userData?['email'] ?? 'email inconnu';
    final boutique = boutiqueData?['nom'] ?? 'Aucune boutique';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30.h),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 35.r,
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 32.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nom,
                          style: GoogleFonts.montserrat(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          email,
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.settings, color: Colors.blue, size: 26.sp),
                  ],
                ),
                SizedBox(height: 20.h),
                Text("Boutique : $boutique", style: TextStyle(fontSize: 14.sp)),
                SizedBox(height: 30.h),

                _buildMenuItem(Icons.credit_card, 'Méthodes de paiement', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PaiementPage()),
                  );
                }),
                _buildMenuItem(Icons.lock, 'Mot de passe et sécurité', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PasswordSecurityPage()),
                  );
                }),
                _buildMenuItem(Icons.favorite, 'Favoris', () {}),
                _buildMenuItem(Icons.notifications, 'Notification', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NotificationPage()),
                  );
                }),
                _buildMenuItem(Icons.logout, 'Déconnexion', signOut),

                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 16.sp,
                    color: Colors.black,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
