import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase {
  // current logged in user
  User? user = FirebaseAuth.instance.currentUser;

  // get collection of posts from firebase
  final CollectionReference posts = FirebaseFirestore.instance.collection('Posts');

  // get collection of events from firebase
  final CollectionReference events = FirebaseFirestore.instance.collection('Events');

  // post a message (on wall)
  Future<void> addPost(String message) {
    return posts.add({
      'UserEmail': user!.email,
      'PostMessage': message,
      'TimeStamp': Timestamp.now(),
    });
  }

  // read posts from database
  Stream<QuerySnapshot> getPostsStream() {
    final postsStream = FirebaseFirestore.instance
        .collection('Posts')
        .orderBy('TimeStamp', descending: true)
        .snapshots();

    return postsStream;
  }

  // add comment to a post on forum
  Future<void> addComment(String postId, String comment) {
    return posts
        .doc(postId)
        .collection('Comments')
        .add({
      'UserEmail': user!.email,
      'Comment': comment,
      'TimeStamp': Timestamp.now(),
    });
  }

  // read comments from a specific post
  Stream<QuerySnapshot> getCommentsStream(String postId) {
    return posts
        .doc(postId)
        .collection('Comments')
        .orderBy('TimeStamp', descending: true)
        .snapshots();
  }

  // add event
  Future<void> addEvent(String title, String description, DateTime date) {
    return events.add({
      'UserEmail': user!.email,
      'Title': title,
      'Description': description,
      'EventDate': Timestamp.fromDate(date),
      'TimeStamp': Timestamp.now(),
    });
  }

  // read events from database
  Stream<QuerySnapshot> getEventsStream() {
    return events
        .orderBy('EventDate')
        .snapshots();
  }

}