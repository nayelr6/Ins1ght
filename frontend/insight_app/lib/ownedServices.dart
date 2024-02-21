import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insight_app/addService.dart';
import 'package:insight_app/api.dart';
import 'package:insight_app/ownedServiceActions.dart';
import 'package:insight_app/updateService.dart';

class OwnedServices extends StatefulWidget {
  OwnedServices({Key? key, required this.profile, required this.category}) : super(key: key);
  Map profile;
  String category;

  @override
  State<OwnedServices> createState() => _OwnedServicesState();
}

class _OwnedServicesState extends State<OwnedServices> {
  List services = [];
  bool serviceLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOwnedService(widget.profile["id"], widget.category).then((value) {
      setState(() {
        services = jsonDecode(value.body);
        serviceLoading = false;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: Text(widget.category,
          style: const TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddService(profile: widget.profile, category: widget.category)));
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add,
          color: Colors.white,
        ),
      ),
      body: serviceLoading? const Center(child: CircularProgressIndicator(),) : services.isEmpty ? const Center(
        child: Text("You have no services"),
      ) : Container(
        margin: const EdgeInsets.all(5.0),
        child: ListView.builder(
        shrinkWrap: true,
        itemCount: services.length,
        itemBuilder: (context, index) {
          //fix here
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(15.0)
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OwnedServiceActions(service: services[index], profile: widget.profile, category: widget.category)));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(services[index]["name"],
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal
                    ),
                  ),
                  Text(services[index]["description"],
                    style: const TextStyle(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      ),
    );
  }
}
