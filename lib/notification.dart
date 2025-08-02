import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final notificationsRef = FirebaseFirestore.instance
        .collection('notifications')
        .where('uid', isEqualTo: user?.uid)
        .orderBy('timestamp', descending: true);

    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: StreamBuilder<QuerySnapshot>(
        stream: notificationsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Erreur"));
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) return Center(child: Text("Aucune notification."));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final isRead = data['isRead'] ?? false;

              return ListTile(
                leading: Icon(
                  isRead
                      ? Icons.notifications_none
                      : Icons.notifications_active,
                  color: isRead ? Colors.grey : Colors.blue,
                ),
                title: Text(data['title'] ?? ''),
                subtitle: Text(data['body'] ?? ''),
                trailing: Text(
                  (data['timestamp'] as Timestamp)
                      .toDate()
                      .toLocal()
                      .toString()
                      .split('.')[0],
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () {
                  docs[index].reference.update({'isRead': true});
                },
              );
            },
          );
        },
      ),
    );
  }
}
