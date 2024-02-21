import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';

class SearchMembers extends StatefulWidget {
  SearchMembers({Key? key, required this.groupMember}) : super(key: key);
  Map groupMember;

  @override
  State<SearchMembers> createState() => _SearchMembersState();
}

class _SearchMembersState extends State<SearchMembers> {
  bool loading = false;
  TextEditingController searchMembers = TextEditingController();
  List users = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text("Add Members",
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
                  searchForGroupMembers(widget.groupMember["group"]["id"], text).then((value) {
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
                  hintText: "Search Members"
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
                        loading = false;
                      });
                      getFriendProfile(users[index]["id"]).then((value) {
                        Map profile = jsonDecode(value);
                        print(profile);
                        createGroupMember({"group_id": widget.groupMember["group"]["id"], "profile_id": profile["id"], "direct": true}).then((value) {
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
    );
  }
}
