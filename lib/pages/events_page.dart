import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:neighbor_net/components/my_drawer.dart';
import 'package:neighbor_net/database/firestore.dart';

class EventsPage extends StatelessWidget {
  EventsPage({Key? key}) : super(key: key);

  final FirestoreDatabase database = FirestoreDatabase();

  String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year}";
  }

  void _showAddEventDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Event'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(hintText: 'Event Title'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(hintText: 'Event Description'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Date: ${formatDate(Timestamp.fromDate(selectedDate))}"),
                        TextButton(
                          style: TextButton.styleFrom(primary: Colors.blueGrey),
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    primaryColor: Colors.black,
                                    hintColor: Colors.white,
                                    colorScheme: ColorScheme.light(primary: Colors.black),
                                    dialogBackgroundColor: Colors.black,
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (pickedDate != null && pickedDate != selectedDate) {
                              setState(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                          child: const Text('Select Date'),
                        ),],
                    ),],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                      'Cancel',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                      database.addEvent(titleController.text, descriptionController.text, selectedDate);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                      'Add Event',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ),],
            );},
        );},
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("E V E N T S"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      // drawer: const MyDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: database.getEventsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final events = snapshot.data?.docs ?? [];

          final pastEvents = events.where((event) {
            final eventDate = (event['EventDate'] as Timestamp).toDate();
            return eventDate.isBefore(DateTime.now());
          }).toList();

          final upcomingEvents = events.where((event) {
            final eventDate = (event['EventDate'] as Timestamp).toDate();
            return eventDate.isAfter(DateTime.now());
          }).toList();

          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Upcoming Events',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              ...upcomingEvents.map((event) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      event['Title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${event['Description']}\n${formatDate(event['EventDate'])}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                );
              }).toList(),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Past Events',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ...pastEvents.map((event) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  color: Colors.black,
                  child: ListTile(
                    title: Text(
                      event['Title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${event['Description']}\n${formatDate(event['EventDate'])}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEventDialog(context);
        },
        backgroundColor: Colors.grey[700],
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
