import 'dart:convert';
import 'dart:io';
import 'models.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

final base_url = 'http://192.168.89.181:8000/';
final image_url = 'http://192.168.89.181:8000';

Future<void> uploadImage(String url, String field, File? image, String req) async {

  var uri = Uri.parse(url);

  var request = http.MultipartRequest(req, uri);

  var multipartfile = await http.MultipartFile.fromPath('picture', image!.path);

  request.files.add(multipartfile);
  var response = await request.send();
}

Future login(Map<String, dynamic> data) async {
  String url = base_url + "api-token-auth/";
  try {
    Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    print(response.statusCode);
    if(response.statusCode == 200) {
      return response;
    } else {
      return response;
    }

  } catch(e) {
    print(e);
  }
}

Future register(Map<String, dynamic> data) async {
  String url = base_url + 'register/';
  try {
    Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200) {
      return response;
    } else {
      return response;
    }

  } catch(e) {
    print(e);
  }
}

Future updateUser(int pk, Map<String, dynamic> data) async {
  String url = base_url + 'api/users/?pk=$pk';
  try {
    Response response = await http.put(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred in update user");
    }

  } catch(e) {
    print(e);
  }
}

Future createProfile(Map<String, dynamic> data) async {
  String url = base_url + 'api/profile/';
  try {
    Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 201) {
      return response.body;
    } else {
      print("An error occurred in profile creation");
    }

  } catch(e) {
    print(e);
  }
}

Future updateProfile(File? image, Map<String, dynamic> data) async {
  String url = base_url + 'api/profile/?pk=${data["id"]}';
  try {
    uploadImage(url, 'picture', image, "PUT");
  } catch(e) {
    print(e);
  }
}

Future getProfile(int id) async {
  String url = base_url + 'api/profile/?pk=$id';
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}


Future getProfileFromToken(Map data) async {
  String url = base_url + 'api/get_profile?token=${data['token']}';
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future searchUser(Map data) async {
  String url = base_url + 'api/users/?search=${data["search"]}';
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future getRequests(Map<String, dynamic> data) async {
  String url = base_url + 'api/requests/?pid=${data['pk']}';
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future sendRequest(Map data) async {
  String url = base_url + 'api/requests/';
  try {
    Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    print(response.statusCode);
    if(response.statusCode == 201) {
      return response.body;
    } else {
      print("An error occurred in sending request");
    }
  } catch(e) {
    print(e);
  }
}

Future getFriendProfile(int userId) async {
  String url = base_url + 'api/friend_profile/?user_id=$userId';
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred in getting profile");
    }
  } catch(e) {
    print(e);
  }
}

Future acceptRequest(Map data) async {
  String url = base_url + 'api/friends/';
  try {
    Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    print(response.statusCode);
    if(response.statusCode == 201) {
      return response.body;
    } else {
      print("An error occurred in accepting request");
    }
  } catch(e) {
    print(e);
  }
}

Future deleteRequest(int pk) async {
  String url = base_url + 'api/requests/?pk=$pk';
  try {
    // Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    Response response = await http.delete(Uri.parse(url));
    print(response.statusCode);
    // if(response.statusCode == 201) {
    //   return response.body;
    // } else {
    //   print("An error occurred in accepting request");
    // }
  } catch(e) {
    print(e);
  }
}

Future getFriends(int pid) async {
  String url = base_url + "api/friends/?pid=$pid";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future blockUser(int pk, Map data) async {
  String url = base_url + "api/friends/?pk=$pk";
  try {
    Response response = await http.put(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred in update user");
    }
  } catch(e) {
    print(e);
  }
}

Future getPosts(int pid) async {
  String url = base_url + "api/posts/?pid=$pid";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future addPost(Map data) async {
  String url = base_url + "api/posts/";
  print(data["image"]);
  if(data["image"] == null) {
    try {
      Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
      // print(response.statusCode);
      if(response.statusCode == 201) {
        return response.body;
      } else {
        print("An error occurred in accepting request");
      }
    } catch(e) {
      print(e);
    }
  } else {

    var uri = Uri.parse(url);

    var request = http.MultipartRequest('post', uri);

    var multipartfile = await http.MultipartFile.fromPath('image', data['image']);

    request.files.add(multipartfile);

    request.fields['owner_id'] = data["owner_id"].toString();
    if(data['caption'] != '') {
      request.fields['caption'] = data['caption'];
    }
    var response = await request.send();
  }
}

Future updatePost(Map data, bool imageUpdated) async {
  String url = base_url + "api/posts/?pk=${data["pk"]}";
  if(imageUpdated == false) {
    try {
      Response response = await http.put(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
      if(response.statusCode == 200) {
        return response.body;
      } else {
        print("An error occurred in accepting request");
      }
    } catch(e) {
      print(e);
    }
  } else {
    var uri = Uri.parse(url);

    var request = http.MultipartRequest('PUT', uri);

    var multipartfile = await http.MultipartFile.fromPath('image', data['image']);

    request.files.add(multipartfile);

    request.fields['owner_id'] = data["owner_id"].toString();
    if(data['caption'] != '') {
      request.fields['caption'] = data['caption'];
    }
    var response = await request.send();
  }
}

Future deletePost(int pk) async {
  String url = base_url + "api/posts/?pk=$pk";
  try {
    // Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    Response response = await http.delete(Uri.parse(url));
    print(response.statusCode);
  } catch(e) {
    print(e);
  }
}

Future getComments(int pid) async {
  String url = base_url + "api/comments/?pid=$pid";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future addComment(Map<String, dynamic> data) async {
  String url = base_url + 'api/comments/';
  try {
    Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 201) {
      return response;
    } else {
      return response;
    }

  } catch(e) {
    print(e);
  }
}

Future updateComment(int pk, Map<String, dynamic> data) async {
  String url = base_url + 'api/comments/?pk=$pk';
  try {
    Response response = await http.put(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred in updating comment");
    }

  } catch(e) {
    print(e);
  }
}

Future deleteComment(int pk) async {
  String url = base_url + 'api/comments/?pk=$pk';
  try {
    Response response = await http.delete(Uri.parse(url), headers: {'content-type': "application/json"});
    return response;

  } catch(e) {
    print(e);
  }
}

Future getMessages(int oid, int rid) async {
  String url = base_url + 'api/message/?oid=$oid&rid=$rid';
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future postMessages(Map data) async {
  String url = base_url + "api/message/";
  if(data["image"] == null) {
    try {
      Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
      // print(response.statusCode);
      if(response.statusCode == 201) {
        return response.body;
      } else {
        print("An error occurred in accepting request");
      }
    } catch(e) {
      print(e);
    }
  } else {

    var uri = Uri.parse(url);

    var request = http.MultipartRequest('post', uri);

    var multipartfile = await http.MultipartFile.fromPath('image', data['image']);

    request.files.add(multipartfile);

    request.fields['owner_id'] = data["owner_id"].toString();
    request.fields['recipient_id'] = data["recipient_id"].toString();
    request.fields['content'] = data["content"].toString();

    var response = await request.send();
  }
}

Future updateMessage(int pk, Map<String, dynamic> data) async {
  String url = base_url + 'api/message/$pk/';
  try {
    Response response = await http.put(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred in updating comment");
    }

  } catch(e) {
    print(e);
  }
}

Future deleteMessage(int pk) async {
  String url = base_url + 'api/message/$pk/';
  try {
    Response response = await http.delete(Uri.parse(url), headers: {'content-type': "application/json"});
    return response;

  } catch(e) {
    print(e);
  }
}

Future getPostLikes(int pid, int uid) async {
  String url = base_url + "api/postlikes/?pid=$pid&uid=$uid";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future addPostLikes(Map data) async {
  String url = base_url + "api/postlikes/";
  try {
    Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 201) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future updatePostLikes(int pid, int uid, Map<String, dynamic> data) async {
  String url = base_url + 'api/postlikes/?pid=$pid&uid=$uid';
  try {
    Response response = await http.put(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred in updating post like");
    }

  } catch(e) {
    print(e);
  }
}

Future getCommentLikes(int cid, int uid) async {
  String url = base_url + "api/commentlikes/?cid=$cid&uid=$uid";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future addCommentLikes(Map data) async {
  String url = base_url + "api/commentlikes/";
  try {
    Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 201) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future updateCommentLikes(int cid, int uid, Map data) async {
  String url = base_url + "api/commentlikes/?cid=$cid&uid=$uid";
  try {
    Response response = await http.put(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future getSingleFriend(int pid, int fid) async {
  String url = base_url + "api/friends/?pid=$pid&fid=$fid";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

// Future searchPosts(Map data) async {
//   String url = base_url + 'api/post/?search=${data["search"]}';
//   try {
//     Response response = await http.get(Uri.parse(url));
//     if(response.statusCode == 200) {
//       final body = jsonDecode(response.body);
//       return body;
//     } else {
//       print("An error occurred");
//     }
//   } catch(e) {
//     print(e);
//   }
// }

Future searchComments(int pid, String search) async {
  String url = base_url + "api/comments/?pid=$pid&search=$search";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future searchPost(Map data) async {
  String url = base_url + 'api/posts/?search=${data["search"]}';
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future getGroups(int pid) async {
  String url = base_url + "api/groupmember/?pid=$pid";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future createGroup(Map data) async {
  String url = base_url + 'api/groups/';
  try {
    Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 201) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future updateGroup(int pk, Map data) async {
  String url = base_url + 'api/groups/?pk=$pk';
  try {
    Response response = await http.put(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future getGroupMember(int pk) async {
  String url = base_url + "api/groupmember/?pk=$pk";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future closeGroup(int pk) async {
  String url = base_url + 'api/groups/?pk=$pk';
  try {
    Response response = await http.delete(Uri.parse(url), headers: {'content-type': "application/json"});
    return response;
  } catch(e) {
    print(e);
  }
}

Future searchForGroups(String info) async {
  String url = base_url + 'api/groups/?search=$info';
  try {
    Response response = await http.get(Uri.parse(url), headers: {'content-type': "application/json"});
    return response;
  } catch(e) {
    print(e);
  }
}

Future sendGroupRequest(Map data) async {
  String url = base_url + 'api/grouprequest/';
  try {
    Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 201) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future leaveGroup(int pk) async {
  String url = base_url + "api/groupmember/?pk=$pk";
  try {
    Response response = await http.delete(Uri.parse(url), headers: {'content-type': "application/json"});
    return response;
  } catch(e) {
    print(e);
  }
}

Future getGroupRequests(int gid) async {
  String url = base_url + "api/grouprequest/?gid=$gid";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future createGroupMember(Map data) async {
  String url = base_url + "api/groupmember/";
  try {
    Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 201) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future deleteGroupRequest(int pk) async {
  String url = base_url + 'api/grouprequest/?pk=$pk';
  try {
    Response response = await http.delete(Uri.parse(url));
    return response;
  } catch(e) {
    print(e);
  }
}

Future removeMembers(int pk) async {
  String url = base_url + 'api/groupmember/?pk=$pk';
  try {
    Response response = await http.delete(Uri.parse(url));
    return response;
  } catch(e) {
    print(e);
  }
}

Future getMembersByGroup(int gid) async {
  String url = base_url + 'api/groupmember/?gid=$gid';
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future updateRank(int pk, Map data) async {
  String url = base_url + 'api/groupmember/?pk=$pk';
  try {
    Response response = await http.put(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future searchForGroupMembers(int gid, String search) async {
  String url = base_url + 'api/searchformembers/?gid=$gid&search=$search';
  try {
    Response response = await http.get(Uri.parse(url), headers: {'content-type': "application/json"});
    if(response.statusCode == 200) {
      return response;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future createRoom(Map data) async {
  String url = base_url + 'api/group_room/';
  try {
    Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 201) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future getRooms(int gid, int uid) async {
  String url = base_url + "api/group_room/?gid=$gid&uid=$uid";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future getRoomMember(int mid) async {
  String url = base_url + "api/room_member/?mid=$mid";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future searchRoomMembers(int rid, int gid, String search) async {
  String url = base_url + "api/searchforroommembers/?rid=$rid&gid=$gid&search=$search";
  try {
    Response response = await http.get(Uri.parse(url), headers: {'content-type': "application/json"});
    if(response.statusCode == 200) {
      return response;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future createRoomMember(Map data) async {
  String url = base_url + "api/room_member/";
  try {
    Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 201) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future getSpecificGroupMember(int user_id, int gid) async {
  String url = base_url + "api/getgroupmember/?user_id=$user_id&gid=$gid";
  try {
    Response response = await http.get(Uri.parse(url), headers: {'content-type': "application/json"});
    if(response.statusCode == 200) {
      return response;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future getRoomMembers(int rid) async {
  String url = base_url + "api/room_member/?rid=$rid";
  try {
    Response response = await http.get(Uri.parse(url), headers: {'content-type': "application/json"});
    if(response.statusCode == 200) {
      return response;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future postRoomMessages(Map data) async {
  String url = base_url + "api/room_message/";
  if(data["image"] == null) {
    try {
      Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
      // print(response.statusCode);
      if(response.statusCode == 201) {
        return response.body;
      } else {
        print("An error occurred in accepting request");
      }
    } catch(e) {
      print(e);
    }
  } else {

    var uri = Uri.parse(url);

    var request = http.MultipartRequest('post', uri);

    var multipartfile = await http.MultipartFile.fromPath('image', data['image']);

    request.files.add(multipartfile);

    request.fields['owner_id'] = data["owner_id"].toString();
    request.fields['room_id'] = data["room_id"].toString();
    request.fields['content'] = data["content"].toString();

    var response = await request.send();
  }
}

Future getRoomMessages(int rid) async {
  String url = base_url + 'api/room_message/?rid=$rid';
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future updateRoomMessage(int pk, Map<String, dynamic> data) async {
  String url = base_url + 'api/room_message/?pk=$pk';
  try {
    Response response = await http.put(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred in updating comment");
    }

  } catch(e) {
    print(e);
  }
}

Future deleteRoomMessage(int pk) async {
  String url = base_url + 'api/room_message/?pk=$pk';
  try {
    Response response = await http.delete(Uri.parse(url), headers: {'content-type': "application/json"});
    return response;

  } catch(e) {
    print(e);
  }
}

Future deleteRoom(int pk) async {
  String url = base_url + 'api/group_room/?pk=$pk';
  try {
    Response response = await http.delete(Uri.parse(url), headers: {'content-type': "application/json"});
    return response;

  } catch(e) {
    print(e);
  }
}

Future getMessagesbyGroup(int gid) async {
  String url = base_url + "api/groupmessagelist/$gid/";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future createGroupMessage(Map data) async {
  String url = base_url + "api/groupmessage/1/";
  if(data["image"] == null) {
    try {
      Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
      // print(response.statusCode);
      if(response.statusCode == 201) {
        return response.body;
      } else {
        print("An error occurred in accepting request");
      }
    } catch(e) {
      print(e);
    }
  } else {

    var uri = Uri.parse(url);

    var request = http.MultipartRequest('post', uri);

    var multipartfile = await http.MultipartFile.fromPath('image', data['image']);

    request.files.add(multipartfile);

    request.fields['owner_id'] = data["owner_id"].toString();
    request.fields['group_id'] = data["group_id"].toString();
    request.fields['content'] = data["content"].toString();

    var response = await request.send();
  }
}

Future updateGroupMessage(int pk, Map data) async {
  String url = base_url + "api/groupmessage/$pk/";
  try {
    Response response = await http.patch(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred in updating comment");
    }

  } catch(e) {
    print(e);
  }
}

Future deleteGroupMessage(int pk) async {
  String url = base_url + "api/groupmessage/$pk/";
  try {
    Response response = await http.delete(Uri.parse(url), headers: {'content-type': "application/json"});
    return response;

  } catch(e) {
    print(e);
  }
}

Future createPoll(Map data) async {
  String url = base_url + "api/polls/";
  try {
    Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 201) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future createChoice(Map data) async {
  String url = base_url + "api/choices/";
  try {
    Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 201) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future getPoll(int gid) async {
  String url = base_url + "api/polls/?gid=$gid";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future getChoices(int qid) async {
  String url = base_url + "api/choices/?qid=$qid";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future updatePoll(int pk, Map data) async {
  String url = base_url + "api/polls/?pk=$pk";
  try {
    Response response = await http.put(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred in updating comment");
    }

  } catch(e) {
    print(e);
  }
}

Future deletePoll(int pk) async {
  String url = base_url + "api/polls/?pk=$pk";
  try {
    Response response = await http.delete(Uri.parse(url), headers: {'content-type': "application/json"});
    return response;

  } catch(e) {
    print(e);
  }
}

Future getPollRecord(int oid, int gid) async {
  String url = base_url + "api/choicerecord/?gid=$gid&oid=$oid";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response;
    } else {
      return response;
    }
  } catch(e) {
    print(e);
  }
}

Future postPollRecord(Map data) async {
  String url = base_url + "api/choicerecord/";
  try {
    Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 201) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future updateChoice(int pk, Map data) async {
  String url = base_url + "api/choices/?pk=$pk";
  try {
    Response response = await http.put(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred in updating comment");
    }
  } catch(e) {
    print(e);
  }
}

Future getService(String op) async {
  String url = base_url + "api/services/?op=$op";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response;
    } else {
      return response;
    }
  } catch(e) {
    print(e);
  }
}

Future getOwnedService(int pid, String op) async {
  String url = base_url + "api/services/?pid=$pid&op=$op";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response;
    } else {
      return response;
    }
  } catch(e) {
    print(e);
  }
}

Future postService(Map data) async {
  String url = base_url + "api/services/";
  try {
    Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    print(data);
    if(response.statusCode == 201) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future updateService(int pk, Map data) async {
  String url = base_url + "api/services/?pk=$pk";
  try {
    Response response = await http.put(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred in updating comment");
    }
  } catch(e) {
    print(e);
  }
}

Future createServiceRequest(Map data) async {
  String url = base_url + "api/servicerequests/";
  try {
    Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 201) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future getServiceRequests(int sid) async {
  String url = base_url + "api/servicerequests/?sid=$sid";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response;
    } else {
      return response;
    }
  } catch(e) {
    print(e);
  }
}

Future deleteServiceRequest(int pk) async {
  String url = base_url + "api/servicerequests/?pk=$pk";
  try {
    Response response = await http.delete(Uri.parse(url), headers: {'content-type': "application/json"});
    return response;

  } catch(e) {
    print(e);
  }
}

Future searchSpecialists(int sid, Map data) async {
  String url = base_url + 'api/searchSpecialists/?sid=$sid&search=${data["search"]}';
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future addSpecialists(Map data) async {
  String url = base_url + "api/specialists/";
  try {
    Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 201) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future deleteSpecialist(int pk) async {
  String url = base_url + "api/specialists/?pk=$pk";
  try {
    Response response = await http.delete(Uri.parse(url), headers: {'content-type': "application/json"});
    return response;

  } catch(e) {
    print(e);
  }
}

Future getSpecialists(int sid) async {
  String url = base_url + "api/specialists/?sid=$sid";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response;
    } else {
      return response;
    }
  } catch(e) {
    print(e);
  }
}

Future getSpecialistsByProfile(int pid) async {
  String url = base_url + "api/specialists/?pid=$pid";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response;
    } else {
      return response;
    }
  } catch(e) {
    print(e);
  }
}

Future createCustomer(Map data) async {
  String url = base_url + "api/customers/";
  try {
    Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 201) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future getCustomersBySpecialistId(int spid) async {
  String url = base_url + "api/customers/?spid=$spid";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response;
    } else {
      return response;
    }
  } catch(e) {
    print(e);
  }
}

Future getCustomers(int pid) async {
  String url = base_url + "api/customers/?pid=$pid";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response;
    } else {
      return response;
    }
  } catch(e) {
    print(e);
  }
}

Future deleteCustomer(int pk) async {
  String url = base_url + "api/customers/?pk=$pk";
  try {
    Response response = await http.delete(Uri.parse(url), headers: {'content-type': "application/json"});
    return response;

  } catch(e) {
    print(e);
  }
}

Future getConversation(int cid, int sid) async {
  String url = base_url + "api/comms/?cid=$cid&sid=$sid";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response;
    } else {
      return response;
    }
  } catch(e) {
    print(e);
  }
}

Future postConversation(Map data) async {
  String url = base_url + "api/comms/";
  try {
    Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 201) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future updateConversation(int pk, Map data) async {
  String url = base_url + "api/comms/?pk=$pk";
  try {
    Response response = await http.put(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred in updating comment");
    }
  } catch(e) {
    print(e);
  }
}

Future deleteConversation(int pk) async {
  String url = base_url + "api/comms/?pk=$pk";
  try {
    Response response = await http.delete(Uri.parse(url), headers: {'content-type': "application/json"});
    return response;
  } catch(e) {
    print(e);
  }
}

Future getRatings(int sid) async {
  String url = base_url + "api/rateService/?sid=$sid";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response;
    } else {
      return response;
    }
  } catch(e) {
    print(e);
  }
}

Future getUserRatings(int sid, int pid) async {
  String url = base_url + "api/rateService/?sid=$sid&pid=$pid";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response;
    } else {
      return response;
    }
  } catch(e) {
    print(e);
  }
}

Future postRating(Map data) async {
  String url = base_url + "api/rateService/";
  try {
    Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 201) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future updateRating(int pk, Map data) async {
  String url = base_url + "api/rateService/?pk=$pk";
  try {
    Response response = await http.put(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred in updating comment");
    }
  } catch(e) {
    print(e);
  }
}

Future getEvents(int sid) async {
  String url = base_url + "api/events/?sid=$sid";
  try {
    Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      return response;
    } else {
      return response;
    }
  } catch(e) {
    print(e);
  }
}

Future createEvent(Map data) async {
  String url = base_url + "api/events/";
  try {
    Response response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 201) {
      return response.body;
    } else {
      print("An error occurred");
    }
  } catch(e) {
    print(e);
  }
}

Future updateEvent(int pk, Map data) async {
  String url = base_url + "api/events/?pk=$pk";
  try {
    Response response = await http.put(Uri.parse(url), body: jsonEncode(data), headers: {'content-type': "application/json"});
    if(response.statusCode == 200) {
      return response.body;
    } else {
      print("An error occurred in updating event");
    }
  } catch(e) {
    print(e);
  }
}

Future deleteEvents(int pk) async {
  String url = base_url + "api/events/?pk=$pk";
  try {
    Response response = await http.delete(Uri.parse(url), headers: {'content-type': "application/json"});
    return response;
  } catch(e) {
    print(e);
  }
}