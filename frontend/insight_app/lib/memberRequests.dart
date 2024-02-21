import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';

class MemberRequests extends StatefulWidget {
  MemberRequests({Key? key, required this.groupMember}) : super(key: key);
  Map groupMember;

  @override
  State<MemberRequests> createState() => _MemberRequestsState();
}

class _MemberRequestsState extends State<MemberRequests> {
  List requests = [];
  bool updating = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getGroupRequests(widget.groupMember["group"]["id"]).then((value) {
      setState(() {
        requests = jsonDecode(value);
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
        title: const Text("Member Requests",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: loading == true ? const Center(child: CircularProgressIndicator(),) : requests.length == 0 ? const Center(
        child: Text("You have no requests for this group"),
      ) : updating == false ? ListView.builder(
          shrinkWrap: true,
          itemCount: requests.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15.0)
              ),
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Image.network('$image_url${requests[index]["sender"]["picture"]}',
                        width: 60.0,
                        height: 60.0,
                        fit: BoxFit.cover,
                      )
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text('${requests[index]["sender"]["user"]["username"]}',
                              style: const TextStyle(
                                  color: Colors.teal,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                        ),
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      updating = true;
                                    });
                                    createGroupMember({"profile_id": requests[index]["sender"]["id"], "group_id": requests[index]["group"]["id"], "direct": false}).then((value) {
                                      requests.removeAt(index);
                                      setState(() {
                                        updating = false;
                                      });
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.teal
                                  ),
                                  child: const Text("Accept",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )
                              ),
                            ),
                            const SizedBox(width: 15.0,),
                            Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      updating = true;
                                    });
                                    deleteGroupRequest(requests[index]["id"]).then((value) {
                                      requests.removeAt(index);
                                      setState(() {
                                        updating = false;
                                      });
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.black12
                                  ),
                                  child: const Text("Reject",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  )
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  )
                ],
              ),
            );
          }
      ) : const Center(child: CircularProgressIndicator(),),
    );
  }
}
