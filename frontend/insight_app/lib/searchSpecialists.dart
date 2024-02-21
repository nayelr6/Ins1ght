import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';

class SearchSpecialists extends StatefulWidget {
  SearchSpecialists({Key? key, required this.service}) : super(key: key);
  Map service;

  @override
  State<SearchSpecialists> createState() => _SearchSpecialistsState();
}

class _SearchSpecialistsState extends State<SearchSpecialists> {
  TextEditingController _specialistController = TextEditingController();
  bool resultsLoading = true;
  List specialists = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchSpecialists(widget.service["id"], {"search": ""}).then((value) {
      setState(() {
        specialists = value;
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
        title: const Text("Search Specialists",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
              child: TextField(
                controller: _specialistController,
                onChanged: (text) {
                  resultsLoading = true;
                  searchSpecialists(widget.service["id"], {"search": _specialistController.text}).then((value) {
                    setState(() {
                      specialists = value;
                      resultsLoading = false;
                    });
                  });
                },
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    hintText: "Search For Specialists"
                ),
              ),
            ),
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
                          title: Text(specialists[index]["user"]["username"]),
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Image.network('$image_url${specialists[index]["picture"]}',
                                width: 60.0,
                                height: 60.0,
                              )
                          ),
                          trailing: TextButton(
                            onPressed: () {
                              print("Working");
                              addSpecialists({"service_id": widget.service["id"], "profile_id": specialists[index]["id"]}).then((value) {
                                setState(() {
                                  specialists.removeAt(index);
                                });
                              });
                            },
                            child: const Text("ADD"),
                          ),
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
