import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';

class SubmitForm extends StatefulWidget {
  SubmitForm({Key? key, required this.profile, required this.service}) : super(key: key);
  Map profile;
  Map service;

  @override
  State<SubmitForm> createState() => _SubmitFormState();
}

class _SubmitFormState extends State<SubmitForm> {
  TextEditingController _description = TextEditingController();
  bool creating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text("Apply For Service",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          const SizedBox(height: 25.0,),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: TextField(
              controller: _description,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  // labelText: "Username",
                  labelText: "Description"
              ),
            ),
          ),
          const SizedBox(height: 10.0,),
          creating == true ? const CircularProgressIndicator() : TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.teal
              ),
              onPressed: () {
                setState(() {
                  creating = true;
                });
                createServiceRequest({"sender_id": widget.profile["id"], "service_id": widget.service["id"], "description": _description.text}).then((value) {
                  int counter = 0;
                  Navigator.popUntil(context, (route) {
                    counter++;
                    return counter == 3;
                  });
                });
              },
              child: const Text("Submit",
                style: TextStyle(
                  color: Colors.white,
                ),
              )
          )
        ],
      ),
    );
  }
}
