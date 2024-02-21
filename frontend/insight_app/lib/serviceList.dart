import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';
import 'package:insight_app/serviceDetail.dart';

class ServiceList extends StatefulWidget {
  ServiceList({Key? key, required this.profile, required this.category}) : super(key: key);
  Map profile;
  String category;

  @override
  State<ServiceList> createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  bool loading = true;
  List services = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getService(widget.category).then((value) {
      setState(() {
        services = jsonDecode(value.body);
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
        title: Text(widget.category,
          style: const TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: loading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: services.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              print(services[index]["name"]);
              print(widget.profile["user"]["username"]);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetail(profile: widget.profile, category: widget.category, service: services[index])));
            },
            title: Text(services[index]["name"],
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal
              ),
            ),
            subtitle: Text(services[index]["owner"]["user"]["username"],
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
              ),
            ),
            trailing: services[index]["average_rating"] == null ? const Text("Unrated",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.teal,
              )
            ) : Text(
              (services[index]["average_rating"]).toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.teal,
              ),
            ),
          );
        }
      ),
    );
  }
}
