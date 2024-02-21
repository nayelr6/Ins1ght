import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insight_app/functions.dart';
import 'api.dart';

class editPost extends StatefulWidget {
  const editPost({Key? key, required this.profile, required this.post}) : super(key: key);
  final Map<String, dynamic> profile;
  final Map<String, dynamic> post;

  @override
  State<editPost> createState() => _editPostState();
}

class _editPostState extends State<editPost> {
  final _caption = TextEditingController();
  File? _image;
  String imageUrl = "";
  bool imageUpdated = false;

  @override
  void initState() {
    if(widget.post["caption"] != null) {
      _caption.text = widget.post["caption"];
    }
    if(widget.post["image"] != null) {
      imageUrl = "$image_url${widget.post["image"]}";
    }

  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text("Edit Post",
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
            imageUrl != "" ? GestureDetector(
              onTap: () {
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
                                  imageUpdated = true;
                                  imageUrl = "";
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
                                  imageUpdated = true;
                                  imageUrl = "";
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }
                );
              },
              child: Image.network(imageUrl,
                width: MediaQuery.of(context).size.width*0.4,
                fit: BoxFit.cover,
              ),
            ) : _image == null ? TextButton(
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
                                    imageUpdated = true;
                                    imageUrl = "";
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
                                    imageUpdated = true;
                                    imageUrl = "";
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
                                imageUpdated = true;
                                imageUrl = "";
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
                                imageUpdated = true;
                                imageUrl = "";
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
                  if(imageUpdated == false) {
                    // addPost({"owner_id": widget.profile["id"], "caption": _caption.text, "image": null}).then((value) {
                    //   Navigator.pop(context);
                    // });
                    updatePost({"owner_id": widget.profile["id"], "caption": _caption.text, "pk": widget.post["id"]}, imageUpdated).then((value) {
                      Navigator.pop(context);
                    });
                  } else {
                    // addPost({"owner_id": widget.profile["id"], "caption": _caption.text, "image": _image!.path}).then((value) {
                    //   Navigator.pop(context);
                    // });
                    updatePost({"owner_id": widget.profile["id"], "caption": _caption.text, "image": _image!.path, "pk": widget.post["id"]}, imageUpdated).then((value) {
                      Navigator.pop(context);
                    });
                  }
                },
                child: const Text("Update Post",
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
