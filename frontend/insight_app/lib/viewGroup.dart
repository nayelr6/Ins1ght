import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';
import 'package:insight_app/editGroup.dart';
import 'package:insight_app/groupMessage.dart';
import 'package:insight_app/memberList.dart';
import 'package:insight_app/memberRequests.dart';
import 'package:insight_app/polls.dart';
import 'package:insight_app/retire.dart';
import 'package:insight_app/roomList.dart';
import 'package:insight_app/searchMembers.dart';

class ViewGroup extends StatefulWidget {
  ViewGroup({Key? key, required this.profile, required this.groupMember}) : super(key: key);
  Map profile;
  Map<String, dynamic> groupMember;

  @override
  State<ViewGroup> createState() => _ViewGroupState();
}

class _ViewGroupState extends State<ViewGroup> {
  bool deleting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: Text("${widget.groupMember['group']['name']}",
          style: const TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10.0,),
            GestureDetector(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => MemberList(groupMember: widget.groupMember) ));
                Navigator.push(context, MaterialPageRoute(builder: (context) => GroupMessage(groupMember: widget.groupMember)));
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
                child: const Text("Group Conversation",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0
                  ),
                ),
              ),
            ),
            widget.groupMember["rank"] >= 2 ? GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditGroup(profile: widget.profile, groupMember: widget.groupMember, name: widget.groupMember["group"]["name"], desc: widget.groupMember["group"]["description"]) ));
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
                child: const Text("Edit Group",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0
                  ),
                ),
              ),
            ) : Container(),
            GestureDetector(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => MemberList(groupMember: widget.groupMember) ));
                Navigator.push(context, MaterialPageRoute(builder: (context) => RoomList(groupMember: widget.groupMember)));
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
                child: const Text("Group Rooms",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Polls(groupMember: widget.groupMember)));
                // Navigator.push(context, MaterialPageRoute(builder: (context) => MemberList(groupMember: widget.groupMember) ));
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
                child: const Text("Group Polls",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0
                  ),
                ),
              ),
            ),
            widget.groupMember["rank"] >= 1 ? GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MemberRequests(groupMember: widget.groupMember) ));
                // Navigator.push(context, MaterialPageRoute(builder: (context) => EditGroup(profile: widget.profile, groupMember: widget.groupMember, name: widget.groupMember["group"]["name"], desc: widget.groupMember["group"]["description"]) ));
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
                child: const Text("View Member Requests",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0
                  ),
                ),
              ),
            ) : Container(),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MemberList(groupMember: widget.groupMember) ));
                // Navigator.push(context, MaterialPageRoute(builder: (context) => MemberRequests(groupMember: widget.groupMember) ));
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
                child: const Text("View Group Members",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0
                  ),
                ),
              ),
            ),
            widget.groupMember["rank"] >= 1 ? GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchMembers(groupMember: widget.groupMember) ));
                // Navigator.push(context, MaterialPageRoute(builder: (context) => EditGroup(profile: widget.profile, groupMember: widget.groupMember, name: widget.groupMember["group"]["name"], desc: widget.groupMember["group"]["description"]) ));
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
                child: const Text("Add new members",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0
                  ),
                ),
              ),
            ) : Container(),
            widget.groupMember["rank"] == 2 ? GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Retire(groupMember: widget.groupMember)));
                // Navigator.push(context, MaterialPageRoute(builder: (context) => SearchMembers(groupMember: widget.groupMember) ));
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
                child: const Text("Transfer Ownership",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0
                  ),
                ),
              ),
            ) : Container(),
            widget.groupMember["rank"] >= 2 ? GestureDetector(
              onTap: () {
                deleting ? const CircularProgressIndicator() : showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Close Group"),
                        content: const Text("Are you sure you want to close this group"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                // setState(() {
                                //   deleting = true;
                                // });
                                closeGroup(widget.groupMember["group"]["id"]).then((value) {
                                  int counter = 0;
                                  Navigator.pop(context);
                                  Navigator.popUntil(context, (route) {
                                    counter++;
                                    return counter == 3;
                                  });
                                });
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
                child: const Text("Close Group",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0
                  ),
                ),
              ),
            ) : Container(),
            widget.groupMember["rank"] <= 1 ? GestureDetector(
              onTap: () {
                deleting ? const CircularProgressIndicator() : showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Leave Group"),
                        content: const Text("Are you sure you want to leave this group"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                // setState(() {
                                //   deleting = true;
                                // });
                                leaveGroup(widget.groupMember["id"]).then((value) {
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
                child: const Text("Leave Group",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0
                  ),
                ),
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }
}
