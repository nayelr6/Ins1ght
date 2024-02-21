import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';
import 'package:insight_app/ownedServices.dart';

class UpdateService extends StatefulWidget {
  UpdateService({Key? key, required this.profile, required this.category, required this.service}) : super(key: key);
  Map profile;
  String category;
  Map service;

  @override
  State<UpdateService> createState() => _UpdateServiceState();
}

class _UpdateServiceState extends State<UpdateService> {
  TextEditingController _name = TextEditingController();
  TextEditingController _description = TextEditingController();
  bool updating = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _name.text = widget.service["name"];
    _description.text = widget.service["description"];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text("Update Service",
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
            updating == true ? const CircularProgressIndicator() : TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.teal
                ),
                onPressed: () {
                  setState(() {
                    updating = true;
                  });
                  updateService(widget.service["id"], {"name": _name.text, "description": _description.text}).then((value) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OwnedServices(profile: widget.profile, category: widget.category)));
                  });
                },
                child: const Text("Update Service",
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
