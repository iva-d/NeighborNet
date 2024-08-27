import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:camera/camera.dart';
import 'package:neighbor_net/database/firestore.dart';
import 'package:neighbor_net/models/issue.dart';


class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({Key? key}) : super(key: key);

  @override
  _ReportIssuePageState createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final FirestoreDatabase database = FirestoreDatabase();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _imageFile;
  late CameraController _cameraController;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _cameraController.initialize();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _cameraController.takePicture();
      setState(() {
        _imageFile = File(image.path);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> _uploadImage(File image) async {
    if (image == null || !image.existsSync()) {
      throw Exception('File does not exist');
    }

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('issues/${DateTime.now().toIso8601String()}.jpg');

      TaskSnapshot uploadTask = await storageRef.putFile(image);

      if (uploadTask.state == TaskState.success) {
        final downloadUrl = await storageRef.getDownloadURL();
        return downloadUrl;
      } else {
        throw FirebaseException(
          plugin: 'firebase_storage',
          message: 'Upload failed',
        );
      }
    } on FirebaseException catch (e) {
      print("Firebase Exception: $e");
      rethrow;
    } catch (e) {
      print("Exception: $e");
      rethrow;
    }
  }


  void addIssue() async {
    if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
      String? imageUrl;

      if (_imageFile != null) {
        imageUrl = await _uploadImage(_imageFile!);
      }

      if (imageUrl != null) {
        await database.addIssueWithImage(
          titleController.text,
          descriptionController.text,
          imageUrl,
        );
      } else {
        await database.addIssue(
          titleController.text,
          descriptionController.text,
        );
      }

      titleController.clear();
      descriptionController.clear();
      setState(() {
        _imageFile = null;
      });
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Report an Issue"),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Issue Title",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Issue Description",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              _imageFile == null
                  ? const Text('No image selected.')
                  : Image.file(_imageFile!, height: 200),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: _takePicture,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Take Picture"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: addIssue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  "Report Issue",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),

              SizedBox(
                height: 400,
                child: StreamBuilder<List<Issue>>(
                  stream: database.getIssuesStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final issues = snapshot.data ?? [];

                    return ListView.builder(
                      itemCount: issues.length,
                      itemBuilder: (context, index) {
                        final issue = issues[index];
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
                                  issue.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  issue.description,
                                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Reported on: ${formatDate(issue.timestamp)}",
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                                if (issue.imageUrl != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Image.network(
                                      issue.imageUrl!,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
