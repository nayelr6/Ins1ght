import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';
import 'package:insight_app/rateService.dart';
import 'package:insight_app/serviceConversation.dart';
import 'package:insight_app/viewEvents.dart';

class CustomerServicePage extends StatefulWidget {
  CustomerServicePage({Key? key, required this.customer}) : super(key: key);
  Map customer;

  @override
  State<CustomerServicePage> createState() => _CustomerServicePageState();
}

class _CustomerServicePageState extends State<CustomerServicePage> {
  bool deleting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: Text(widget.customer["service"]["name"],
          style: const TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceConversation(customer: widget.customer, specialist: widget.customer["specialist"], profile: widget.customer["profile"])));
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
              child: const Text("Talk To Specialist",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RateService(customer: widget.customer)));
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
              child: const Text("Rate Service",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewEventsOwner(service: widget.customer["service"], isOwner: false)));
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
              child: const Text("View Events",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              deleting ? const CircularProgressIndicator() : showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Quit Service"),
                      content: const Text("Are you sure you want to quit this service"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                deleting = true;
                              });
                              deleteCustomer(widget.customer["id"]).then((value) {
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
              child: const Text("End Service",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
