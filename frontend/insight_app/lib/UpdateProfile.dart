import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:insight_app/home.dart';

import 'functions.dart';
import 'package:flutter/material.dart';
import 'api.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key, required this.profile}) : super(key: key);
  final Map<String, dynamic> profile;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  File? _image;
  bool userupdate = false;
  bool imageupdate = false;

  @override
  void initState() {
    super.initState();
    _username.text = widget.profile["user"]["username"];
    _email.text = widget.profile["user"]["email"];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        title: const Text("Update Profile",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          const SizedBox(height: 15.0,),
          _image == null ? GestureDetector(

            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text("Gallery"),
                        leading: Icon(Icons.photo),
                        onTap: () async {
                          var currentImage = await getImage(ImageSource.gallery);
                          setState(() {
                            _image = File(currentImage);
                            imageupdate = true;
                          });
                        },
                      ),
                      ListTile(
                        title: Text("Camera"),
                        leading: Icon(Icons.camera_alt),
                        onTap: () async {
                          var currentImage = await getImage(ImageSource.camera);
                          setState(() {
                            _image = File(currentImage);
                            imageupdate = true;
                          });
                        },
                      ),
                    ],
                  );
                }
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.network('$image_url${widget.profile["picture"]}',
                width: 100.0,
                height: 100.0,
              )
            ),
          ) : GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text("Gallery"),
                          leading: Icon(Icons.photo),
                          onTap: () async {
                            var currentImage = await getImage(ImageSource.gallery);
                            setState(() {
                              _image = File(currentImage);
                              imageupdate = true;
                            });
                          },
                        ),
                        ListTile(
                          title: Text("Camera"),
                          leading: Icon(Icons.camera_alt),
                          onTap: () async {
                            var currentImage = await getImage(ImageSource.camera);
                            setState(() {
                              _image = File(currentImage);
                              imageupdate = true;
                            });
                          },
                        ),
                      ],
                    );
                  }
              );
            },
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Image.file(File(_image!.path).absolute,
                  height: 100.0,
                  width: 100.0,
                  fit: BoxFit.cover,
                )
            ),
          ),
          const SizedBox(height: 5.0,),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: TextField(
              controller: _username,
              onTap: () {
                setState(() {
                  userupdate = true;
                });
                print("Done");
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  // labelText: "Username",
                  labelText: "Username"
              ),
            ),
          ),
          const SizedBox(height: 5.0,),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: TextField(
              controller: _email,
              onTap: () {
                setState(() {
                  userupdate = true;
                });
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email"
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              //update profile
              if(userupdate == true && imageupdate==true) {
                updateUser(widget.profile["user"]["id"], {"username": _username.text, "email": _email.text}).then((value) {
                  updateProfile(_image, widget.profile).then((value) {
                    getProfile(widget.profile["id"]).then((value) {
                      Map<String, dynamic> user_profile = jsonDecode(value);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home(profile: user_profile)), (route) => false);
                    });
                  });
                });
              }
              else if(userupdate == true) {
                // print(widget.profile["user"]["id"]);
                updateUser(widget.profile["user"]["id"], {"username": _username.text, "email": _email.text}).then((value) {
                  getProfile(widget.profile["id"]).then((value) {
                    Map<String, dynamic> user_profile = jsonDecode(value);
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home(profile: user_profile)), (route) => false);
                  });
                });
              }
              else if(imageupdate == true) {
                updateProfile(_image, widget.profile).then((value) {
                  getProfile(widget.profile["id"]).then((value) {
                    Map<String, dynamic> user_profile = jsonDecode(value);
                    print(user_profile);
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home(profile: user_profile)), (route) => false);
                  });
                });
              }
              else {
                Navigator.pop(context);
              }
            },
            child: const Text("Update")
          )
        ],
      ),
    );
  }
}
