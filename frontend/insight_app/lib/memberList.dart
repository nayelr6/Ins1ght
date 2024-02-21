import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';

class MemberList extends StatefulWidget {
  MemberList({Key? key, required this.groupMember}) : super(key: key);
  Map groupMember;
  
  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  List members = [];
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMembersByGroup(widget.groupMember["group"]["id"]).then((value) {
      setState(() {
        members = jsonDecode(value);
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
        title: const Text("Group Members",
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
            return ListTile(
              onTap: () {
                if(widget.groupMember["rank"] > members[index]["rank"]) {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text("Remove member"),
                                leading: const Icon(Icons.delete),
                                onTap: () {
                                  setState(() {
                                    loading = true;
                                  });
                                  removeMembers(members[index]["id"]).then((value) {
                                    getMembersByGroup(widget.groupMember["group"]["id"]).then((value) {
                                      setState(() {
                                        members = jsonDecode(value);
                                        loading = false;
                                      });
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }
                  );

                }
              },
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.network("$image_url${members[index]['profile']['picture']}",
                  fit: BoxFit.cover,
                  width: 50.0,
                  height: 50.0,
                ),
              ),
              title: Text('${members[index]["profile"]["user"]["username"]}'),
              subtitle: Text('Rank: ${members[index]["rank"]}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  (widget.groupMember["rank"] > members[index]["rank"]) && (members[index]["rank"] != 1) ? TextButton(
                      onPressed: () {
                        setState(() {
                          loading = true;
                        });
                        updateRank(members[index]["id"], {"rank": members[index]["rank"]+1}).then((value) {
                          getMembersByGroup(widget.groupMember["group"]["id"]).then((value) {
                            setState(() {
                              members = jsonDecode(value);
                              loading = false;
                            });
                          });
                        });
                      },
                      child: const Text("Promote",)
                    ) : Container(),
                  (widget.groupMember["rank"] > members[index]["rank"]) && (members[index]["rank"] != 0) ? TextButton(
                      onPressed: () {
                        setState(() {
                          loading = true;
                        });
                        updateRank(members[index]["id"], {"rank": members[index]["rank"]-1}).then((value) {
                          getMembersByGroup(widget.groupMember["group"]["id"]).then((value) {
                            setState(() {
                              members = jsonDecode(value);
                              loading = false;
                            });
                          });
                        });
                      },
                      child: const Text("Demote",
                        style: TextStyle(
                          color: Colors.red
                        ),
                      )
                  ) : Container(),
                ],
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
            );
          }
        ),
    );
  }
}
