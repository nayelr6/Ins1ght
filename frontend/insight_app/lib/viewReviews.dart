import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';

class ViewReviews extends StatefulWidget {
  ViewReviews({Key? key, required this.service}) : super(key: key);
  Map service;

  @override
  State<ViewReviews> createState() => _ViewReviewsState();
}

class _ViewReviewsState extends State<ViewReviews> {
  bool loading = true;
  List ratings = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRatings(widget.service["id"]).then((value) {
      setState(() {
        if(value.statusCode == 200) {
          ratings = jsonDecode(value.body);
        }
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
      body: loading ? const Center(child: CircularProgressIndicator(),) : ratings.isEmpty ?
        const Center(child: Text("You have no reviews"),) : ListView.builder(
          shrinkWrap: true,
          itemCount: ratings.length,
          itemBuilder: (context, index) {
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
                  Row(
                    children: [
                      // Image.network(posts[index]["owner"]["picture"]),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Image.network("$image_url${ratings[index]['profile']['picture']}",
                            width: 50.0,
                            height: 50.0,
                            fit: BoxFit.cover,
                          )
                      ),
                      const SizedBox(width: 15.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ratings[index]["profile"]["user"]["username"],
                            style: const TextStyle(
                                color: Colors.teal,
                                fontSize: 20.0
                            ),
                          ),
                          Text("Rating: ${ratings[index]["rating"]} / 5",
                            style: const TextStyle(
                                fontSize: 14.0
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(ratings[index]["review"]),
                  )
                ],
              ),
            );
          }
      ),
    );
  }
}
