import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';
import 'package:insight_app/serviceConversation.dart';

class ViewCustomers extends StatefulWidget {
  ViewCustomers({Key? key, required this.specialist}) : super(key: key);
  Map specialist;

  @override
  State<ViewCustomers> createState() => _ViewCustomersState();
}

class _ViewCustomersState extends State<ViewCustomers> {
  bool loading = true;
  List customers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomersBySpecialistId(widget.specialist["id"]).then((value) {
      setState(() {
        customers = jsonDecode(value.body);
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
        title: const Text("View My Clients",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: loading? const Center(child: CircularProgressIndicator(),) :
      customers.isEmpty ? const Center(child: Text("You have no customers"),) : ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          itemCount: customers.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceConversation(customer: customers[index], specialist: widget.specialist, profile: widget.specialist["profile"])));
              },
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
                            child: Image.network("$image_url${customers[index]['profile']['picture']}",
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                            )
                        ),
                        const SizedBox(width: 15.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(customers[index]["profile"]["user"]["username"],
                              style: const TextStyle(
                                  color: Colors.teal,
                                  fontSize: 20.0
                              ),
                            ),
                            Text(customers[index]["profile"]["user"]["email"],
                              style: const TextStyle(
                                  color: Colors.teal,
                                  fontSize: 20.0
                              ),
                            ),
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
