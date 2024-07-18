// import 'package:community_build/chatroom.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ChattedUsersPage extends StatelessWidget {
//   Future<List<Map<String, dynamic>>> getChattedUsers() async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     final firestore = FirebaseFirestore.instance;

//     if (currentUser == null) {
//       return [];
//     }

//     final chatDocs = await firestore
//         .collection('chats')
//         .where('participants', arrayContains: currentUser.uid)
//         .get();

//     final userIds = chatDocs.docs
//         .map((doc) => List<String>.from(doc.data()['participants'] as List))
//         .expand((ids) => ids)
//         .where((id) => id != currentUser.uid)
//         .toSet()
//         .toList();

//     final users = await Future.wait(userIds.map((id) async {
//       final userDoc = await firestore.collection('users').doc(id).get();
//       final userData = userDoc.data()!;
//       userData['uid'] = id; // Ensure uid is included in the user data
//       return userData;
//     }).toList());

//     return users;
//   }

//   // String chatRoomId(String user1, String user2) {
//   //   if (user1.compareTo(user2) > 0) {
//   //     return "$user1\_$user2";
//   //   } else {
//   //     return "$user2\_$user1";
//   //   }
//   // }
//     String chatRoomId(String user1, String user2) {
//     // Make the chat room ID generation case-insensitive
//     user1 = user1.toLowerCase();
//     user2 = user2.toLowerCase();
//     if (user1.codeUnits[0] > user2.codeUnits[0]) {
//       return "$user1$user2";
//     } else {
//       return "$user2$user1";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chatted Users'),
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: getChattedUsers(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No users found.'));
//           }

//           final users = snapshot.data!;

//           return ListView.builder(
//             itemCount: users.length,
//             itemBuilder: (context, index) {
//               final user = users[index];
//               return ListTile(
//                 title: Text(user['name'] ?? 'Unknown User'),
//                 subtitle: Text(user['email'] ?? ''),
//                 onTap: () {
//                   if (FirebaseAuth.instance.currentUser != null) {
//                     String roomId = chatRoomId(
//                       FirebaseAuth.instance.currentUser!.displayName ?? "",
//                       user['name'] ?? "",
//                     );

//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (_) => ChatRoom(
//                           userMap: user,
//                           ChatRoomId: roomId,
//                         ),
//                       ),
//                     );
//                   }
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChattedUsersPage extends StatelessWidget {
  Future<List<Map<String, dynamic>>> getChatRooms() async {
    //   final currentUser = FirebaseAuth.instance.currentUser;
    //   final firestore = FirebaseFirestore.instance;

    //   if (currentUser == null) {
    //     return [];
    //   }

    //   final userName = currentUser.displayName?.toLowerCase() ?? "";
    //   print(userName);

    //   final chatDocs = await firestore.collection('chatroom').get();
    //   print(chatDocs);

    //   final chatRooms = chatDocs.docs.where((doc) {
    //     final chatRoomId = doc.id.toLowerCase();
    //     return chatRoomId.contains(userName);
    //   }).map((doc) {
    //     return {
    //       'chatRoomId': doc.id,
    //       ...doc.data() as Map<String, dynamic>,
    //     };
    //   }).toList();
    //   print(chatRooms);
    //   return chatRooms;
    // }
    final currentUser = FirebaseAuth.instance.currentUser;
    final firestore = FirebaseFirestore.instance;

    if (currentUser == null) {
      print("No current user logged in");
      return [];
    }

    final userName = currentUser.displayName?.toLowerCase() ?? "";
    print("Current user name: $userName");

    final chatDocs = await firestore.collection('chatroom').get();
    print("Fetched ${chatDocs.docs.length} chat rooms");

    final chatRooms = chatDocs.docs.where((doc) {
      final chatRoomId = doc.id.toLowerCase();
      final containsUserName = chatRoomId.contains(userName);
      print("Chat room ID: $chatRoomId, contains user name: $containsUserName");
      return containsUserName;
    }).map((doc) {
      return {
        'chatRoomId': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();

    print("Filtered chat rooms: ${chatRooms.length}");
    return chatRooms;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatted Users'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getChatRooms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No chat rooms found.'));
          }

          final chatRooms = snapshot.data!;

          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoom = chatRooms[index];
              final otherUserName = chatRoom['chatRoomId']
                  .replaceAll(
                      FirebaseAuth.instance.currentUser!.displayName!
                          .toLowerCase(),
                      "")
                  .toUpperCase();

              return ListTile(
                title: Text(otherUserName),
                subtitle: Text(chatRoom['chatRoomId']),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChatRoomee(
                        chatRoomId: chatRoom['chatRoomId'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ChatRoomee extends StatelessWidget {
  final String chatRoomId;

  ChatRoomee({required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room: $chatRoomId'),
      ),
      body: Center(
        child: Text('Chat room ID: $chatRoomId'),
      ),
    );
  }
}
