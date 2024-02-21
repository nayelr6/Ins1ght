import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';
import 'package:insight_app/specialistPage.dart';

class SpecialistServicePage extends StatefulWidget {
  SpecialistServicePage({Key? key, required this.profile}) : super(key: key);
  Map profile;

  @override
  State<SpecialistServicePage> createState() => _SpecialistServicePageState();
}

class _SpecialistServicePageState extends State<SpecialistServicePage> {
  List services = [];
  bool serviceLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSpecialistsByProfile(widget.profile["id"]).then((value) {
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
        title: const Text("My Services",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SpecialistPage(service: services[index]["service"], specialist: services[index],)));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(services[index]["service"]["name"],
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal
                      ),
                    ),
                    Text(services[index]["service"]["description"],
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
