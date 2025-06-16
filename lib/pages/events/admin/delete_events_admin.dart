import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope_orphanage/app_imports.dart';
import 'package:http/http.dart' as http;

class EventView1 extends StatefulWidget {
  const EventView1({super.key});

  @override
  State<EventView1> createState() => _EventView1State();
}

class _EventView1State extends State<EventView1> {
  Future<List<EventModel>> getRequest() async {
    final response = await http.get(Uri.parse(URL.viewEventAdmin));
    final responseData = jsonDecode(response.body);

    final events = <EventModel>[];
    for (final singleUser in responseData) {
      final var event = EventModel(
        id: singleUser['id'].toString(),
        name: singleUser['name'].toString(),
        eventDate: singleUser['event_date'].toString(),
        eventTime: singleUser['event_time'].toString(),
        description: singleUser['description'].toString(),
      );
      events.add(event);
    }
    return events;
  }

  Future<void> deleteData(String id) async {
    final res = await http.post(Uri.parse(URL.deleteEventAdmin), body: {
      'id': id,
    });
    final response = jsonDecode(res.body);
    if (response['success'] == 'true') {
      print('success');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'E V E N T S',
        ),
      ),
      body: FutureBuilder(
        future: getRequest(),
        builder: (BuildContext ctx, AsyncSnapshot<List<EventModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.red[900],
                strokeWidth: 5,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No event data available.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (ctx, index) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                      right: 5,
                      top: 5,
                    ),
                    child: Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: ListTile(
                              title: Text(snapshot.data![index].name),
                              leading: IconButton(
                                onPressed: () {
                                  setState(() {});
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventEdit(
                                        eventUser: snapshot.data![index],
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    snapshot.data![index].eventDate,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(snapshot.data![index].eventTime),
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirm Deletion'),
                                        content: const Text(
                                            'Are you sure you want to delete this event?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteData(
                                                  snapshot.data![index].id);
                                              Navigator.of(context).pop();
                                              setState(() {});
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
