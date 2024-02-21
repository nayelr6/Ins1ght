import 'package:flutter/material.dart';
import 'package:insight_app/addEvent.dart';
import 'package:insight_app/searchSpecialists.dart';
import 'package:insight_app/serviceRequestsList.dart';
import 'package:insight_app/updateService.dart';
import 'package:insight_app/viewEvents.dart';
import 'package:insight_app/viewSpecialists.dart';

class OwnedServiceActions extends StatefulWidget {
  OwnedServiceActions({Key? key, required this.service, required this.profile, required this.category}) : super(key: key);
  Map service;
  Map profile;
  String category;

  @override
  State<OwnedServiceActions> createState() => _OwnedServiceActionsState();
}

class _OwnedServiceActionsState extends State<OwnedServiceActions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: Text(widget.service["name"],
          style: const TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>UpdateService(profile: widget.profile, category: widget.category, service: widget.service)));
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
              child: const Text("Update Service",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceRequestsList(service: widget.service, isSpecialist: false, specialist: {"Error": "Not a specialist"},) ));
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewSpecialists(service: widget.service)));
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
              child: const Text("View Specialists",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchSpecialists(service: widget.service)));
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
              child: const Text("Appoint Specialists",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddEvent(service: widget.service)));
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
              child: const Text("Add events",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewEventsOwner(service: widget.service, isOwner: true)));
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
              child: const Text("View events",
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
