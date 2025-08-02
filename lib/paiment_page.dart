import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PaiementPage extends StatefulWidget {
  @override
  _PaiementPageState createState() => _PaiementPageState();
}

class _PaiementPageState extends State<PaiementPage> {
  String _selectedMethod = 'edahabia';
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Méthode de paiement')),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            buildPaymentOption(
              icon: Icons.credit_card,
              title: 'EDDAHABIA',
              subtitle: 'Paiement par carte interbancaire',
              value: 'edahabia',
            ),
            SizedBox(height: 15),
            buildPaymentOption(
              icon: Icons.handshake,
              title: 'Main à main',
              subtitle: 'Paiement à la livraison',
              value: 'main',
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                if (user != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid)
                      .set({
                        'paymentMethod': _selectedMethod,
                      }, SetOptions(merge: true));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Méthode enregistrée !')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Utilisateur non connecté')),
                  );
                }
              },
              child: Text('Enregistrer ma méthode'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethod = value;
        });
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _selectedMethod == value ? Colors.grey.shade200 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _selectedMethod == value
                ? Colors.blue
                : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.blue),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(subtitle, style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedMethod,
              onChanged: (newValue) {
                setState(() {
                  _selectedMethod = newValue!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
