import 'package:flutter/material.dart';

class ReportIssuePage extends StatelessWidget {
  const ReportIssuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report an Issue")),
      body: const Center(
        child: Text("Report Issue Page"),
      ),
    );
  }
}
