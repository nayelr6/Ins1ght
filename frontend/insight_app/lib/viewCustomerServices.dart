import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';
import 'package:insight_app/customerServicePage.dart';

class ViewCustomerServices extends StatefulWidget {
  ViewCustomerServices({Key? key, required this.profile, required this.category}) : super(key: key);
  Map profile;
  String category;

  @override
  State<ViewCustomerServices> createState() => _ViewCustomerServicesState();
}

class _ViewCustomerServicesState extends State<ViewCustomerServices> {
  bool customersLoading = true;
  List customers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomers(widget.profile["id"]).then((value) {
      setState(() {
        customers = jsonDecode(value.body);
        customersLoading = false;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text("Hired Services",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: customersLoading? const Center(child: CircularProgressIndicator(),) : customers.isEmpty ? const Center(
        child: Text("You have no services"),
      ) : Container(
        margin: const EdgeInsets.all(5.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: customers.length,
          itemBuilder: (context, index) {
            //fix here
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15.0)
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerServicePage(customer: customers[index])));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customers[index]["service"]["name"],
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal
                      ),
                    ),
                    Text(customers[index]["service"]["description"],
                      style: const TextStyle(
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
