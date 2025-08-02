import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key});

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];

  void _searchProducts(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('produits') // your collection name
        .where('nom', isGreaterThanOrEqualTo: query)
        .where('nom', isLessThan: query + 'z')
        .get();

    setState(() {
      _searchResults = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Nom du produit',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () =>
                      _searchProducts(_searchController.text.trim()),
                ),
              ),
              onChanged: (value) {
                _searchProducts(value.trim());
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: _searchResults.isEmpty
                  ? Center(child: Text('Aucun produit trouvé'))
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        var product =
                            _searchResults[index].data()
                                as Map<String, dynamic>;
                        return Card(
                          child: ListTile(
                            title: Text(product['nom']),
                            subtitle: Text('Prix: ${product['prix']} DA'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
