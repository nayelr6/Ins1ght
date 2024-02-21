import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';

class MakeGroup extends StatefulWidget {
  MakeGroup({Key? key, required this.profile}) : super(key: key);
  Map<String, dynamic> profile;

  @override
  State<MakeGroup> createState() => _MakeGroupState();
}

class _MakeGroupState extends State<MakeGroup> {
  TextEditingController _name = TextEditingController();
  TextEditingController _desc = TextEditingController();
  bool sending = false;
  bool errors = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text("Create Group",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          const SizedBox(height: 40.0,),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: TextField(
              maxLength: 25,
              controller: _name,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  // labelText: "Username",
                  hintText: "Group Name (Maximum of 25 characters)"
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: TextField(
              controller: _desc,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  // labelText: "Username",
                  hintText: "Group Description"
              ),
            ),
          ),
          errors ? const SizedBox(height: 5.0,) : Container(),
          errors ? const Text("The fields cannot be empty",
            style: TextStyle(
              color: Colors.red
            ),
          ) : Container(),
          const SizedBox(height: 25.0,),
          sending == true ? const CircularProgressIndicator() : TextButton(
            onPressed: () {
              if(_name.text.isEmpty || _desc.text.isEmpty) {
                setState(() {
                  errors = true;
                });
              } else {
                setState(() {
                  sending = true;
                  errors = false;
                });
                createGroup({"name": _name.text, "description": _desc.text, "owner_id": widget.profile["id"]}).then((value) {
                  setState(() {
                    sending = false;
                    errors = false;
                  });
                  Navigator.popUntil(context, (route) => route.isFirst);
                });
              }

            }, 
            child: const Text("Create Group")
          )
        ],
      ),
    );
  }
}
