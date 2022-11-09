import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student/constants/constains.dart';
import 'package:student/constants/controllers.dart';
import 'package:student/controllers/mobileVerificationStateController.dart';
import 'package:student/views/notification/notification_page.dart';

class StudentRegistationPage extends StatelessWidget {
  const StudentRegistationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Obx(() {
        // print("from login sate ${userController.currentState}");
        return Container(
          child: studentAuthController.showLoading()
              ? Center(
            child: CircularProgressIndicator(color: primaryColor,),
          )
              : studentAuthController.currentState ==
              mobileVerificationStateController.myEnum(
                  MobileVerificationState.SHOW_MOBILE_FORM_STATE)
              ? getStudentDetailsWidget(context)
              : getOtpFormWidget(context),
          padding: const EdgeInsets.all(16),
        );
      }),
    );
  }


  getStudentDetailsWidget(context){
    var size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: studentAuthController.nameController,
            decoration: InputDecoration(
                hintText: "Enter Name"
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: studentAuthController.mobileNumberController,
            decoration: InputDecoration(
                hintText: "Enter Mobile Number"
            ),
          ),
        ),
        SizedBox(height: 22,),
        InkWell(
          onTap: (){
            studentAuthController.verifyPhoneNumber();
          },
          child: Container(
            width: size.width / 1.5,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text("Get OTP"),
              ),
            ),
          ),
        ),
      ],
    );
  }

  getOtpFormWidget(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: studentAuthController.otpController,
            decoration: InputDecoration(
                hintText: "Enter Otp"
            ),
          ),
        ),
        SizedBox(height: 22,),
        InkWell(
          onTap: (){
            studentAuthController.getOtpAndVerify();
          },
          child: Container(
            width: size.width / 1.5,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text("Submit"),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
