import 'package:flutter/material.dart';
import 'package:insight_app/ownedServices.dart';
import 'package:insight_app/serviceList.dart';
import 'package:insight_app/specialistServicePage.dart';
import 'package:insight_app/viewCustomerServices.dart';

class ServicePage extends StatefulWidget {
  ServicePage({Key? key, required this.profile, required this.category}) : super(key: key);
  Map<String, dynamic> profile;
  String category;

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text("Services",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        margin: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            const SizedBox(height: 15.0,),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OwnedServices(profile: widget.profile, category: widget.category)));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  // border: Border.all(),
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.teal,
                ),
                child: const Text("Owned Services",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceList(profile: widget.profile, category: widget.category)));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  // border: Border.all(),
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.teal,
                ),
                child: const Text("Get Services",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewCustomerServices(profile: widget.profile, category: widget.category,)));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  // border: Border.all(),
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.teal,
                ),
                child: const Text("Hired Services",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SpecialistServicePage(profile: widget.profile)));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  // border: Border.all(),
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.teal,
                ),
                child: const Text("Service Clients",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
