import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';

class RateService extends StatefulWidget {
  RateService({Key? key, required this.customer}) : super(key: key);
  Map customer;

  @override
  State<RateService> createState() => _RateServiceState();
}

class _RateServiceState extends State<RateService> {
  TextEditingController _review = TextEditingController();
  int selected = -1;
  bool ratingSelected = false;
  bool reviewProvided = false;
  bool submitting = false;
  bool loading = true;
  bool ratedBefore = false;
  dynamic rating;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserRatings(widget.customer["service"]["id"], widget.customer["profile"]["id"]).then((value) {
      if(value.statusCode == 200) {
        print("Response found");
        Map userRating = jsonDecode(value.body);
        setState(() {
          rating = userRating;
          selected = userRating["rating"];
          _review.text = userRating["review"];
          ratedBefore = true;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text("Add Rating",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          const Text("Pick a rating: "),
          const SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selected = 1;
                    ratingSelected = true;
                  });
                },
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: selected == 1 ? Colors.teal : Colors.grey
                  ),
                  child: const Center(
                    child: Text("1",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selected = 2;
                    ratingSelected = true;
                  });
                },
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: selected == 2 ? Colors.teal : Colors.grey
                  ),
                  child: const Center(
                    child: Text("2",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selected = 3;
                    ratingSelected = true;
                  });
                },
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: selected == 3 ? Colors.teal : Colors.grey
                  ),
                  child: const Center(
                    child: Text("3",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selected = 4;
                    ratingSelected = true;
                  });
                },
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: selected == 4 ? Colors.teal : Colors.grey
                  ),
                  child: const Center(
                    child: Text("4",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selected = 5;
                    ratingSelected = true;
                  });
                },
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: selected == 5 ? Colors.teal : Colors.grey
                  ),
                  child: const Center(
                    child: Text("5",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0,),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
            child: TextField(
              onChanged: (text) {
                if(_review.text.isNotEmpty) {
                  setState(() {
                    reviewProvided = true;
                  });
                } else {
                  setState(() {
                    reviewProvided = false;
                  });
                }
              },
              controller: _review,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  // labelText: "Username",
                  hintText: "Add a review"
              ),
            ),
          ),
          const SizedBox(height: 20.0,),
          submitting ? const CircularProgressIndicator() : TextButton(
            style: TextButton.styleFrom(
              backgroundColor: ((ratingSelected && reviewProvided) || ratedBefore) ? Colors.teal : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                submitting = true;
              });
              if(ratedBefore) {
                updateRating(rating["id"], {"rating": selected, "review": _review.text}).then((value) {
                  Navigator.pop(context);
                });
              } else {
                postRating({"service_id": widget.customer["service"]["id"], "profile_id": widget.customer["profile"]["id"], "rating": selected, "review": _review.text}).then((value) {
                  Navigator.pop(context);
                });
              }
            },
            child: Text(
              ratedBefore ? "Update Rating" : "Add Rating",
              style: const TextStyle(
                color: Colors.white
              ),
            )
          )
        ],
      ),
    );
  }
}
