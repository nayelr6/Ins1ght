import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';
import 'package:insight_app/editEvent.dart';

class ViewEventsOwner extends StatefulWidget {
  ViewEventsOwner({Key? key, required this.service, required this.isOwner}) : super(key: key);
  Map service;
  bool isOwner;

  @override
  State<ViewEventsOwner> createState() => _ViewEventsOwnerState();
}

class _ViewEventsOwnerState extends State<ViewEventsOwner> {
  bool loading = true;
  List events = [];
  bool deleting = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEvents(widget.service["id"]).then((value) {
      setState(() {
        events = jsonDecode(value.body);
        loading = false;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text("View Events",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: loading ? const Center(child: CircularProgressIndicator(),) : events.isEmpty ?
      const Center(child: Text("There are no events ongoing"),) : Container(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: events.length,
          itemBuilder: (context, index) {
            //fix here
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15.0)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Image.network(posts[index]["owner"]["picture"]),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(events[index]["title"],
                            style: const TextStyle(
                                color: Colors.teal,
                                fontSize: 24.0
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      widget.isOwner ? Row(
                        children: [
                          GestureDetector(
                            child: const Icon(Icons.edit,
                              color: Colors.blue,
                            ),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditEvent(service: widget.service, event: events[index])));
                            },
                          ),
                          const SizedBox(width: 10.0,),
                          GestureDetector(
                            child: const Icon(Icons.delete,
                              color: Colors.red,
                            ),
                            onTap: () {
                              deleting? const CircularProgressIndicator() : showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Delete Event"),
                                      content: const Text("Are you sure you want to delete this event"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                deleting = true;
                                              });
                                              deleteEvents(events[index]["id"]).then((value) {
                                                setState(() {
                                                  events.removeAt(index);
                                                  deleting = false;
                                                });
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: const Text("Yes")
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Cancel")
                                        )
                                      ],
                                    );
                                  }
                              );
                            },
                          ),
                        ],
                      ) : Container(),
                    ],
                  ),
                  const SizedBox(height: 15.0,),
                  Text('Starts at: ${events[index]["start_date"]}',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18.0
                    ),
                  ),
                  Text('Ends at: ${events[index]["end_date"]}',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18.0
                    ),
                  ),
                  Text('Location: ${events[index]["location"]}',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18.0
                    ),
                  ),
                  Text(events[index]["description"],
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
