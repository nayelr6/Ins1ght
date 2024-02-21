import 'package:flutter/material.dart';
import 'package:insight_app/applicationForm.dart';
import 'package:insight_app/viewReviews.dart';

class ServiceDetail extends StatefulWidget {
  ServiceDetail({Key? key, required this.profile, required this.category, required this.service}) : super(key: key);
  Map profile;
  Map service;
  String category;

  @override
  State<ServiceDetail> createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
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
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.service["name"],
              style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal
              ),
            ),
            Text(widget.service["owner"]["user"]["username"],
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(widget.service["description"],
              style: const TextStyle(
                  fontWeight: FontWeight.w300,
              ),
            ),
            widget.service["average_rating"] == null ? const Text("Unrated",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.teal,
                )
            ) : Text(
              "Rating: ${(widget.service["average_rating"]).toStringAsFixed(2)}/5.00",
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.teal,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewReviews(service: widget.service)));
              },
              child: const Text("View Reviews",
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w300,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.teal
                ),
              ),
            ),
            const SizedBox(height: 50.0,),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitForm(profile: widget.profile, service: widget.service)));
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.teal
                ),
                child: const Text("Apply",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
