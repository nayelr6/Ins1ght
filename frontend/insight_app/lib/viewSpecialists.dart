import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';

class ViewSpecialists extends StatefulWidget {
  ViewSpecialists({Key? key, required this.service}) : super(key: key);
  Map service;

  @override
  State<ViewSpecialists> createState() => _ViewSpecialistsState();
}

class _ViewSpecialistsState extends State<ViewSpecialists> {
  bool resultsLoading = true;
  List specialists = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSpecialists(widget.service["id"]).then((value) {
      setState(() {
        specialists = jsonDecode(value.body);
        resultsLoading = false;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text("View Specialists",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        child: Column(
          children: [
            resultsLoading ? const Center(child: CircularProgressIndicator(),)
                : specialists.isEmpty ? const Center(child: Text("There are no specialists working for you"),) : Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: specialists.length,
                itemBuilder: (context, index) {
                  //fix here
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(15.0)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(specialists[index]["profile"]["user"]["username"]),
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Image.network('$image_url${specialists[index]["profile"]["picture"]}',
                                width: 60.0,
                                height: 60.0,
                              )
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              deleteSpecialist(specialists[index]["id"]).then((value) {
                                setState(() {
                                  specialists.removeAt(index);
                                });
                              });
                            },
                            icon: const Icon(Icons.delete,
                              color: Colors.red,
                            ),
                          )
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
