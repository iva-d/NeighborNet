import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neighbor_net/components/my_back_button.dart';
import 'package:neighbor_net/components/my_drawer.dart';
import 'package:neighbor_net/components/my_list_tile.dart';
import 'package:neighbor_net/components/my_post_button.dart';
import 'package:neighbor_net/components/my_textfield.dart';
import 'package:neighbor_net/database/firestore.dart';

class ForumPage extends StatelessWidget {
  ForumPage({super.key});

  // firestore access
  final FirestoreDatabase database = FirestoreDatabase();

  // text controller
  final TextEditingController newPostController = TextEditingController();

  // controllers for each post's comments
  final Map<String, TextEditingController> commentControllers = {};

  // post message
  void postMessage() {
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);
    }
    newPostController.clear();
  }

  // add comment to a specific post
  void addComment(String postId) {
    if (commentControllers[postId]?.text.isNotEmpty ?? false) {
      String comment = commentControllers[postId]!.text;
      database.addComment(postId, comment);
      commentControllers[postId]!.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("F O R U M"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        // leading: const MyBackButton(),
      ),
      // drawer: const MyDrawer(),
      body:
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                    hintText: "Say something...",
                    obscureText: false,
                    controller: newPostController,
                  ),
                ),
                PostButton(onTap: postMessage),
              ],
            ),
          ),
          StreamBuilder(
            stream: database.getPostsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final posts = snapshot.data!.docs;

              if (snapshot.data == null || posts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text("No posts... Post something!"),
                  ),
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final postId = post.id;
                    String message = post['PostMessage'];
                    String userEmail = post['UserEmail'];

                    // Initialize a comment controller for this post
                    commentControllers[postId] = TextEditingController();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyListTile(title: message, subtitle: userEmail),
                          StreamBuilder(
                            stream: database.getCommentsStream(postId),
                            builder: (context, commentSnapshot) {
                              if (commentSnapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              }

                              final comments = commentSnapshot.data!.docs;

                              return Column(
                                children: comments.map((comment) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 30.0, bottom: 10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius: BorderRadius.circular(8.0),
                                        border: Border.all(color: Colors.grey.shade300),
                                      ),
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            comment['Comment'],
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            comment['UserEmail'],
                                            style: TextStyle(color: Colors.blueGrey),
                                          ),],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );},
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: MyTextField(
                                      hintText: "Add a comment...",
                                      obscureText: false,
                                      controller: commentControllers[postId]!,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: () => addComment(postId),
                                ),
                              ],),
                          ),
                        ],),
                    );
                  },),
              );},
          ),],
      ),
    );
  }
}



