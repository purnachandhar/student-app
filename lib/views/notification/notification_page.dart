import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:student/constants/controllers.dart';
import 'package:student/constants/firebase.dart';
import 'package:student/main.dart';
import 'package:student/views/profile/profile_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher'
            )
          )
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        // Get.snackbar("${notification.title}", "${notification.body}");
        Get.dialog(Container(
          child: Column(
            children: [
              Text("${notification.title}"),
              Text("${notification.body}"),
            ],
          ),
        ));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    print(
        "User name ${studentAuthController.studentModel.value
            .studentMobileNumber}");
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Get.to(ProfilePage());
              },
              icon: Icon(Icons.account_box))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: studentAuthController.notificationCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Loading"),
                    ),
                  ],
                ));
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Student List is Empty",));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: (){
                  // print("${snapshot.data!.docs[index]['token']}");
                  // String token = "${snapshot.data!.docs[index]['token']}";
                  // String name = "${snapshot.data!.docs[index]['name']}";
                  // String id = "${snapshot.data!.docs[index]['id']}";
                  // Get.to(SendNotificationToOneStudentPage(token,name,id));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: "${snapshot.data!.docs[index]['name']}" == "${studentAuthController.studentModel.value.studentName}"? Colors.green:  Colors.deepPurple,
                    child: ListTile(
                      title: Text("${snapshot.data!.docs[index]['title']}",style: TextStyle(color: Colors.white),),
                      subtitle: Text("${snapshot.data!.docs[index]['description']}",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
