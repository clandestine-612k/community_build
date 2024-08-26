// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:community_build/blog/blog_page.dart';
// import 'package:community_build/chatroom.dart';
// import 'package:community_build/chatted_user.dart';
// import 'package:community_build/group_chat/groupchat_screen.dart';
// import 'package:community_build/pages/loginpage.dart';
// import 'package:community_build/blog/photoupload.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class MyHomePage extends StatefulWidget {
//   final String uid;

//   MyHomePage({required this.uid});
//    Future<String?> getUserName() async {
//     try {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
//       return userDoc['name'];
//     } catch (e) {
//       print(e); // Handle errors appropriately
//       return null;
//     }
//   }
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// // class _MyHomePageState extends State<MyHomePage> {
// //   bool isLoading = false;
// //   Map<String, dynamic>? userMap;
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final TextEditingController _search = TextEditingController();

// //   String chatRoomId(String user1, String user2) {
// //     if (user1[0].toLowerCase().codeUnits[0] >
// //         user2.toLowerCase().codeUnits[0]) {
// //       return "$user1$user2";
// //     } else {
// //       return "$user2$user1";
// //     }
// //   }

// //   void onSearch() async {
// //     FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //     setState(() {
// //       isLoading = true;
// //     });
// //     await _firestore
// //         .collection("users")
// //         .where("email", isEqualTo: _search.text)
// //         .get()
// //         .then((value) {
// //       setState(() {
// //         userMap = value.docs[0].data();
// //         isLoading = false;
// //       });
// //       print(userMap);
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final size = MediaQuery.of(context).size;
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Home Screen"),
// //         actions: [
// //           IconButton(icon: Icon(Icons.logout), onPressed: () => logOut(context))
// //         ],
// //       ),
// //       body: isLoading
// //           ? Center(
// //               child: Container(
// //                 height: size.height / 20,
// //                 width: size.height / 20,
// //                 child: CircularProgressIndicator(),
// //               ),
// //             )
// //           : Column(
// //               children: [
// //                 SizedBox(
// //                   height: size.height / 20,
// //                 ),
// //                 Container(
// //                   height: size.height / 14,
// //                   width: size.width,
// //                   alignment: Alignment.center,
// //                   child: Container(
// //                     height: size.height / 14,
// //                     width: size.width / 1.15,
// //                     child: TextField(
// //                       controller: _search,
// //                       decoration: InputDecoration(
// //                         hintText: "Search",
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(10),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(
// //                   height: size.height / 50,
// //                 ),
// //                 ElevatedButton(
// //                   onPressed: onSearch,
// //                   child: Text("Search"),
// //                 ),
// //                 SizedBox(
// //                   height: size.height / 20,
// //                 ),
// //                 userMap != null
// //                     ? ListTile(
// //                         onTap: () {
// //                           String roomId = chatRoomId(
// //                               _auth.currentUser!.displayName!,
// //                               userMap!['name']);

// //                           Navigator.of(context).push(
// //                             MaterialPageRoute(
// //                               builder: (_) => ChatRoom(
// //                                 userMap: userMap!,
// //                                 ChatRoomId: roomId,
// //                               ),
// //                             ),
// //                           );
// //                         },
// //                         leading: Icon(
// //                           Icons.account_box_outlined,
// //                           color: Colors.black,
// //                         ),
// //                         title: Text(
// //                           userMap!["name"],
// //                           style: TextStyle(
// //                               color: Colors.black,
// //                               fontSize: 17,
// //                               fontWeight: FontWeight.w500),
// //                         ),
// //                         subtitle: Text(userMap!["email"]),
// //                         trailing: Icon(
// //                           Icons.chat,
// //                           color: Colors.black,
// //                         ),
// //                       )
// //                     : Container(),
// //               ],
// //             ),
// //     );
// //   }
// // }

// // Widget ChatTile(Size size) {
// //   return Container(
// //     height: size.height / 12,
// //     width: size.width / 1.2,
// //   );
// // }

// // Future logOut(BuildContext context) async {
// //   FirebaseAuth _auth = FirebaseAuth.instance;

// //   try {
// //     await _auth.signOut().then((value) {
// //       Navigator.push(
// //           context, MaterialPageRoute(builder: (_) => const LoginPage()));
// //     });
// //   } catch (e) {
// //     print("error");
// //   }
// // }

// class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
//   bool isLoading = false;
//   Map<String, dynamic>? userMap;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _search = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     setStatus("Online");
//   }

//   void setStatus(String status) async {
//     await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
//       "status": status,
//     });
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       // online
//       setStatus("Online");
//     } else {
//       // offline
//       setStatus("Offline");
//     }
//   }

//   String chatRoomId(String user1, String user2) {
//     // Make the chat room ID generation case-insensitive
//     user1 = user1.toLowerCase();
//     user2 = user2.toLowerCase();
//     if (user1.codeUnits[0] > user2.codeUnits[0]) {
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
//     try {
//       await _firestore
//           .collection("users")
//           .where("email", isEqualTo: _search.text)
//           .get()
//           .then((value) {
//         if (value.docs.isNotEmpty) {
//           setState(() {
//             userMap = value.docs.first.data();
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//             userMap = null;
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("User not found")),
//           );
//         }
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Home Screen"),
//         automaticallyImplyLeading: false,
//         actions: [
//           Row(
//             children: [
//               IconButton(
//                   icon: Icon(Icons.add_a_photo),
//                   onPressed: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(builder: (_) => UploadPhotoPage()),
//                     );
//                   }),
//               IconButton(
//                   icon: Icon(Icons.message),
//                   onPressed: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(builder: (_) => ChattedUsersPage()),
//                     );
//                   }),
//               IconButton(
//                 icon: Icon(Icons.logout),
//                 onPressed: () => logOut(context),
//               ),
//             ],
//           )
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
//                           if (_auth.currentUser != null) {
//                             String roomId = chatRoomId(
//                               _auth.currentUser!.displayName ?? "",
//                               userMap!['name'] ?? "",
//                             );

//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (_) => ChatRoom(
//                                   userMap: userMap!,
//                                   ChatRoomId: roomId,
//                                 ),
//                               ),
//                             );
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text("You are not logged in")),
//                             );
//                           }
//                         },
//                         leading: Icon(
//                           Icons.account_box_outlined,
//                           color: Colors.black,
//                         ),
//                         title: Text(
//                           userMap!["name"] ?? "",
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 17,
//                               fontWeight: FontWeight.w500),
//                         ),
//                         subtitle: Text(userMap!["email"] ?? ""),
//                         trailing: Icon(
//                           Icons.chat,
//                           color: Colors.black,
//                         ),
//                       )
//                     : Container(),
//               ],
//             ),

//       // floatingActionButton: FloatingActionButton(
//       //   child: Icon(Icons.group),
//       //   onPressed: () => Navigator.of(context).push(
//       //     MaterialPageRoute(
//       //       builder: (_) => GroupChatHomeScreen(),
//       //     ),
//       //   ),
//       // ),

//       floatingActionButton: Stack(
//         children: <Widget>[
//           Align(
//             alignment: Alignment.bottomRight,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 FloatingActionButton(
//                   heroTag: 'btn1', // Use unique heroTag for each FAB
//                   child: Icon(Icons.group),
//                   onPressed: () => Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (_) => GroupChatHomeScreen(),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16), // Space between the FABs
//                 FloatingActionButton(
//                   heroTag: 'btn2', // Use unique heroTag for each FAB
//                   child: Icon(Icons.pages),
//                   onPressed: () => Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (_) => BlogPage(),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
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

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_build/blog/blog_page.dart';
import 'package:community_build/chatroom.dart';
import 'package:community_build/chatted_user.dart';
import 'package:community_build/group_chat/groupchat_screen.dart';
import 'package:community_build/pages/deleteaccount.dart';
import 'package:community_build/pages/loginpage.dart';
import 'package:community_build/blog/photoupload.dart';
import 'package:community_build/pages/profile.dart';
import 'package:community_build/services/notification_services.dart';
import 'package:community_build/voice_assistance/voice_assistance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  final String uid;

  MyHomePage({required this.uid});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool isLoading = false;
  Map<String, dynamic>? userMap;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  NotificationServices notificationServices = NotificationServices();

  Future<String?> getUserName() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      return userDoc['name'];
    } catch (e) {
      print(e); // Handle errors appropriately
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit();
    notificationServices.getTokenRefresh();
    notificationServices.getDeviceToken(widget.uid).then(
      (value) {
        print('Device token');
        print(value);
      },
    );
    //   void firebaseInit(BuildContext context) {
    //   FirebaseMessaging.onMessage.listen((message) {

    //     if (Platform.isAndroid) {
    //       initLocalNotifications(context, message);
    //       showNotification(message);
    //     }
    //   });
    // }
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
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: FutureBuilder<String?>(
          future: getUserName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(
                color: Colors.white,
              );
            } else if (snapshot.hasError) {
              return Text('Error');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Text('No user data found');
            } else {
              return Text('Hello, ${snapshot.data}');
            }
          },
        ),
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
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProfilePage(
                      uid: widget.uid,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Delete Account'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => Deleteaccount(),
                  ),
                );
              },
            ),
          ],
        ),
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
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'btn1', // Use unique heroTag for each FAB
                  child: Icon(Icons.group),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => GroupChatHomeScreen(),
                    ),
                  ),
                ),
                SizedBox(height: 16), // Space between the FABs
                FloatingActionButton(
                  heroTag: 'btn2', // Use unique heroTag for each FAB
                  child: Icon(Icons.pages),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlogPage(),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                FloatingActionButton(
                  heroTag: 'btn3', // Use unique heroTag for each FAB
                  child: Icon(Icons.assistant),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => VoiceAssistance(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut().then((value) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    });
  } catch (e) {
    print("error");
  }
}
