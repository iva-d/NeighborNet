import 'package:cloud_firestore/cloud_firestore.dart';

class Issue {
  String id;
  String title;
  String description;
  String? imageUrl;
  Timestamp timestamp;

  Issue({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'Title': title,
      'Description': description,
      'ImageUrl': imageUrl,
      'Timestamp': timestamp,
    };
  }

  factory Issue.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Issue(
      id: doc.id,
      title: data['Title'],
      description: data['Description'],
      imageUrl: data.containsKey('ImageUrl') ? data['ImageUrl'] : null,
      timestamp: data['Timestamp'],
    );
  }
}
