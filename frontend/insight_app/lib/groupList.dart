import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';
import 'package:insight_app/makeGroup.dart';
import 'package:insight_app/viewGroup.dart';

class GroupList extends StatefulWidget {
  GroupList({Key? key, required this.profile}) : super(key: key);
  Map<String, dynamic> profile;

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  List groups = [];
  bool groupsLoading = true;
  TextEditingController searchGroup = TextEditingController();
  List searchedGroups = [];
  bool sendingRequest = false;
  String searchText= "";

  @override
  void initState() {
    super.initState();
    getGroups(widget.profile["id"]).then((value) {
      setState(() {
        groups = jsonDecode(value);
        groupsLoading=false;
      });
      print(groups);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text("My Groups",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MakeGroup(profile: widget.profile)));
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add,
          color: Colors.white,
        ),
      ),
      body: groupsLoading ? const Center(child: CircularProgressIndicator(),) : Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
            child: TextField(
              controller: searchGroup,
              onChanged: (text) {
                searchForGroups(text).then((value) {
                  setState(() {
                    searchText = searchGroup.text;
                    searchedGroups = jsonDecode(value.body);
                  });
                });

              },
              decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  hintText: "Search Groups"
              ),
            ),
          ),
          searchText.isNotEmpty ? Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                shrinkWrap: true,
                itemCount: searchedGroups.length,
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(15.0)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(searchedGroups[index]["name"], style: const TextStyle(
                                fontSize: 20.0,
                                color: Colors.teal
                              ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width*0.4,
                                child: Text(searchedGroups[index]["description"], style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                ),
                                ),
                              )
                            ],
                          ),
                          sendingRequest == false ? TextButton(
                              onPressed: () {
                                setState(() {
                                  sendingRequest = true;
                                });
                                sendGroupRequest({"sender_id": widget.profile["id"], "group_id": searchedGroups[index]["id"]}).then((value) {
                                  Map currentRequest = jsonDecode(value);
                                  if(currentRequest.isEmpty) {
                                    setState(() {
                                      sendingRequest=false;
                                      searchedGroups.removeAt(index);
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Error"),
                                          content: const Text("You have already sent a request to this group"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Close")
                                            )
                                          ],
                                        );
                                      }
                                    );
                                  } else {
                                    setState(() {
                                      sendingRequest=false;
                                      searchedGroups.removeAt(index);
                                    });
                                  }
                                });
                                // getFriendProfile(userList[index]["id"]).then((value) {
                                //   Map receiver_data = jsonDecode(value);
                                //   Map data = {"sender_id" : widget.profile["id"], "receiver_id" : receiver_data["id"]};
                                //   sendRequest(data).then((value) {
                                //     setState(() {
                                //       sendingRequest = false;
                                //       userList.removeAt(index);
                                //     });
                                //   });
                                // });
                              },
                              child: const Text("Send Join Request")
                          ) : const CircularProgressIndicator(),
                        ],
                      )
                  );
                }
            ),
          ) : groups.isEmpty ?
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width*0.5),
              child: const Center(
                child: Text("You do not have any groups"),
              ),
            ),
          ) : Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewGroup(profile: widget.profile, groupMember: groups[index])));
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
                      child: Text("${groups[index]['group']['name']}",
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
