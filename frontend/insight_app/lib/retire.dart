import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';

class Retire extends StatefulWidget {
  Retire({Key? key, required this.groupMember}) : super(key: key);
  Map groupMember;
  
  @override
  State<Retire> createState() => _RetireState();
}

class _RetireState extends State<Retire> {
  bool loading = true;
  List members = [];
  
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
                if(members[index]["rank"] != 2) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Transfer Ownership"),
                          content: Text("Are you sure you want to make ${members[index]['profile']['user']["username"]} the owner of the group?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    loading = true;
                                  });
                                  updateGroup(widget.groupMember["group"]["id"],
                                      {"owner_id": members[index]['profile']['id']}).then((value) {
                                    updateRank(widget.groupMember["id"], {"rank": 1}).then((value) {
                                      updateRank(members[index]["id"], {"rank": 2}).then((value) {
                                        setState(() {
                                          loading = false;
                                        });
                                        Navigator.pop(context);
                                        int counter = 0;
                                        Navigator.popUntil(context, (route) {
                                          counter++;
                                          return counter == 3;
                                        });
                                      });
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
            );
          }
      ),
    );
  }
}
