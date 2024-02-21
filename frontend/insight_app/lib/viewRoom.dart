import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';
import 'package:insight_app/roomMemberList.dart';
import 'package:insight_app/roomMessage.dart';
import 'package:insight_app/searchRoomMembers.dart';

class ViewRoom extends StatefulWidget {
  ViewRoom({Key? key, required this.roomMember}) : super(key: key);
  Map roomMember;

  @override
  State<ViewRoom> createState() => _ViewRoomState();
}

class _ViewRoomState extends State<ViewRoom> {
  bool deleting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: Text(widget.roomMember["group_room"]["room_name"],
          style: const TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => RoomList(groupMember: widget.groupMember)));
              Navigator.push(context, MaterialPageRoute(builder: (context) => RoomMessage(roomMember: widget.roomMember)));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // border: Border.all(),
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.teal,
              ),
              child: const Text("Room Message",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => RoomList(groupMember: widget.groupMember)));
              Navigator.push(context, MaterialPageRoute(builder: (context) => RoomMemberList(roomMember: widget.roomMember)));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // border: Border.all(),
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.teal,
              ),
              child: const Text("View Room Members",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => RoomList(groupMember: widget.groupMember)));
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchRoomMembers(roomMember: widget.roomMember)));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // border: Border.all(),
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.teal,
              ),
              child: const Text("Add Room Members",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0
                ),
              ),
            ),
          ),
          widget.roomMember["member"]["profile"]["id"] == widget.roomMember["group_room"]["owner"]["profile"]["id"] ?
          GestureDetector(
            onTap: () {
              deleting ? const CircularProgressIndicator() : showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Close Room"),
                      content: const Text("Are you sure you want to close this room"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                deleting = true;
                              });
                              deleteRoom(widget.roomMember["group_room"]["id"]).then((value) {
                                int counter = 0;
                                Navigator.pop(context);
                                Navigator.popUntil(context, (route) {
                                  counter++;
                                  return counter == 3;
                                });
                              });
                              // closeGroup(widget.groupMember["group"]["id"]).then((value) {
                              //   int counter = 0;
                              //   Navigator.pop(context);
                              //   Navigator.popUntil(context, (route) {
                              //     counter++;
                              //     return counter == 3;
                              //   });
                              // });
                            },
                            child: const Text("Yes")
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel")
                        )
                      ],
                    );
                  }
              );
              // Navigator.push(context, MaterialPageRoute(builder: (context) => RoomList(groupMember: widget.groupMember)));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // border: Border.all(),
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.teal,
              ),
              child: const Text("Close Room",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0
                ),
              ),
            ),
          ) :
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // border: Border.all(),
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.teal,
              ),
              child: const Text("Leave Room",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
