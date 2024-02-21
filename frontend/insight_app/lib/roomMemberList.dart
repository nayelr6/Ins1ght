import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';

class RoomMemberList extends StatefulWidget {
  RoomMemberList({Key? key, required this.roomMember}) : super(key: key);
  Map roomMember;
  
  @override
  State<RoomMemberList> createState() => _RoomMemberListState();
}

class _RoomMemberListState extends State<RoomMemberList> {
  bool loading = true;
  List members = [];
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRoomMembers(widget.roomMember["group_room"]["id"]).then((value) {
      setState(() {
        members = jsonDecode(value.body);
        loading = false;
      });
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text("Room Members",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: loading == true ? const Center(child: CircularProgressIndicator(),) : members.isEmpty ?
      const Center(
        child: Text("This group does not have any members yet."),
      ) : ListView.builder(
          itemCount: members.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: ListTile(
                onTap: () {},
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Image.network("$image_url${members[index]["member"]['profile']['picture']}",
                    fit: BoxFit.cover,
                    width: 50.0,
                    height: 50.0,
                  ),
                ),
                title: Text('${members[index]["member"]["profile"]["user"]["username"]}',
                  style: const TextStyle(
                    fontSize: 25.0
                  ),
                ),
                // trailing: Row(
                //   children: [
                //     TextButton(
                //       onPressed: () {},
                //       child: const Text("Promote")
                //     ),
                //     TextButton(
                //         onPressed: () {},
                //         child: const Text("Demote")
                //     ),
                //   ],
                // ),
              ),
            );
          }
      ),
    );
  }
}
