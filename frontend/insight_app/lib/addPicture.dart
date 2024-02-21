import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:insight_app/home.dart';

import 'functions.dart';
import 'package:flutter/material.dart';
import 'api.dart';

class addPicture extends StatefulWidget {
  addPicture({Key? key, required this.user}) : super(key: key);
  final Map<String, dynamic> user;

  @override
  State<addPicture> createState() => _addPictureState();
}

class _addPictureState extends State<addPicture> {
  File? _image;
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
      child: uploading == false ? Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: GestureDetector(
          onTap: () {
            getProfile(widget.user["id"]).then((value) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(profile: jsonDecode(value),)));
            });
            },
          child: const Text("Skip For Now",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20.0
            ),
          ),
        )

    ) : Container(),
      ),
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50.0,),
              _image == null ? GestureDetector(
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
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Image.network('${widget.user["picture"]}',
                      width: 150.0,
                      height: 150.0,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                       if(loadingProgress == null) {
                         return child;
                       } else {
                         return const CircularProgressIndicator();
                       }
                      },
                    )
                ),
              ) : GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SingleChildScrollView(
                          child: Column(
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
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Image.file(File(_image!.path).absolute,
                      height: 150.0,
                      width: 150.0,
                      fit: BoxFit.cover,
                    )
                ),
              ),

              const SizedBox(height: 30.0,),
              TextButton(
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
              ),
              _image == null ? Container() : uploading == false ? TextButton(
                  onPressed: () {
                    setState(() {
                      uploading = true;
                    });
                    updateProfile(_image, widget.user).then((value) {
                      getProfile(widget.user["id"]).then((value) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(profile: jsonDecode(value),)));
                      });
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.teal
                  ),
                  child: const Text("Update Profile",
                    style: TextStyle(
                      color: Colors.white
                    ),
                  )
              ) : CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
