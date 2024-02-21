import 'dart:convert';

import 'package:flutter/material.dart';
import 'signIn.dart';
import 'addPicture.dart';
import 'api.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password1 = TextEditingController();
  final _password2 = TextEditingController();
  bool hidepass1 = true;
  bool hidepass2 = true;
  Map errors = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100,),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: TextField(
                controller: _username,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    // labelText: "Username",
                    labelText: "Username"
                ),
              ),
            ),
            SizedBox(height: 5.0,),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: TextField(
                controller: _email,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email"
                ),
              ),
            ),
            SizedBox(height: 5.0,),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: TextField(
                controller: _password1,
                obscureText: hidepass1,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hidepass1 = !hidepass1;
                          });
                        },
                        icon: Icon(Icons.remove_red_eye_rounded))
                ),
              ),
            ),
            SizedBox(height: 5.0,),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: TextField(
                controller: _password2,
                obscureText: hidepass2,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Confirm Password",
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hidepass2 = !hidepass2;
                          });
                        },
                        icon: Icon(Icons.remove_red_eye_rounded))
                ),
              ),
            ),

            const SizedBox(height: 20.0,),
            errors.isNotEmpty ? Text(errors["error"],
              style: TextStyle(color: Colors.red),
            ) : Container(),
            TextButton(
              onPressed: () {
                register({"username": _username.text, "email": _email.text, "password1": _password1.text, "password2": _password2.text}).then((value) {
                  Map data = jsonDecode(value.body);
                  if(data.containsKey("error")) {
                    setState(() {
                      errors = data;
                    });
                  } else {
                      Map<String, dynamic> user = jsonDecode(value.body);
                      createProfile({"user_id": user["id"]}).then((value) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => addPicture(user: jsonDecode(value))));
                      });
                  }
                  // if(value.statusCode == 200) {
                  // } else {
                  //   Map error = jsonDecode(value.body);
                  //   setState(() {
                  //     errors = error["error"];
                  //   });
                  //   print(error);
                  // }

                });
              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.teal,
                  fixedSize: Size(200.0, 20.0)
              ),
              child: const Text("Sign Up",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0
                ),
              ),
            ),
            const SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account? ",
                  style: TextStyle(
                      fontSize: 15.0
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    //push to registration

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));

                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.teal
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
