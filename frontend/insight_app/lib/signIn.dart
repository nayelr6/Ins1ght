import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';
import 'signUp.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  Map errors = {};
  bool hidepass = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print(errors);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In",
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
            SizedBox(height: 150,),
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
                controller: _password,
                obscureText: hidepass,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidepass = !hidepass;
                        });
                      },
                      icon: Icon(Icons.remove_red_eye_rounded))
                ),
              ),
            ),
            const SizedBox(height: 20.0,),
            errors.isNotEmpty ? Text(errors["non_field_errors"][0],
              style: const TextStyle(color: Colors.red),
            ) : Container(),
            isLoading ? const CircularProgressIndicator() : TextButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                login({"username": _username.text, "password": _password.text}).then((value) {
                  print(value.statusCode);
                  if(value.statusCode == 200) {
                    getProfileFromToken(jsonDecode(value.body)).then((value) {
                      print(value);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home(profile: jsonDecode(value),)));
                    });
                  } else {
                    setState(() {
                      isLoading = false;
                      errors = jsonDecode(value.body);
                    });
                  }

                });
                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.teal,
                  fixedSize: Size(200.0, 20.0)
              ),
              child: const Text("Login",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(
                      fontSize: 15.0
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    //push to registration
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUp()));
                  },
                  child: const Text(
                    "Sign up",
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