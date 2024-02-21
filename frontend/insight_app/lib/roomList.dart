import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';
import 'package:insight_app/makeRoom.dart';
import 'package:insight_app/viewRoom.dart';

class RoomList extends StatefulWidget {
  RoomList({Key? key, required this.groupMember}) : super(key: key);
  Map groupMember;

  @override
  State<RoomList> createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  bool roomsLoading = true;
  List rooms = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getRooms(widget.groupMember["group"]["id"], widget.groupMember["id"]).then((value) {
    //   setState(() {
    //     roomsLoading = false;
    //     rooms = jsonDecode(value);
    //   });
    //   print(rooms);
    // });
    getRoomMember(widget.groupMember["id"]).then((value) {
      setState(() {
        roomsLoading = false;
        rooms = jsonDecode(value);
      });
    });
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text("My Rooms",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MakeRoom(groupMember: widget.groupMember)));
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add,
          color: Colors.white,
        ),
      ),
      body: roomsLoading ? const Center(child: CircularProgressIndicator(),) : Column(
        children: [
          rooms.isEmpty ? Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width*0.5),
              child: const Center(
                child: Text("There are no rooms available"),
              ),
            ),
          ) : Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewRoom(roomMember: rooms[index])));
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ViewGroup(profile: widget.profile, groupMember: groups[index])));
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
                      child: Text("${rooms[index]["group_room"]['room_name']}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0
                        ),
                      ),
                    ),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}
