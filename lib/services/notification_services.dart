import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user provided permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print('user declined or have not accepted permission');
    }
  }

  Future showNotificationreceived(BuildContext context) async {
    // terminated
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remotemessage) {
      if (remotemessage != null) {
        //open app and show notification data
        openAppAndshowNotificationDataWhwnOpenApp(
          remotemessage.data["userID"],
          remotemessage.data["senderID"],
          context,
        );
      }
    });
    //Foreground

    FirebaseMessaging.onMessage.listen((RemoteMessage? remotemessage) {
      if (remotemessage != null) {
        //open app and show notification data
        openAppAndshowNotificationDataWhwnOpenApp(
          remotemessage.data["userID"],
          remotemessage.data["senderID"],
          context,
        );
      }
    });

    //Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remotemessage) {
      if (remotemessage != null) {
        //open app and show notification data
        openAppAndshowNotificationDataWhwnOpenApp(
          remotemessage.data["userID"],
          remotemessage.data["senderID"],
          context,
        );
      }
    });
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((Message) {
      print(Message.notification?.title.toString());
      print(Message.notification?.body.toString());
    });
  }

  Future<String> getDeviceToken(currentUserID) async {
    String? token = await messaging.getToken();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserID)
        .update({
      "userdevicetoken": token,
    });
    return token!;
  }

  void getTokenRefresh() async {
    messaging.onTokenRefresh.listen(
      (event) {
        print(event.toString());
      },
    );
  }

  openAppAndshowNotificationDataWhwnOpenApp(receiverID, senerID, context) {}
}
