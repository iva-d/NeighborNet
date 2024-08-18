import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final List<Map<String, dynamic>> _forums = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _filteredForums = [];

  @override
  void initState() {
    super.initState();
    _filteredForums = _forums;
    _searchController.addListener(_filterForums);
  }

  void _filterForums() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredForums = _forums.where((forum) {
        final title = forum['title'].toString().toLowerCase();
        final content = forum['content'].toString().toLowerCase();
        return title.contains(query) || content.contains(query);
      }).toList();
    });
  }

  void _createForum(String title, String content) {
    setState(() {
      _forums.add({
        'title': title,
        'content': content,
        'comments': [],
      });
      _filteredForums = _forums; // Update the filtered list
    });
    _titleController.clear();
    _contentController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: const OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredForums.length,
              itemBuilder: (context, index) {
                final forum = _filteredForums[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text(forum['title']),
                    subtitle: Text(forum['content']),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TopicDetailsPage(
                            topicIndex: index,
                            forum: forum,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // Enable full screen bottom sheet
            builder: (context) => CreatePostPage(
              titleController: _titleController,
              contentController: _contentController,
              onSubmit: _createForum,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TopicDetailsPage extends StatefulWidget {
  final int topicIndex;
  final Map<String, dynamic> forum;

  const TopicDetailsPage({Key? key, required this.topicIndex, required this.forum}) : super(key: key);

  @override
  _TopicDetailsPageState createState() => _TopicDetailsPageState();
}

class _TopicDetailsPageState extends State<TopicDetailsPage> {
  final TextEditingController _commentController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  void _addComment(String comment) {
    final String username = user?.displayName ?? 'Anonymous';

    setState(() {
      widget.forum['comments'].add({'username': username, 'comment': comment});
    });
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.forum['title']),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                widget.forum['content'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: widget.forum['comments'].length,
              itemBuilder: (context, index) {
                final comment = widget.forum['comments'][index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment['username'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(comment['comment']),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      labelText: 'Leave a comment',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      _addComment(_commentController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CreatePostPage extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final void Function(String, String) onSubmit;

  const CreatePostPage({
    Key? key,
    required this.titleController,
    required this.contentController,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          constraints: BoxConstraints(maxWidth: 600), // Constrain the width
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Open a discussion",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 6,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Change the button color
                ),
                onPressed: () {
                  final title = titleController.text;
                  final content = contentController.text;
                  if (title.isNotEmpty && content.isNotEmpty) {
                    onSubmit(title, content);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
