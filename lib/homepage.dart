import 'package:digit_market/firstpage.dart';
import 'package:digit_market/productpage.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeContentPageClient extends StatelessWidget {
  const HomeContentPageClient({Key? key}) : super(key: key);

  Stream<List<Map<String, dynamic>>> getProduits() {
    return FirebaseFirestore.instance
        .collection('produits')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<List<Map<String, dynamic>>> getBoutiques() {
    return FirebaseFirestore.instance
        .collection('boutiques')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70.h,
        title: Text(''),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 30.sp,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: ListView(
            children: [
              Text(
                'Boutiques',
                style: GoogleFonts.montserrat(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                height: 100.h,
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: getBoutiques(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Aucune boutique'));
                    }

                    final boutiques = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: boutiques.length,
                      itemBuilder: (context, index) {
                        final boutique = boutiques[index];
                        final nom = boutique['nom'] ?? 'Nom boutique';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => firstpage(
                                  //boutique: boutique),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            // ... ton container existant pour boutique
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Catégories',
                style: GoogleFonts.montserrat(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  3,
                  (index) => Container(
                    width: 90.w,
                    height: 90.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                    ),
                    child: Icon(
                      Icons.category,
                      color: Colors.black,
                      size: 30.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Produits',
                style: GoogleFonts.montserrat(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20.h),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: getProduits(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Aucun produit'));
                  }

                  final produits = snapshot.data!;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: produits.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.h,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final produit = produits[index];
                      final nom = produit['nom'] ?? 'Nom';
                      final prix = produit['prix']?.toString() ?? '---';

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailPage(produit: produit),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_bag,
                                color: Colors.green,
                                size: 40.sp,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                nom,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '$prix DA',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 70.h),
            ],
          ),
        ),
      ),
    );
  }
}
