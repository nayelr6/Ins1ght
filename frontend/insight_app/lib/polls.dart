import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';

class Polls extends StatefulWidget {
  Polls({Key? key, required this.groupMember}) : super(key: key);
  Map groupMember;

  @override
  State<Polls> createState() => _PollsState();
}

class _PollsState extends State<Polls> {
  // Map question = {"text": "How many hours would you like to sleep?"};
  Map question = {};
  List answers = [];
  int answer = 0;
  TextEditingController _question = TextEditingController();
  TextEditingController _option = TextEditingController();
  List optionsList = [];
  bool loading = true;
  Map chosenAnswer = {};
  bool voted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPoll(widget.groupMember["group"]["id"]).then((value) {
      try {
        Map pollQuestion = jsonDecode(value);
        setState(() {
          question = pollQuestion;
        });
        getChoices(pollQuestion["id"]).then((value) {
          print(value);
          setState(() {
            answers = jsonDecode(value);
            // loading = false;
          });
        });
        getPollRecord(widget.groupMember["id"], question["id"]).then((value) {
          setState(() {
            loading = false;
          });
          if(value.statusCode==200) {
            setState(() {
              voted = false;
            });
          }
        });
      } catch(e) {
        setState(() {
          loading = false;
        });
      }

    });
    getPollRecord(widget.groupMember["id"], widget.groupMember["group"]["id"]).then((value) {
      if(value.statusCode==200) {
        setState(() {
          voted = true;
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
        title: const Text("Polls",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: loading? const Center(child: CircularProgressIndicator(),) : question.isEmpty ? Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: TextField(
              maxLength: 50,
              controller: _question,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  // labelText: "Username",
                  hintText: "Question"
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.7,
                margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: TextField(
                  maxLength: 50,
                  controller: _option,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      // labelText: "Username",
                      hintText: "Add an option"
                  ),
                ),
              ),
              Container(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      optionsList.add(_option.text);
                    });
                    _option.clear();
                  },
                  child: const Text("Add")
                ),
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: optionsList.length,
              itemBuilder: (context, index) {
                return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    decoration: BoxDecoration(
                      // border: Border.all(),
                        borderRadius: BorderRadius.circular(5.0),
                        // color: Colors.teal,
                        border: Border.all(color: Colors.black)
                    ),
                    child: Text("Option ${index+1}: ${optionsList[index]}")
                );
              }
            )
          ),
          TextButton(
              onPressed: () {
                // createQuestion({"choice_text": _question.text});
                createPoll({"owner_id": widget.groupMember["profile"]["id"], "group_id": widget.groupMember["group"]["id"], "question_text": _question.text}).then((value) {
                  Map question = jsonDecode(value);
                  for(int i=0; i< optionsList.length; i++) {
                    print(optionsList[i]);
                    createChoice({"question_id": question["id"], "choice_text": optionsList[i]}).then((value) {
                      print(value);
                    });
                  }
                  Navigator.pop(context);
                });
              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.teal,
                  fixedSize: Size(MediaQuery.of(context).size.width*0.95, 50.0)
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                    color: Colors.white
                ),
              )
          ),
        ],
      ) : Column(
        children: [
          const SizedBox(height: 10.0,),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
            child: Center(
              child: Text(question["question_text"],
                style: const TextStyle(
                  fontSize: 20.0
                ),
              ),
            ),
          ),
          const SizedBox(height: 15.0,),
          Expanded(
            child: ListView.builder(
              itemCount: answers.length,
              itemBuilder: (context, index) {
                return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    decoration: BoxDecoration(
                      // border: Border.all(),
                      borderRadius: BorderRadius.circular(5.0),
                      // color: Colors.teal,
                      border: Border.all(color: Colors.black)
                    ),
                    child: RadioListTile(
                        value: answers[index]["id"],
                        groupValue: answer,
                        title: Text('${answers[index]["choice_text"]} (${answers[index]["votes"]} votes)'),
                        onChanged: (val) {
                          setState(() {
                            answer = answers[index]["id"];
                            chosenAnswer = answers[index];
                          });
                        },
                    )
                );
              }
            )
          ),
          voted == true ? TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.teal,
                  fixedSize: Size(MediaQuery.of(context).size.width*0.95, 50.0)
              ),
              child: const Text(
                'Poll is over',
                style: TextStyle(
                    color: Colors.white
                ),
              )
          ) : question["finished"]? widget.groupMember["rank"] == 2 ? TextButton(
              onPressed: () {
                deletePoll(question["id"]).then((value) {
                  Navigator.pop(context);
                });
              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.teal,
                  fixedSize: Size(MediaQuery.of(context).size.width*0.95, 50.0)
              ),
              child: const Text(
                'Delete poll',
                style: TextStyle(
                    color: Colors.white
                ),
              )
          ) : TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.teal,
                  fixedSize: Size(MediaQuery.of(context).size.width*0.95, 50.0)
              ),
              child: const Text(
                'Poll is over',
                style: TextStyle(
                    color: Colors.white
                ),
              )
          ) :  widget.groupMember["profile"]["id"] != question["owner"]["id"] ? TextButton(
            onPressed: () {
              postPollRecord({"owner_id": widget.groupMember["id"], "question_id": question["id"], "choice_id": answer}).then((value) {
                updateChoice(answer, {"votes": chosenAnswer["votes"]+1}).then((value) {
                  Navigator.pop(context);
                });
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.teal,
              fixedSize: Size(MediaQuery.of(context).size.width*0.95, 50.0)
            ),
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Colors.white
              ),
            )
          ) : TextButton(
              onPressed: () {
                updatePoll(question["id"], {"finished": true}).then((value) {
                  Navigator.pop(context);
                });
              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.teal,
                  fixedSize: Size(MediaQuery.of(context).size.width*0.95, 50.0)
              ),
              child: const Text(
                'End poll',
                style: TextStyle(
                    color: Colors.white
                ),
              )
          ),
        ],
      ),
    );
  }
}
