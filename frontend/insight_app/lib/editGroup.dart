import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';
import 'package:insight_app/viewGroup.dart';

class EditGroup extends StatefulWidget {
  EditGroup({Key? key, required this.profile, required this.groupMember, required this.name, required this.desc}) : super(key: key);
  Map profile;
  Map groupMember;
  String name;
  String desc;
  
  @override
  State<EditGroup> createState() => _EditGroupState();
}

class _EditGroupState extends State<EditGroup> {
  TextEditingController _name = TextEditingController();
  TextEditingController _desc = TextEditingController();
  bool errors = false;
  bool sending = false;

  @override
  void initState() {
    super.initState();
    _name.text = widget.name;
    _desc.text = widget.desc;
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text("Edit Group",
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
                  int counter = 0;
                  
                 updateGroup(widget.groupMember["group"]["id"], {"name": _name.text, "description": _desc.text}).then((value) {
                   getGroupMember(widget.groupMember["id"]).then((value) {
                     Navigator.popUntil(context, (route) {
                       counter = counter + 1;
                       return counter == 3;
                     });
                     Navigator.push(context, MaterialPageRoute(builder: (context) => ViewGroup(profile: widget.profile, groupMember: jsonDecode(value))));
                   });
                 });
                }
              },
              child: const Text("Update Group")
          )
        ],
      ),
    );
  }
}
