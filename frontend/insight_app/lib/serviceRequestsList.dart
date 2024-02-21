import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';

class ServiceRequestsList extends StatefulWidget {
  ServiceRequestsList({Key? key, required this.service, required this.isSpecialist, required this.specialist}) : super(key: key);
  Map service;
  bool isSpecialist;
  Map specialist;

  @override
  State<ServiceRequestsList> createState() => _ServiceRequestsListState();
}

class _ServiceRequestsListState extends State<ServiceRequestsList> {
  List serviceRequests = [];
  bool loading = true;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getServiceRequests(widget.service["id"]).then((value) {
      setState(() {
        serviceRequests = jsonDecode(value.body);
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
        title: Text(widget.service["name"],
          style: const TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: loading? const Center(child: CircularProgressIndicator(),) :
      serviceRequests.isEmpty ? const Center(child: Text("You have no requests"),) : ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          itemCount: serviceRequests.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  // border: Border.all(),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image.network(posts[index]["owner"]["picture"]),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Image.network("$image_url${serviceRequests[index]['sender']['picture']}",
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                            )
                        ),
                        const SizedBox(width: 15.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(serviceRequests[index]["sender"]["user"]["username"],
                              style: const TextStyle(
                                  color: Colors.teal,
                                  fontSize: 20.0
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.7,
                              child: Text(serviceRequests[index]["description"])
                            ),
                            TextButton(
                                onPressed: () {
                                  if(widget.isSpecialist) {
                                    createCustomer({"service_id": widget.service["id"], "profile_id": serviceRequests[index]["sender"]["id"], "specialist_id" : widget.specialist["id"]}).then((value) {
                                      setState(() {
                                        serviceRequests.removeAt(index);
                                      });
                                    });
                                  } else {
                                    deleteServiceRequest(serviceRequests[index]["id"]).then((value) {
                                      setState(() {
                                        serviceRequests.removeAt(index);
                                      });
                                    });
                                  }
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: widget.isSpecialist ? Colors.teal : Colors.red,
                                  padding: const EdgeInsets.symmetric(horizontal: 100.0)
                                ),
                                child: widget.isSpecialist ? const Text("Serve",
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ) : const Text("Remove",
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                )
                            )
                          ],
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            );
          }
      ),

    );
  }
}
