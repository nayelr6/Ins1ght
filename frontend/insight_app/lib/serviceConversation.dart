import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insight_app/api.dart';

class ServiceConversation extends StatefulWidget {
  ServiceConversation({Key? key, required this.customer, required this.specialist, required this.profile}) : super(key: key);
  Map customer;
  Map specialist;
  Map profile;

  @override
  State<ServiceConversation> createState() => _ServiceConversationState();
}

class _ServiceConversationState extends State<ServiceConversation> {
  TextEditingController msg = TextEditingController();
  List messages = [];
  bool updating = false;
  int updateKey = -1;
  FocusNode myFocusNode = FocusNode();
  bool deleting = false;
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConversation(widget.customer["id"], widget.specialist["id"]).then((value) {
      setState(() {
        messages = jsonDecode(value.body);
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
        title: Text(widget.customer["service"]["name"],
          style: const TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: loading ? const Center(child: CircularProgressIndicator(),) : Column(
       children: [
         messages.isEmpty ? const Expanded(child: Center(child: Text("It seems you do not have any messages"),)) :
         Expanded(child: ListView.builder(
             itemCount: messages.length,
             itemBuilder: (context, index) {
               return Container(
                 width: MediaQuery.of(context).size.width*0.95,
                 margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                 child: Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     ClipRRect(
                         borderRadius: BorderRadius.circular(100.0),
                         child: Image.network("$image_url${messages[index]['owner']['picture']}",
                           width: 50.0,
                           height: 50.0,
                           fit: BoxFit.cover,
                         )
                     ),
                     const SizedBox(width: 15.0,),
                     Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(messages[index]["owner"]["user"]["username"],
                           style: const TextStyle(
                               fontWeight: FontWeight.bold,
                               fontSize: 22.0
                           ),
                         ),
                         const SizedBox(height: 5.0,),
                         Container(
                           width: MediaQuery.of(context).size.width*0.7,
                           child: Text(messages[index]["text"])
                         ),
                         Row(
                           children: [
                             messages[index]["owner"]["id"] == widget.profile["id"] ?
                             GestureDetector(
                               onTap: () {
                                 setState(() {
                                   updating=true;
                                   msg.text=messages[index]["text"];
                                   updateKey=messages[index]["id"];
                                 });
                                 myFocusNode.requestFocus();
                               },
                               child: Container(
                                 margin: EdgeInsets.symmetric(vertical: 5.0),
                                 child: const Text("Edit",
                                   style: TextStyle(
                                       color: Colors.blue
                                   ),
                                 ),
                               ),
                             ) : Container(),
                             messages[index]["owner"]["id"] == widget.profile["id"] ? const SizedBox(width: 10.0,) : Container(),
                             messages[index]["owner"]["id"] == widget.profile["id"] ?
                             GestureDetector(
                               onTap: () {
                                 deleting ? const CircularProgressIndicator() : showDialog(
                                     context: context,
                                     builder: (context) {
                                       return AlertDialog(
                                         title: const Text("Delete Message"),
                                         content: const Text("Are you sure you want to delete this message"),
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
                                                 deleteConversation(messages[index]["id"]).then((value) {
                                                   setState(() {
                                                     messages.removeAt(index);
                                                     deleting = false;
                                                   });
                                                   Navigator.pop(context);
                                                 });
                                               },
                                               child: const Text("Yes")
                                           ),
                                           TextButton(
                                               onPressed: () {
                                                 Navigator.pop(context);
                                               },
                                               child: const Text("Cancel")
                                           )
                                         ],
                                       );
                                     }
                                 );
                               },
                               child: Container(
                                 margin: EdgeInsets.symmetric(vertical: 5.0),
                                 child: const Text("Delete",
                                   style: TextStyle(
                                       color: Colors.red
                                   ),
                                 ),
                               ),
                             ) : Container(),
                           ],
                         )

                       ],
                     )
                   ],
                 ),
               );
             }
         )),
         Row(
           children: [
             Container(
               height: 60.0,
               margin: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
               width: MediaQuery.of(context).size.width*0.8,
               child: TextField(
                 controller: msg,
                 focusNode: myFocusNode,
                 decoration: const InputDecoration(
                     border: OutlineInputBorder(),
                     // labelText: "Username",
                     labelText: "Add Message"
                 ),
               ),
             ),
             IconButton(
                 onPressed: () {
                   if(updating == false) {
                     if(msg.text.isNotEmpty) {
                       // postMessages({"owner_id": widget.profile["id"], "recipient_id": widget.friend["friend_2"]["id"], "content": msg.text, "image": _image!.path}).then((value) {
                       //   getMessages(widget.profile["id"], widget.friend["friend_2"]["id"]).then((value) {
                       //     setState(() {
                       //       messages = jsonDecode(value);
                       //       updating = false;
                       //     });
                       //   });
                       //   msg.clear();
                       //   FocusScope.of(context).unfocus();
                       // });
                       postConversation({"customer_id": widget.customer["id"], "specialist_id": widget.specialist["id"], "owner_id": widget.profile["id"], "text": msg.text}).then((value) {
                         getConversation(widget.customer["id"], widget.specialist["id"]).then((value) {
                           setState(() {
                             messages = jsonDecode(value.body);
                           });
                         });
                         msg.clear();
                         FocusScope.of(context).unfocus();
                       });
                     }
                   } else {
                     if(msg.text.isNotEmpty) {
                       updateConversation(updateKey, {"text": msg.text}).then((value) {
                         getConversation(widget.customer["id"], widget.specialist["id"]).then((value) {
                           setState(() {
                             messages = jsonDecode(value.body);
                             updating = false;
                             updateKey = -1;
                           });
                         });
                       });
                       msg.clear();
                       FocusScope.of(context).unfocus();
                     }
                   }

                 },
                 icon: const Icon(Icons.send)
             ),
           ],
         ),
       ],
      ),
    );
  }
}
