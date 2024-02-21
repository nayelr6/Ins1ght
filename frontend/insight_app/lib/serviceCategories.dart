import 'package:flutter/material.dart';
import 'package:insight_app/servicePage.dart';

class ServiceCategories extends StatefulWidget {
  ServiceCategories({Key? key, required this.profile}) : super(key: key);
  Map<String, dynamic> profile;

  @override
  State<ServiceCategories> createState() => _ServiceCategoriesState();
}

class _ServiceCategoriesState extends State<ServiceCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text("Service Categories",
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => ServicePage(profile: widget.profile, category: "Therapist",)));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.teal,
                ),
                child: const Text("Therapist",
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
