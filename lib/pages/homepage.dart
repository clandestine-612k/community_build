import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_build/chatroom.dart';
import 'package:community_build/chatted_user.dart';
import 'package:community_build/group_chat/groupchat_screen.dart';
import 'package:community_build/pages/loginpage.dart';
import 'package:community_build/photoupload.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// class _MyHomePageState extends State<MyHomePage> {
//   bool isLoading = false;
//   Map<String, dynamic>? userMap;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _search = TextEditingController();

//   String chatRoomId(String user1, String user2) {
//     if (user1[0].toLowerCase().codeUnits[0] >
//         user2.toLowerCase().codeUnits[0]) {
//       return "$user1$user2";
//     } else {
//       return "$user2$user1";
//     }
//   }

//   void onSearch() async {
//     FirebaseFirestore _firestore = FirebaseFirestore.instance;
//     setState(() {
//       isLoading = true;
//     });
//     await _firestore
//         .collection("users")
//         .where("email", isEqualTo: _search.text)
//         .get()
//         .then((value) {
//       setState(() {
//         userMap = value.docs[0].data();
//         isLoading = false;
//       });
//       print(userMap);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Home Screen"),
//         actions: [
//           IconButton(icon: Icon(Icons.logout), onPressed: () => logOut(context))
//         ],
//       ),
//       body: isLoading
//           ? Center(
//               child: Container(
//                 height: size.height / 20,
//                 width: size.height / 20,
//                 child: CircularProgressIndicator(),
//               ),
//             )
//           : Column(
//               children: [
//                 SizedBox(
//                   height: size.height / 20,
//                 ),
//                 Container(
//                   height: size.height / 14,
//                   width: size.width,
//                   alignment: Alignment.center,
//                   child: Container(
//                     height: size.height / 14,
//                     width: size.width / 1.15,
//                     child: TextField(
//                       controller: _search,
//                       decoration: InputDecoration(
//                         hintText: "Search",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: size.height / 50,
//                 ),
//                 ElevatedButton(
//                   onPressed: onSearch,
//                   child: Text("Search"),
//                 ),
//                 SizedBox(
//                   height: size.height / 20,
//                 ),
//                 userMap != null
//                     ? ListTile(
//                         onTap: () {
//                           String roomId = chatRoomId(
//                               _auth.currentUser!.displayName!,
//                               userMap!['name']);

//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (_) => ChatRoom(
//                                 userMap: userMap!,
//                                 ChatRoomId: roomId,
//                               ),
//                             ),
//                           );
//                         },
//                         leading: Icon(
//                           Icons.account_box_outlined,
//                           color: Colors.black,
//                         ),
//                         title: Text(
//                           userMap!["name"],
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 17,
//                               fontWeight: FontWeight.w500),
//                         ),
//                         subtitle: Text(userMap!["email"]),
//                         trailing: Icon(
//                           Icons.chat,
//                           color: Colors.black,
//                         ),
//                       )
//                     : Container(),
//               ],
//             ),
//     );
//   }
// }

// Widget ChatTile(Size size) {
//   return Container(
//     height: size.height / 12,
//     width: size.width / 1.2,
//   );
// }

// Future logOut(BuildContext context) async {
//   FirebaseAuth _auth = FirebaseAuth.instance;

//   try {
//     await _auth.signOut().then((value) {
//       Navigator.push(
//           context, MaterialPageRoute(builder: (_) => const LoginPage()));
//     });
//   } catch (e) {
//     print("error");
//   }
// }

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool isLoading = false;
  Map<String, dynamic>? userMap;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    // Make the chat room ID generation case-insensitive
    user1 = user1.toLowerCase();
    user2 = user2.toLowerCase();
    if (user1.codeUnits[0] > user2.codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    setState(() {
      isLoading = true;
    });
    try {
      await _firestore
          .collection("users")
          .where("email", isEqualTo: _search.text)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          setState(() {
            userMap = value.docs.first.data();
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            userMap = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User not found")),
          );
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        automaticallyImplyLeading: false,
        actions: [
          Row(
            children: [
              IconButton(
                  icon: Icon(Icons.add_a_photo),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => UploadPhotoPage()),
                    );
                  }),
              IconButton(
                  icon: Icon(Icons.message),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ChattedUsersPage()),
                    );
                  }),
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () => logOut(context),
              ),
            ],
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.15,
                    child: TextField(
                      controller: _search,
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                ElevatedButton(
                  onPressed: onSearch,
                  child: Text("Search"),
                ),
                SizedBox(
                  height: size.height / 20,
                ),
                userMap != null
                    ? ListTile(
                        onTap: () {
                          if (_auth.currentUser != null) {
                            String roomId = chatRoomId(
                              _auth.currentUser!.displayName ?? "",
                              userMap!['name'] ?? "",
                            );

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ChatRoom(
                                  userMap: userMap!,
                                  ChatRoomId: roomId,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("You are not logged in")),
                            );
                          }
                        },
                        leading: Icon(
                          Icons.account_box_outlined,
                          color: Colors.black,
                        ),
                        title: Text(
                          userMap!["name"] ?? "",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(userMap!["email"] ?? ""),
                        trailing: Icon(
                          Icons.chat,
                          color: Colors.black,
                        ),
                      )
                    : Container(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.group),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => GroupChatHomeScreen(),
          ),
        ),
      ),
    );
  }
}

Future logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut().then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const LoginPage()));
    });
  } catch (e) {
    print("error");
  }
}
