import 'dart:convert';

import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';

class CommentSection extends StatefulWidget {
  CommentSection({Key? key, required this.profile, required this.post}) : super(key: key);
  Map<String, dynamic> profile;
  Map<String, dynamic> post;


  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  TextEditingController commentSearch = TextEditingController();

  List filedata = [];
  bool updating = false;
  int updateKey = -1;
  bool deleting = false;
  List commentLikes = [];
  List tempComments = [];
  List tempLikes = [];
  bool commentLoading = true;
  String searchResults = "";
  Widget commentChild(data) {
    return ListView(
      children: [
        for (var i = 0; i < data.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: Container(
                height: 50.0,
                width: 50.0,
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: CircleAvatar(
                    radius: 50,
                    backgroundImage: CommentBox.commentImageParser(
                        imageURLorPath: "$image_url${data[i]['posted_by']['picture']}")),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data[i]['posted_by']['user']['username'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("${data[i]['date_posted'].toString().substring(0, 10)} ${data[i]['date_posted'].toString().substring(12, 16)}" , style: TextStyle(fontSize: 10)),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${data[i]['text']}"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if(commentLikes[i] == 0) {
                            addCommentLikes({"profile_id": widget.profile["id"], "comment_id": filedata[i]["id"], "liked": true, "disliked": false});
                            setState(() {
                              commentLikes[i] = 2;
                              filedata[i]["likes"] = filedata[i]["likes"] + 1;
                            });
                            updateComment(filedata[i]["id"], {"likes": 1});
                          } else if(commentLikes[i] == 1 || commentLikes[i] == 3) {
                            updateCommentLikes(filedata[i]["id"], widget.profile["id"], {"profile_id": widget.profile["id"], "comment_id": filedata[i]["id"], "liked": true, "disliked": false});
                            if(commentLikes[i] == 3) {
                              updateComment(filedata[i]["id"], {"likes": 1, "dislikes": -1});
                              setState(() {
                                filedata[i]["dislikes"] -= 1;
                              });
                            } else {
                              updateComment(filedata[i]["id"], {"likes": -1});
                            }
                            setState(() {
                              commentLikes[i] = 2;
                              filedata[i]["likes"] += 1;
                            });
                          } else {
                            updateCommentLikes(filedata[i]["id"], widget.profile["id"], {"profile_id": widget.profile["id"], "comment_id": filedata[i]["id"], "liked": false, "disliked": false});
                            setState(() {
                              commentLikes[i] = 1;
                              filedata[i]["likes"] -= 1;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            commentLikes[i] != 2 ? const Icon(Icons.thumb_up_outlined, size: 15.0,) : const Icon(Icons.thumb_up_outlined,
                              color: Colors.teal,
                              size: 15.0
                            ),
                            Text("(${filedata[i]['likes']})"),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20.0,),
                      GestureDetector(
                        onTap: () {
                          if(commentLikes[i] == 0) {
                            addCommentLikes({"profile_id": widget.profile["id"], "comment_id": filedata[i]["id"], "liked": false, "disliked": true});
                            setState(() {
                              commentLikes[i] = 3;
                              filedata[i]["dislikes"] += 1;
                            });
                            updateComment(filedata[i]["id"], {"dislikes": 1});
                          } else if(commentLikes[i] == 1 || commentLikes[i] == 2) {
                            updateCommentLikes(filedata[i]["id"], widget.profile["id"], {"profile_id": widget.profile["id"], "comment_id": filedata[i]["id"], "liked": false, "disliked": true});
                            if(commentLikes[i] == 2) {
                              updateComment(filedata[i]["id"], {"likes": -1, "dislikes": 1});
                              setState(() {
                                filedata[i]["likes"] -= 1;
                              });
                            } else {
                              updateComment(filedata[i]["id"], {"dislikes": 1});
                            }
                            setState(() {
                              commentLikes[i] = 3;
                              filedata[i]["dislikes"] += 1;
                            });
                          } else {
                            updateCommentLikes(filedata[i]["id"], widget.profile["id"], {"profile_id": widget.profile["id"], "comment_id": filedata[i]["id"], "liked": false, "disliked": false});
                            setState(() {
                              commentLikes[i] = 1;
                              filedata[i]["dislikes"] -= 1;
                            });
                            updateComment(filedata[i]["id"], {"dislikes": -1});
                          }
                        },
                        child: Row(
                          children: [
                            commentLikes[i] != 3 ? const Icon(Icons.thumb_down_outlined,
                              size: 15.0,
                            ) : const Icon(Icons.thumb_down_outlined,
                              size: 15.0,
                              color: Colors.teal,
                            ),
                            Text("(${filedata[i]['dislikes']})"),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20.0,),
                      data[i]["posted_by"]["id"] == widget.profile["id"] ?
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            updating=true;
                            commentController.text=data[i]["text"];
                            updateKey=data[i]["id"];
                          });
                          myFocusNode.requestFocus();
                        },
                        child: const Text("Edit",
                          style: TextStyle(
                            color: Colors.blue
                          ),
                        ),
                      ) : Container(),
                      const SizedBox(width: 20.0,),
                      data[i]["posted_by"]["id"] == widget.profile["id"] ?
                      GestureDetector(
                        onTap: () {
                          deleting ? const CircularProgressIndicator() : showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Delete Comment"),
                                  content: const Text("Are you sure you want to delete this comment"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            deleting = true;
                                          });
                                          // deleteComment(posts[index]["id"]).then((value) {
                                          //   getPosts(widget.profile["id"]).then((value) {
                                          //     setState(() {
                                          //       posts = jsonDecode(value);
                                          //       deleting = false;
                                          //     });
                                          //     Navigator.pop(context);
                                          //   });
                                          // });
                                          deleteComment(data[i]["id"]).then((value) {
                                            getComments(widget.post["id"]).then((value) {
                                              setState(() {
                                                tempComments = jsonDecode(value);
                                              });
                                              if(filedata.length == 0) {
                                                setState(() {
                                                  commentLoading=false;
                                                });
                                              }
                                              for(int i=0; i<tempComments.length; i++) {
                                                print(tempComments[i]["id"]);
                                                getCommentLikes(tempComments[i]["id"], widget.profile["id"]).then((value) {
                                                  value = jsonDecode(value);
                                                  if(value.length == 0) {
                                                    tempLikes.add(0);
                                                  }
                                                  else if(value["liked"] == false && value["disliked"] == false) {
                                                    tempLikes.add(1);
                                                  } else if(value["liked"] == true) {
                                                    tempLikes.add(2);
                                                  } else if(value["disliked"] == true) {
                                                    tempLikes.add(3);
                                                  }
                                                  if(i == tempComments.length-1) {
                                                    setState(() {
                                                      filedata = tempComments;
                                                      commentLikes = tempLikes;
                                                    });
                                                  }
                                                });
                                              }
                                            });
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Text("Yes")
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel")
                                    )
                                  ],
                                );
                              }
                          );
                        },
                        child: const Text("Delete",
                          style: TextStyle(
                              color: Colors.red
                          ),
                        ),
                      ) : Container(),
                    ],
                  )
                ],
              ),
              // trailing: Text("${data[i]['date_posted'].toString().substring(0, 10)} ${data[i]['date_posted'].toString().substring(12, 16)}" , style: TextStyle(fontSize: 10)),
            ),
          )
      ],
    );
  }

  @override
  void initState() {
    getComments(widget.post["id"]).then((value) {
      setState(() {
        filedata = jsonDecode(value);
      });
      if(filedata.length == 0) {
        setState(() {
          commentLoading=false;
        });
      }
      for(int i=0; i<filedata.length; i++) {
        print(filedata[i]["id"]);
        getCommentLikes(filedata[i]["id"], widget.profile["id"]).then((value) {
          value = jsonDecode(value);
          if(value.length == 0) {
            commentLikes.add(0);
          }
          else if(value["liked"] == false && value["disliked"] == false) {
            commentLikes.add(1);
          } else if(value["liked"] == true) {
            commentLikes.add(2);
          } else if(value["disliked"] == true) {
            commentLikes.add(3);
          }
          if(i == filedata.length-1) {
            setState(() {
              commentLoading = false;
            });
          }
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
        title: const Text("Comments",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,

      ),
      body: Container(
        child: CommentBox(
          userImage: CommentBox.commentImageParser(
              imageURLorPath: "$image_url${widget.profile["picture"]}"),

          labelText: 'Write a comment...',
          errorText: 'Comment cannot be blank',
          withBorder: false,
          sendButtonMethod: () {
            if (formKey.currentState!.validate()) {
              print(commentController.text);
              if(updating == false) {
                addComment({"post_id": widget.post["id"], "profile_id": widget.profile["id"], "text": commentController.text}).then((value) {
                  getComments(widget.post["id"]).then((value) {
                    setState(() {
                      tempComments = jsonDecode(value);
                    });
                    if(filedata.length == 0) {
                      setState(() {
                        commentLoading=false;
                      });
                    }
                    for(int i=0; i<tempComments.length; i++) {
                      print(tempComments[i]["id"]);
                      getCommentLikes(tempComments[i]["id"], widget.profile["id"]).then((value) {
                        value = jsonDecode(value);
                        if(value.length == 0) {
                          tempLikes.add(0);
                        }
                        else if(value["liked"] == false && value["disliked"] == false) {
                          tempLikes.add(1);
                        } else if(value["liked"] == true) {
                          tempLikes.add(2);
                        } else if(value["disliked"] == true) {
                          tempLikes.add(3);
                        }
                        if(i == tempComments.length-1) {
                          setState(() {
                            filedata = tempComments;
                            commentLikes = tempLikes;
                          });
                        }
                      });
                    }
                  });
                });
              } else {
                updateComment(updateKey, {"post_id": widget.post["id"], "profile_id": widget.profile["id"], "text": commentController.text}).then((value) {
                  getComments(widget.post["id"]).then((value) {
                    setState(() {
                      tempComments = jsonDecode(value);
                    });
                    if(filedata.length == 0) {
                      setState(() {
                        commentLoading=false;
                      });
                    }
                    for(int i=0; i<tempComments.length; i++) {
                      print(tempComments[i]["id"]);
                      getCommentLikes(tempComments[i]["id"], widget.profile["id"]).then((value) {
                        value = jsonDecode(value);
                        if(value.length == 0) {
                          tempLikes.add(0);
                        }
                        else if(value["liked"] == false && value["disliked"] == false) {
                          tempLikes.add(1);
                        } else if(value["liked"] == true) {
                          tempLikes.add(2);
                        } else if(value["disliked"] == true) {
                          tempLikes.add(3);
                        }
                        if(i == tempComments.length-1) {
                          setState(() {
                            filedata = tempComments;
                            commentLikes = tempLikes;
                          });
                        }
                      });
                    }
                  });
                });
              }
              commentController.clear();
              FocusScope.of(context).unfocus();
            } else {
              print("Not validated");
            }
          },
          formKey: formKey,
          focusNode: myFocusNode,
          commentController: commentController,
          backgroundColor: Colors.teal,
          textColor: Colors.white,
          sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
          child: commentLoading ?
          const Center(child: CircularProgressIndicator()) :
          Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                child: TextField(
                  controller: commentSearch,
                  onChanged: (text) {
                    print(text);
                    searchComments(widget.post["id"], text).then((value) {
                      setState(() {
                        searchResults = text;
                        filedata=jsonDecode(value);
                      });
                      if(text == "") {
                        getComments(widget.post["id"]).then((value) {
                          setState(() {
                            filedata = jsonDecode(value);
                          });
                          if(filedata.length == 0) {
                            setState(() {
                              commentLoading=false;
                            });
                          }
                          print(filedata.length);
                          for(int i=0; i<filedata.length; i++) {
                            print(filedata[i]["id"]);
                            getCommentLikes(filedata[i]["id"], widget.profile["id"]).then((value) {
                              value = jsonDecode(value);
                              if(value.length == 0) {
                                commentLikes.add(0);
                              }
                              else if(value["liked"] == false && value["disliked"] == false) {
                                commentLikes.add(1);
                              } else if(value["liked"] == true) {
                                commentLikes.add(2);
                              } else if(value["disliked"] == true) {
                                commentLikes.add(3);
                              }
                              if(i == filedata.length-1) {
                                setState(() {
                                  commentLoading = false;
                                });
                              }
                            });
                          }
                        });
                      }
                    });
                    // searchUser({"search": text}).then((value) {
                    //   setState(() {
                    //     search_results = text;
                    //     userList = value;
                    //   });
                    //
                    // });

                  },
                  decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      hintText: "Search Comments"
                  ),
                ),
              ),
              Expanded(child: commentChild(filedata)),
            ],
          ),
        ),
      ),
    );
  }
}

//
// class CommentBox extends StatefulWidget {
//   @override
//   _CommentBoxState createState() => _CommentBoxState();
// }
//
// class _CommentBoxState extends State<CommentBox> {
//   final formKey = GlobalKey<FormState>();
//   final TextEditingController commentController = TextEditingController();
//   List filedata = [
//     {
//       'name': 'Declan Rice',
//       'pic': 'https://picsum.photos/300/30',
//       'message': 'Good one.',
//       'date': '2021-01-01 12:00:00'
//     },
//     {
//       'name': 'Leon Goretzka',
//       'pic': 'https://www.adeleyeayodeji.com/img/IMG_20200522_121756_834_2.jpg',
//       'message': 'Very cool',
//       'date': '2021-01-01 12:00:00'
//     },
//     {
//       'name': 'Tunde Martins',
//       'pic': 'assets/img/userpic.jpg',
//       'message': 'Very cool',
//       'date': '2021-01-01 12:00:00'
//     },
//     {
//       'name': 'John Wilbur',
//       'pic': 'https://picsum.photos/300/30',
//       'message': 'Very cool',
//       'date': '2021-01-01 12:00:00'
//     },
//   ];
//
//   Widget commentChild(data) {
//     return ListView(
//       children: [
//         for (var i = 0; i < data.length; i++)
//           Padding(
//             padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
//             child: ListTile(
//               leading: GestureDetector(
//                 onTap: () async {
//                   // Display the image in large form.
//                   print("Comment Clicked");
//                 },
//                 child: Container(
//                   height: 50.0,
//                   width: 50.0,
//                   decoration: new BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius: new BorderRadius.all(Radius.circular(50))),
//                   child: CircleAvatar(
//                       radius: 50,
//                       backgroundImage: CommentBox.commentImageParser(
//                           imageURLorPath: data[i]['pic'])),
//                 ),
//               ),
//               title: Text(
//                 data[i]['name'],
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: Text(data[i]['message']),
//               trailing: Text(data[i]['date'], style: TextStyle(fontSize: 10)),
//             ),
//           )
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Comment Page"),
//         backgroundColor: Colors.pink,
//       ),
//       body: Container(
//         // child: CommentBox(
//         //   userImage: CommentBox.commentImageParser(
//         //       imageURLorPath: "assets/img/userpic.jpg"),
//         //   child: commentChild(filedata),
//         //   labelText: 'Write a comment...',
//         //   errorText: 'Comment cannot be blank',
//         //   withBorder: false,
//         //   sendButtonMethod: () {
//         //     if (formKey.currentState!.validate()) {
//         //       print(commentController.text);
//         //       setState(() {
//         //         var value = {
//         //           'name': 'New User',
//         //           'pic':
//         //               'https://lh3.googleusercontent.com/a-/AOh14GjRHcaendrf6gU5fPIVd8GIl1OgblrMMvGUoCBj4g=s400',
//         //           'message': commentController.text,
//         //           'date': '2021-01-01 12:00:00'
//         //         };
//         //         filedata.insert(0, value);
//         //       });
//         //       commentController.clear();
//         //       FocusScope.of(context).unfocus();
//         //     } else {
//         //       print("Not validated");
//         //     }
//         //   },
//         //   formKey: formKey,
//         //   commentController: commentController,
//         //   backgroundColor: Colors.pink,
//         //   textColor: Colors.white,
//         //   sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
//         // ),
//       ),
//     );
//   }
// }