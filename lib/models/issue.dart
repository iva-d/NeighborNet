import 'package:cloud_firestore/cloud_firestore.dart';

class Issue {
  String id;
  String title;
  String description;
  Timestamp timestamp;

  Issue({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'Title': title,
      'Description': description,
      'Timestamp': timestamp,
    };
  }

  factory Issue.fromDocument(DocumentSnapshot doc) {
    return Issue(
      id: doc.id,
      title: doc['Title'],
      description: doc['Description'],
      timestamp: doc['Timestamp'],
    );
  }
}
