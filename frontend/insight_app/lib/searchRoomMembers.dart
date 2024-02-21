import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';

class SearchRoomMembers extends StatefulWidget {
  SearchRoomMembers({Key? key, required this.roomMember}) : super(key: key);
  Map roomMember;

  @override
  State<SearchRoomMembers> createState() => _SearchRoomMembersState();
}

class _SearchRoomMembersState extends State<SearchRoomMembers> {
  bool loading = false;
  TextEditingController searchMembers = TextEditingController();
  List users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text("Add Room Members",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
            child: TextField(
              controller: searchMembers,
              onChanged: (text) {
                setState(() {
                  loading = true;
                });
                if(text != "") {
                  // searchForGroupMembers(widget.groupMember["group"]["id"], text).then((value) {
                  //   setState(() {
                  //     users = jsonDecode(value.body);
                  //     loading = false;
                  //   });
                  // });
                  searchRoomMembers(widget.roomMember["group_room"]["id"], widget.roomMember["group_room"]["group"]["id"], searchMembers.text).then((value) {
                      setState(() {
                        users = jsonDecode(value.body);
                        loading = false;
                      });
                  });
                } else {
                  setState(() {
                    users = [];
                    loading = false;
                  });
                }
                // searchForGroups(text).then((value) {
                //   setState(() {
                //     searchText = searchGroup.text;
                //     searchedGroups = jsonDecode(value.body);
                //   });
                // });

              },
              decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  hintText: "Search for Room Members"
              ),
            ),
          ),
          loading ? const Center(child: CircularProgressIndicator(),) : users.isEmpty ?
          const Center(child: Text("No users found."),) : Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${users[index]["username"]}'),
                    trailing: TextButton(
                        onPressed: () {
                          setState(() {
                            loading = true;
                          });
                          // getFriendProfile(users[index]["id"]).then((value) {
                          //   Map profile = jsonDecode(value);
                          //   print(profile);
                          //   createGroupMember({"group_id": widget.groupMember["group"]["id"], "profile_id": profile["id"], "direct": true}).then((value) {
                          //     setState(() {
                          //       users.removeAt(index);
                          //       loading = false;
                          //     });
                          //   });
                          // });
                          getSpecificGroupMember(users[index]["id"], widget.roomMember["member"]["group"]["id"]).then((value) {
                            Map chosen_member = jsonDecode(value.body);
                            createRoomMember({"member_id": chosen_member["id"], "room_id": widget.roomMember["group_room"]["id"]}).then((value) {
                                  setState(() {
                                    users.removeAt(index);
                                    loading = false;
                                  });
                            });
                          });
                          
                        },
                        child: const Text("Add")
                    ),
                  );
                }
            ),
          ),
        ],
      ),
    );;
  }
}
