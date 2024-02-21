import 'package:insight_app/UpdateProfile.dart';

class User {
  int id;
  String username;
  String email;

  User({
    required this.id,
    required this.username,
    required this.email
  });

  User.fromJson(Map<String, dynamic> json):
    id = json['id'],
    username = json['username'],
    email = json['email'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    return data;
  }
}

class Profile {
  int id;
  String? picture;
  User user;
  String userId;

  Profile({required this.id, this.picture, required this.user, required this.userId});

  Profile.fromJson(Map<String, dynamic> json):
    id = json['id'],
    picture = json['picture'],
    user = User.fromJson(json['user']),
    userId = json['user_id'];


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.picture != null) {
      data['picture'] = this.picture;
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['user_id'] = this.userId;
    return data;
  }
}

class Request {
  int id;
  Profile sender;
  Profile receiver;
  String senderId;
  String receiverId;

  Request(
      {required this.id, required this.sender, required this.receiver, required this.senderId, required this.receiverId});

  Request.fromJson(Map<String, dynamic> json):
    id = json['id'],
    sender = Profile.fromJson(json['sender']),
    receiver = Profile.fromJson(json['receiver']),
    senderId = json['sender_id'],
    receiverId = json['receiver_id'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.sender != null) {
      data['sender'] = this.sender.toJson();
    }
    if (this.receiver != null) {
      data['receiver'] = this.receiver.toJson();
    }
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    return data;
  }
}

class Friend {
  int id;
  Profile friend1;
  Profile friend2;
  bool blocked;
  String friend1Id;
  String friend2Id;

  Friend(
      {required this.id,
       required this.friend1,
       required this.friend2,
       required this.blocked,
       required this.friend1Id,
       required this.friend2Id});

  Friend.fromJson(Map<String, dynamic> json):
    id = json['id'],
    friend1 = Profile.fromJson(json['friend_1']),
    friend2 = Profile.fromJson(json['friend_2']),
    blocked = json['blocked'],
    friend1Id = json['friend1_id'],
    friend2Id = json['friend2_id'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.friend1 != null) {
      data['friend_1'] = this.friend1.toJson();
    }
    if (this.friend2 != null) {
      data['friend_2'] = this.friend2.toJson();
    }
    data['blocked'] = this.blocked;
    data['friend1_id'] = this.friend1Id;
    data['friend2_id'] = this.friend2Id;
    return data;
  }
}