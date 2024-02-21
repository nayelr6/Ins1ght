import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insight_app/functions.dart';
import 'api.dart';

class createPost extends StatefulWidget {
  const createPost({Key? key, required this.profile}) : super(key: key);
  final Map<String, dynamic> profile;

  @override
  State<createPost> createState() => _createPostState();
}

class _createPostState extends State<createPost> {
  final _caption = TextEditingController();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text("Add Post",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.15),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: TextField(
                controller: _caption,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    // labelText: "Username",
                    labelText: "Caption"
                ),
              ),
            ),
            const SizedBox(height: 10.0,),
            _image == null ? TextButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text("Gallery"),
                                leading: Icon(Icons.photo),
                                onTap: () async {
                                  var currentImage = await getImage(ImageSource.gallery);
                                  setState(() {
                                    _image = File(currentImage);
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
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }
                  );
                },
                child: const Text("Pick image")
            ) : GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text("Gallery"),
                            leading: const Icon(Icons.photo),
                            onTap: () async {
                              var currentImage = await getImage(ImageSource.gallery);
                              setState(() {
                                _image = File(currentImage);
                              });
                            },
                          ),
                          ListTile(
                            title: const Text("Camera"),
                            leading: const Icon(Icons.camera_alt),
                            onTap: () async {
                              var currentImage = await getImage(ImageSource.camera);
                              setState(() {
                                _image = File(currentImage);
                              });
                            },
                          ),
                        ],
                      );
                    }
                );
              },
              child: Image.file(File(_image!.path).absolute,
                // height: 100.0,
                width: MediaQuery.of(context).size.width*0.4,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 25.0,),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.teal
              ),
              onPressed: () {
                if(_image == null) {
                  addPost({"owner_id": widget.profile["id"], "caption": _caption.text, "image": null}).then((value) {
                    Navigator.pop(context);
                  });
                } else {
                  addPost({"owner_id": widget.profile["id"], "caption": _caption.text, "image": _image!.path}).then((value) {
                    Navigator.pop(context);
                  });
                }
              },
              child: const Text("Add Post",
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
