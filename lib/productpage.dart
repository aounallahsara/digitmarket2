import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> produit;

  const ProductDetailPage({super.key, required this.produit});

  @override
  Widget build(BuildContext context) {
    final String nom = produit['nom'] ?? 'Nom inconnu';
    final String prix = produit['prix']?.toString() ?? '---';
    final String description = produit['description'] ?? 'Aucune description';
    final bool disponible = produit['stock'] == true;
    final String imageUrl = produit['image'] ?? produit['imageUrl'] ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70.h,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Icon(Icons.shopping_cart_outlined, size: 30.sp),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image produit
            SizedBox(height: 50.h),
            Container(
              width: double.infinity,
              height: 300.h,
              margin: EdgeInsets.only(top: 10.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.network(imageUrl, fit: BoxFit.cover),
                    )
                  : Center(
                      child: Text(
                        'image de produit',
                        style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                      ),
                    ),
            ),

            SizedBox(height: 20.h),

            // Nom et prix
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  nom,
                  style: GoogleFonts.montserrat(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                Text(
                  '$prix DA',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            // Stock
            Row(
              children: [
                Text(
                  'stock: ',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[900],
                  ),
                ),
                Text(
                  disponible ? 'disponible' : 'indisponible',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: disponible ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            // Description
            Text(
              'description :',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                color: Colors.blue[900],
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                description,
                style: TextStyle(fontSize: 18.sp, color: Colors.black),
              ),
            ),

            SizedBox(
              height: 80.h,
            ), // espace pour éviter chevauchement avec le bouton
          ],
        ),
      ),
    );
  }
}
