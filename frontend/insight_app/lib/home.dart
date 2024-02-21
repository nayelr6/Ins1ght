import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insight_app/addPost.dart';
import 'package:insight_app/comment.dart';
import 'package:insight_app/editPost.dart';
import 'package:insight_app/groupList.dart';
import 'package:insight_app/message.dart';
import 'package:insight_app/serviceCategories.dart';
import 'package:insight_app/servicePage.dart';
import 'signIn.dart';
import 'UpdateProfile.dart';
import 'api.dart';

class Home extends StatefulWidget {
  Home({Key? key, required this.profile}) : super(key: key);
  Map<String, dynamic> profile;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _users = TextEditingController();
  String search_results = '';
  List userList = [];
  bool sendingRequest = false;
  List receives = [];
  List friendsList = [];
  bool postLoading = true;
  List posts = [];
  List postLikes = [];
  bool postPage = true;
  bool deleting = false;
  List tempPosts = [];
  List tempPostLikes = [];
  TextEditingController postController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(widget.profile["id"]);
    getProfile(widget.profile["id"]).then((value) {
      Map<String, dynamic> user_profile = jsonDecode(value);
      setState(() {
        widget.profile = user_profile;
      });
      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home(profile: user_profile)), (route) => false);
    });
    getRequests({"pk": widget.profile["id"]}).then((value) {
      setState(() {
        receives = value;
      });
    });
    getFriends(widget.profile["id"]).then((value) {
      setState(() {
        friendsList = value;
      });
    });
    getPosts(widget.profile["id"]).then((value) {
      setState(() {
        posts = jsonDecode(value);
        // postLoading = false;
      });
      for(int i=0; i<posts.length; i++) {
        getPostLikes(posts[i]["id"], widget.profile["id"]).then((value) {

          value = jsonDecode(value);
          if(value.length == 0) {
            postLikes.add(0);
          }
          else if(value["liked"] == false && value["disliked"] == false) {
            postLikes.add(1);
          } else if(value["liked"] == true) {
            postLikes.add(2);
          } else if(value["disliked"] == true) {
            postLikes.add(3);
          }
          if(i == posts.length-1) {
            Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                postLoading = false;
              });
            });
          }
        });
      }
    });

  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Insight",
            style: TextStyle(
              color: Colors.white
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(icon: GestureDetector(
                  onLongPress: () {
                    getPosts(widget.profile["id"]).then((value) {
                      setState(() {
                        tempPosts = jsonDecode(value);
                      });
                      for(int i=0; i<posts.length; i++) {
                        print(posts[i]["id"]);
                        getPostLikes(posts[i]["id"], widget.profile["id"]).then((value) {

                          value = jsonDecode(value);
                          if(value.length == 0) {
                            tempPostLikes.add(0);
                          }
                          else if(value["liked"] == false && value["disliked"] == false) {
                            tempPostLikes.add(1);
                          } else if(value["liked"] == true) {
                            tempPostLikes.add(2);
                          } else if(value["disliked"] == true) {
                            tempPostLikes.add(3);
                          }
                          if(i == posts.length-1) {
                            Future.delayed(Duration(seconds: 2), () {
                              setState(() {
                                posts=tempPosts;
                                postLikes=tempPostLikes;
                              });
                            });
                          }
                        });
                      }
                    });
                  },
                  child: const Icon(Icons.home))
              ),
              const Tab(icon: Icon(Icons.people)),
              Tab(icon: GestureDetector(
                onLongPress: () {
                  getFriends(widget.profile["id"]).then((value) {
                    setState(() {
                      friendsList = value;
                    });
                  });
                },
                child: const Icon(Icons.chat_bubble_outline_rounded))
              ),
              const Tab(icon: Icon(Icons.settings)),
            ],
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          backgroundColor: Colors.teal,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => createPost(profile: widget.profile) ) );
          },
          backgroundColor: Colors.teal,
          child: const Icon(Icons.add,
            color: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                    child: TextField(
                      controller: postController,
                      onChanged: (text) {
                        searchPost({"search": text}).then((value) {
                          if(text == "") {
                            getPosts(widget.profile["id"]).then((value) {
                              setState(() {
                                posts = jsonDecode(value);
                                // postLoading = false;
                              });
                              for(int i=0; i<posts.length; i++) {
                                print(posts[i]["id"]);
                                getPostLikes(posts[i]["id"], widget.profile["id"]).then((value) {

                                  value = jsonDecode(value);
                                  if(value.length == 0) {
                                    postLikes.add(0);
                                  }
                                  else if(value["liked"] == false && value["disliked"] == false) {
                                    postLikes.add(1);
                                  } else if(value["liked"] == true) {
                                    postLikes.add(2);
                                  } else if(value["disliked"] == true) {
                                    postLikes.add(3);
                                  }
                                  if(i == posts.length-1) {
                                    setState(() {
                                      postLoading = false;
                                    });
                                  }
                                });
                              }
                            });
                          } else {
                            setState(() {
                              posts = value;
                            });
                          }
                        });
                      },
                      decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                          hintText: "Search Posts"
                      ),
                    ),
                  ),
                  postLoading == true ? const Center(child: CircularProgressIndicator(),)
                      : posts.length == 0 ? const Center(child: Text("You have no posts"),) : Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: posts.length,
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
                                  Row(
                                    children: [
                                      // Image.network(posts[index]["owner"]["picture"]),
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(100.0),
                                          child: Image.network("$image_url${posts[index]['owner']['picture']}",
                                            width: 50.0,
                                            height: 50.0,
                                            fit: BoxFit.cover,
                                          )
                                      ),
                                      const SizedBox(width: 15.0,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(posts[index]["owner"]["user"]["username"],
                                            style: const TextStyle(
                                              color: Colors.teal,
                                              fontSize: 20.0
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(posts[index]["date_posted"].toString().substring(0, 10),
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14.0
                                                ),
                                              ),
                                              const SizedBox(width: 5.0,),
                                              Text(posts[index]["date_posted"].toString().substring(12, 16),
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14.0
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      posts[index]["owner"]["id"] == widget.profile["id"] ? Row(
                                        children: [
                                          GestureDetector(
                                            child: const Icon(Icons.edit,
                                              color: Colors.blue,
                                            ),
                                            onTap: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=> editPost(profile: widget.profile, post: posts[index]) ));
                                            },
                                          ),
                                          const SizedBox(width: 10.0,),
                                          GestureDetector(
                                            child: const Icon(Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onTap: () {
                                              deleting? const CircularProgressIndicator() : showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text("Delete Post"),
                                                    content: const Text("Are you sure you want to delete this post"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            deleting = true;
                                                          });
                                                          deletePost(posts[index]["id"]).then((value) {
                                                            getPosts(widget.profile["id"]).then((value) {
                                                              setState(() {
                                                                posts = jsonDecode(value);
                                                                deleting = false;
                                                              });
                                                              Navigator.pop(context);
                                                            });
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
                                          ),
                                        ],
                                      ) : Container(),
                                    ],
                                  ),
                                  const SizedBox(height: 15.0,),
                                  posts[index]["caption"] == null ? Container() : Text(posts[index]["caption"]),
                                  posts[index]["image"] == null ? Container() : Image.network("$image_url${posts[index]['image']}"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              print(postLikes[index]);
                                              if(postLikes[index] == 0) {
                                                addPostLikes({"profile_id": widget.profile["id"], "post_id": posts[index]["id"], "liked": true, "disliked": false});
                                                setState(() {
                                                  postLikes[index] = 2;
                                                  posts[index]["likes"] = posts[index]["likes"] + 1;
                                                });
                                                updatePost({"pk": posts[index]["id"], "likes": 1}, false);
                                              } else if(postLikes[index] == 1 || postLikes[index] == 3) {
                                                updatePostLikes(posts[index]["id"], widget.profile["id"], {"profile_id": widget.profile["id"], "post_id": posts[index]["id"], "liked": true, "disliked": false});
                                                if(postLikes[index] == 3) {
                                                  updatePost({"pk": posts[index]["id"], "likes": 1, "dislikes": 0}, false);
                                                  setState(() {
                                                    posts[index]["dislikes"] = posts[index]["dislikes"] - 1;
                                                  });
                                                } else {
                                                  updatePost({"pk": posts[index]["id"], "likes": 1}, false);
                                                }
                                                setState(() {
                                                  postLikes[index] = 2;
                                                  posts[index]["likes"] = posts[index]["likes"] + 1;
                                                });
                                              } else {
                                                updatePostLikes(posts[index]["id"], widget.profile["id"], {"profile_id": widget.profile["id"], "post_id": posts[index]["id"], "liked": false, "disliked": false});
                                                setState(() {
                                                  postLikes[index] = 1;
                                                  posts[index]["likes"] = posts[index]["likes"] - 1;
                                                });
                                                updatePost({"pk": posts[index]["id"], "likes": 0}, false);
                                              }
                                            },
                                            icon: postLikes[index] != 2 ? const Icon(Icons.thumb_up_outlined) : const Icon(Icons.thumb_up_outlined,
                                              color: Colors.teal,
                                            ),
                                          ),
                                          Text("(${posts[index]["likes"]})"),
                                        ],
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => CommentSection(profile: widget.profile, post: posts[index],)));
                                        },
                                        child: const Text("Comment")
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              print(postLikes[index]);
                                              if(postLikes[index] == 0) {
                                                addPostLikes({"profile_id": widget.profile["id"], "post_id": posts[index]["id"], "liked": false, "disliked": true});
                                                setState(() {
                                                  postLikes[index] = 3;
                                                  posts[index]["dislikes"] = posts[index]["dislikes"] + 1;
                                                });
                                                updatePost({"pk": posts[index]["id"], "dislikes": 1}, false);
                                              } else if(postLikes[index] == 1 || postLikes[index] == 2) {
                                                updatePostLikes(posts[index]["id"], widget.profile["id"], {"profile_id": widget.profile["id"], "post_id": posts[index]["id"], "liked": false, "disliked": true});
                                                if(postLikes[index] == 2) {
                                                  updatePost({"pk": posts[index]["id"], "likes": 0, "dislikes": 1}, false);
                                                  setState(() {
                                                    posts[index]["likes"] -= 1;
                                                  });
                                                } else {
                                                  updatePost({"pk": posts[index]["id"], "dislikes": 1}, false);
                                                }
                                                setState(() {
                                                  postLikes[index] = 3;
                                                  posts[index]["dislikes"] = posts[index]["dislikes"] + 1;
                                                });
                                              } else {
                                                updatePostLikes(posts[index]["id"], widget.profile["id"], {"profile_id": widget.profile["id"], "post_id": posts[index]["id"], "liked": false, "disliked": false});
                                                setState(() {
                                                  postLikes[index] = 1;
                                                  posts[index]["dislikes"] = posts[index]["dislikes"] - 1;
                                                });
                                                updatePost({"pk": posts[index]["id"], "dislikes": 0}, false);
                                              }
                                            },
                                            icon: postLikes[index] != 3 ? const Icon(Icons.thumb_down_outlined) : const Icon(Icons.thumb_down_outlined,
                                              color: Colors.teal,
                                            )
                                          ),
                                          Text("(${posts[index]["dislikes"]})"),
                                        ],
                                      )
                                    ],
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
            Container(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                    child: TextField(
                      controller: _users,
                      onChanged: (text) {
                        searchUser({"search": text}).then((value) {
                          setState(() {
                            search_results = text;
                            userList = value;
                          });

                        });

                      },
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                        hintText: "Search User"
                      ),
                    ),
                  ),
                  search_results == '' ? receives.length == 0 ? const Center(
                    child: Text("You have no pending requests"),
                  ) : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: receives.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(15.0)
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Image.network('$image_url${receives[index]["sender"]["picture"]}',
                                    width: 60.0,
                                    height: 60.0,
                                  )
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Text('${receives[index]["sender"]["user"]["username"]}',
                                        style: const TextStyle(
                                          color: Colors.teal,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold
                                        ),
                                      )
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.3,
                                          child: TextButton(
                                            onPressed: () {
                                              Map data = {"friend1_id": widget.profile["id"], "friend2_id": receives[index]["sender"]["id"], "blocked": false};
                                              acceptRequest(data).then((value) {
                                                getRequests({"pk": widget.profile["id"]}).then((value) {
                                                  setState(() {
                                                    receives = value;
                                                  });
                                                  getFriends(widget.profile["id"]).then((value) {
                                                    setState(() {
                                                      friendsList = value;
                                                    });
                                                  });
                                                });
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.teal
                                            ),
                                            child: const Text("Accept",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            )
                                          ),
                                        ),
                                        SizedBox(width: 15.0,),
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.3,
                                          child: TextButton(
                                              onPressed: () {
                                                deleteRequest(receives[index]["id"]).then((value) {
                                                  getRequests({"pk": widget.profile["id"]}).then((value) {
                                                    setState(() {
                                                      receives = value;
                                                    });
                                                  });
                                                });
                                              },
                                              style: TextButton.styleFrom(
                                                  backgroundColor: Colors.black12
                                              ),
                                              child: const Text("Reject",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              )
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    )
                  ) : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: userList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(15.0)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(userList[index]["username"]),
                              sendingRequest == false ? TextButton(
                                  onPressed: () {
                                    setState(() {
                                      sendingRequest = true;
                                    });
                                    getFriendProfile(userList[index]["id"]).then((value) {
                                      Map receiver_data = jsonDecode(value);
                                      Map data = {"sender_id" : widget.profile["id"], "receiver_id" : receiver_data["id"]};
                                      sendRequest(data).then((value) {
                                        setState(() {
                                          sendingRequest = false;
                                          userList.removeAt(index);
                                        });
                                      });
                                    });
                                  },
                                  child: Text("Send Friend Request")
                              ) : const CircularProgressIndicator(),
                            ],
                          )
                        );
                      }
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: friendsList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: Image.network('$image_url${friendsList[index]["friend_2"]["picture"]}',
                                  width: 60.0,
                                  height: 60.0,
                                  fit: BoxFit.cover,
                                )
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Text('${friendsList[index]["friend_2"]["user"]["username"]}',
                                        style: const TextStyle(
                                            color: Colors.teal,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold
                                        ),
                                      )
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width*0.3,
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => chat(profile: widget.profile, friend: friendsList[index])));
                                          },
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.blue
                                          ),
                                          child: const Text("Message",
                                            style: TextStyle(
                                              color: Colors.white
                                            ),
                                          )
                                        ),
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width*0.05,),
                                      friendsList[index]["blocked"] == false ? Container(
                                        width: MediaQuery.of(context).size.width*0.30,
                                        child: TextButton(
                                          onPressed: () {
                                            blockUser(friendsList[index]["id"],
                                                {"blocked": true}).then((value) {
                                              getFriends(widget.profile["id"]).then((value) {
                                                setState(() {
                                                  friendsList = value;
                                                });
                                              });
                                            });
                                          },
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.red
                                          ),
                                          child: const Text("Block User",
                                            style: TextStyle(
                                                color: Colors.white
                                            ),
                                          ),
                                        ),
                                      ) : Container(
                                        width: MediaQuery.of(context).size.width*0.30,
                                        child: TextButton(
                                          onPressed: () {
                                            blockUser(friendsList[index]["id"],
                                                {"blocked": false}).then((value) {
                                              getFriends(widget.profile["id"]).then((value) {
                                                setState(() {
                                                  friendsList = value;
                                                });
                                              });
                                            });
                                          },
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.black12
                                          ),
                                          child: const Text("Unblock",
                                            style: TextStyle(
                                                color: Colors.black
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),

                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 15.0,),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => GroupList(profile: widget.profile) ));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            // border: Border.all(),
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.teal,
                          ),
                          child: const Text("My Groups",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceCategories(profile: widget.profile)));
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => GroupList(profile: widget.profile) ));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            // border: Border.all(),
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.teal,
                          ),
                          child: const Text("Services",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile(profile: widget.profile,)));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            // border: Border.all(),
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.teal,
                          ),
                          child: const Text("Update Profile",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            // border: Border.all(),
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.teal,
                          ),
                          child: const Text("Logout",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ]
        )
      ),
    );
  }
}
