import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';
import 'package:insight_app/serviceRequestsList.dart';
import 'package:insight_app/viewCustomers.dart';
import 'package:insight_app/viewEvents.dart';

class SpecialistPage extends StatefulWidget {
  SpecialistPage({Key? key, required this.specialist, required this.service}) : super(key: key);
  Map specialist;
  Map service;

  @override
  State<SpecialistPage> createState() => _SpecialistPageState();
}

class _SpecialistPageState extends State<SpecialistPage> {
  bool deleting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text("Specialist options",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewCustomers(specialist: widget.specialist)));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // border: Border.all(),
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.teal,
              ),
              child: const Text("View My Clients",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceRequestsList(service: widget.service, isSpecialist: true, specialist: widget.specialist) ));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // border: Border.all(),
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.teal,
              ),
              child: const Text("View Service Requests",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewEventsOwner(service: widget.service, isOwner: false)));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // border: Border.all(),
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.teal,
              ),
              child: const Text("View Events",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              deleting ? const CircularProgressIndicator() : showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Quit Service"),
                      content: const Text("Are you sure you want to quit this service"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                deleting = true;
                              });
                              deleteSpecialist(widget.specialist["id"]).then((value) {
                                int counter = 0;
                                Navigator.pop(context);
                                Navigator.popUntil(context, (route) {
                                  counter++;
                                  return counter == 3;
                                });
                              });
                              // closeGroup(widget.groupMember["group"]["id"]).then((value) {
                              //   int counter = 0;
                              //   Navigator.pop(context);
                              //   Navigator.popUntil(context, (route) {
                              //     counter++;
                              //     return counter == 3;
                              //   });
                              // });
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
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // border: Border.all(),
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.teal,
              ),
              child: const Text("Quit Service",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
