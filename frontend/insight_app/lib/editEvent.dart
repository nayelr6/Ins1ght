import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';

class EditEvent extends StatefulWidget {
  EditEvent({Key? key, required this.service, required this.event}) : super(key: key);
  Map service;
  Map event;

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _startDate = TextEditingController();
  TextEditingController _endDate = TextEditingController();
  TextEditingController _location = TextEditingController();
  bool titleSelected = true;
  bool descSelected = true;
  bool startSelected = true;
  bool endSelected = true;
  bool locationSelected = true;
  bool updating = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _title.text = widget.event["title"];
    // _description.text = "helo";
    // _startDate.text = "helo";
    // _endDate.text = "helo";
    _description.text = widget.event["description"];
    _startDate.text = widget.event["start_date"];
    _endDate.text = widget.event["end_date"];
    _location.text = widget.event["location"];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text("Organize Event",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              width: MediaQuery.of(context).size.width*0.9,
              child: TextField(
                controller: _title,
                onChanged: (text) {
                  if(text != "") {
                    setState(() {
                      titleSelected = true;
                    });
                  } else {
                    setState(() {
                      titleSelected = false;
                    });
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Title",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              width: MediaQuery.of(context).size.width*0.9,
              child: TextField(
                controller: _startDate,
                onChanged: (text) {
                  if(text != "") {
                    setState(() {
                      startSelected = true;
                    });
                  } else {
                    setState(() {
                      startSelected = false;
                    });
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Start Date",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              width: MediaQuery.of(context).size.width*0.9,
              child: TextField(
                controller: _endDate,
                onChanged: (text) {
                  if(text != "") {
                    setState(() {
                      endSelected = true;
                    });
                  } else {
                    setState(() {
                      endSelected = false;
                    });
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "End Date",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              width: MediaQuery.of(context).size.width*0.9,
              child: TextField(
                controller: _location,
                onChanged: (text) {
                  if(text != "") {
                    setState(() {
                      locationSelected = true;
                    });
                  } else {
                    setState(() {
                      locationSelected = false;
                    });
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Location",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              width: MediaQuery.of(context).size.width*0.9,
              child: TextField(
                controller: _description,
                onChanged: (text) {
                  if(text != "") {
                    setState(() {
                      descSelected = true;
                    });
                  } else {
                    setState(() {
                      descSelected = false;
                    });
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Description",
                ),
              ),
            ),
            const SizedBox(height: 20.0,),
            updating ? const CircularProgressIndicator() : TextButton(
                onPressed: () {
                  setState(() {
                    updating = true;
                  });
                  if(_title.text.isNotEmpty && _description.text.isNotEmpty && _startDate.text.isNotEmpty && _endDate.text.isNotEmpty && _location.text.isNotEmpty) {
                    updateEvent(widget.event["id"], {"title": _title.text, "description": _description.text, "start_date": _startDate.text, "end_date": _endDate.text, "location": _location.text}).then((value) {
                      int counter = 0;
                      Navigator.popUntil(context, (route) {
                        counter++;
                        return counter==3;
                      });
                    });
                  }
                },
                style: TextButton.styleFrom(
                    backgroundColor: titleSelected && descSelected && startSelected && endSelected && locationSelected ? Colors.teal : Colors.grey
                ),
                child: const Text("Update",
                  style: TextStyle(
                      color: Colors.white
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
