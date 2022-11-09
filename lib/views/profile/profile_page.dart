import 'package:flutter/material.dart';
import 'package:student/constants/controllers.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Text("User name ${studentAuthController.studentModel.value.studentName}"),
      ),
    );
  }
}
