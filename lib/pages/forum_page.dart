import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neighbor_net/database/firestore.dart';
import 'package:neighbor_net/components/my_textfield.dart';

class ForumPage extends StatelessWidget {
  ForumPage({super.key});

  final FirestoreDatabase database = FirestoreDatabase();
  final TextEditingController newPostController = TextEditingController();
  final Map<String, TextEditingController> commentControllers = {};

  void postMessage() {
    if (newPostController.text.isNotEmpty) {
      database.addPost(newPostController.text);
      newPostController.clear();
    }
  }

  void addComment(String postId) {
    if (commentControllers[postId]?.text.isNotEmpty ?? false) {
      database.addComment(postId, commentControllers[postId]!.text);
      commentControllers[postId]!.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Forum"),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                    hintText: "What's on your mind?",
                    obscureText: false,
                    controller: newPostController,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.teal),
                  onPressed: postMessage,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: database.getPostsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final posts = snapshot.data?.docs ?? [];

                if (posts.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Text("No posts yet. Be the first to post!"),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final postId = post.id;
                    final message = post['PostMessage'];
                    final userEmail = post['UserEmail'];

                    commentControllers[postId] = TextEditingController();

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              userEmail,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.blueGrey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            StreamBuilder(
                              stream: database.getCommentsStream(postId),
                              builder: (context, commentSnapshot) {
                                if (commentSnapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }

                                final comments = commentSnapshot.data?.docs ?? [];

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: comments.map((comment) {
                                    final commentText = comment['Comment'];
                                    final commentUserEmail = comment['UserEmail'];

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.grey.shade300),
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              commentText,
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              commentUserEmail,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.blueGrey,
                                              ),
                                            ),],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );},
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: MyTextField(
                                      hintText: "Add a comment...",
                                      obscureText: false,
                                      controller: commentControllers[postId]!,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.send, color: Colors.teal),
                                    onPressed: () => addComment(postId),
                                  ),],
                              ),
                            ),],
                        ),
                      ),
                    );},
                );},
            ),
          ),],
      ),
    );
  }
}

