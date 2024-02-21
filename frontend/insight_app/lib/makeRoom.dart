import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';
import 'package:insight_app/roomList.dart';

class MakeRoom extends StatefulWidget {
  MakeRoom({Key? key, required this.groupMember}) : super(key: key);
  Map groupMember;

  @override
  State<MakeRoom> createState() => _MakeRoomState();
}

class _MakeRoomState extends State<MakeRoom> {
  TextEditingController _name = TextEditingController();
  bool errors = false;
  bool sending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text("Make a Room",
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
                  hintText: "Room Name (Maximum of 25 characters)"
              ),
            ),
          ),
          errors ? const SizedBox(height: 5.0,) : Container(),
          errors ? const Text("The field cannot be empty",
            style: TextStyle(
                color: Colors.red
            ),
          ) : Container(),
          const SizedBox(height: 25.0,),
          sending == true ? const CircularProgressIndicator() : TextButton(
              onPressed: () {
                if(_name.text.isEmpty) {
                  setState(() {
                    errors = true;
                  });
                } else {
                  // createGroup({"name": _name.text, "description": _desc.text, "owner_id": widget.profile["id"]}).then((value) {
                  //   setState(() {
                  //     sending = false;
                  //     errors = false;
                  //   });
                  //   Navigator.popUntil(context, (route) => route.isFirst);
                  // });
                  createRoom({"room_name": _name.text, "owner_id": widget.groupMember["id"], "group_id": widget.groupMember["group"]["id"]}).then((value) {
                    setState(() {
                      sending = true;
                      errors = false;
                    });
                    int counter = 0;
                    Navigator.popUntil(context, (route) {
                      counter++;
                      return counter == 3;
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RoomList(groupMember: widget.groupMember)));
                  });
                }

              },
              child: const Text("Create Room")
          )
        ],
      ),
    );
  }
}
