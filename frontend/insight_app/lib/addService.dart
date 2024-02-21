import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';

class AddService extends StatefulWidget {
  AddService({Key? key, required this.profile, required this.category}) : super(key: key);
  Map profile;
  String category;

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  TextEditingController _name = TextEditingController();
  TextEditingController _description = TextEditingController();
  bool creating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text("Add Service",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.15),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: TextField(
                controller: _name,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    // labelText: "Username",
                    labelText: "Name"
                ),
              ),
            ),
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
            const SizedBox(height: 25.0,),
            creating == true ? const CircularProgressIndicator() : TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.teal
                ),
                onPressed: () {
                  setState(() {
                    creating = true;
                  });
                  postService({"owner_id": widget.profile["id"], "name": _name.text, "description": _description.text, "option": widget.category}).then((value) {
                    int counter = 0;
                    Navigator.popUntil(context, (route) {
                      counter++;
                      return counter == 3;
                    });
                  });
                },
                child: const Text("Create Service",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
