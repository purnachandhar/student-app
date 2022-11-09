import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student/constants/controllers.dart';
import 'package:student/constants/firebase.dart';
import 'package:student/controllers/mobileVerificationStateController.dart';
import 'package:student/models/student_model.dart';
import 'package:student/views/notification/notification_page.dart';
import 'package:student/views/registation/student_regisation.dart';

class StudentAuthController extends GetxController {
  static StudentAuthController instance = Get.find<StudentAuthController>();
  Rxn<User> firebaseUser = Rxn<User>();

  Rx<StudentModel> studentModel = StudentModel().obs;

  MobileVerificationState currentState =
      mobileVerificationStateController.myEnum.value;

  CollectionReference notificationCollection =
  FirebaseFirestore.instance.collection('notifications');

  RxBool showLoading = false.obs;

  RxString tokevalue = "".obs;

  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  String? verificationId;

  String studentCollection = "students";



  getToken(String token,String studentId){
    tokevalue.value = token;
    print("token is generated: ${tokevalue.value}");
    firebaseFirestore.collection(studentCollection).doc(studentId).set({
      "id": studentId,
      "mobileNumber": mobileNumberController.text.trim(),
      "name": nameController.text.trim(),
      "token": "${tokevalue.value}",
      "notifications": []
    });
  }

  changeLoader(bool value) {
    showLoading.value = value;
  }

  changeMobileVerification(value) {
    currentState = value;
  }

  changeVerificationId(String id) {
    verificationId = id;
  }

  @override
  void onReady() {
    firebaseUser = Rxn<User>(auth.currentUser);
    firebaseUser.bindStream(auth.authStateChanges());
    ever<User?>(firebaseUser, setInitialScreen);

    super.onReady();
  }

  setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => StudentRegistationPage());
    } else {
      studentModel.bindStream(listenToUser());
      Get.offAll(() => NotificationPage());
    }
  }

  void verifyPhoneNumber() async {
    print("Sate1 $currentState");
    changeLoader(true);
    await auth.verifyPhoneNumber(
      phoneNumber: "+91${mobileNumberController.text.trim()}",
      timeout: Duration(seconds: 30),
      verificationCompleted: (phoneAuthCredential) async {
        //signInWithPhoneAuthCredential(phoneAuthCredential);
      },
      verificationFailed: (verificationFailed) async {
        changeLoader(false);
        Get.snackbar("Sorry", "Please Enter Correct Mobile Number");
        print("Error from Verification ${verificationFailed.message}");
      },
      codeSent: (verificationId, resendingToken) async {
        changeLoader(false);
        mobileVerificationStateController.myEnum;
        // currentState = mobileVerificationStateController.myEnum(MobileVerificationState.SHOW_OTP_FORM_STATE);
        changeMobileVerification(MobileVerificationState.SHOW_OTP_FORM_STATE);
        print("Sate2 $currentState");
        changeVerificationId(verificationId);
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
  }

  void getOtpAndVerify() {
    AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: otpController.text);
    signInWithPhoneAuthCredential(phoneAuthCredential);
  }

  void signInWithPhoneAuthCredential(AuthCredential phoneAuthCredential) async {
    changeLoader(true);
    try {
      await auth.signInWithCredential(phoneAuthCredential);
      changeLoader(true);
      print("Sucreesfully Logined");
      print("from auth controller ${auth.currentUser?.uid}");
      addStudentToFirestore("${auth.currentUser?.uid}");
    } on FirebaseAuthException catch (e) {
      print(e);
      changeLoader(false);
      Get.snackbar("Sorry", "${e.message}");
      print("Error from Auth ${e.message}");
      // logger.e(e.message);
    }
  }

  addStudentToFirestore(String studentId) async {
    firebaseMessaging.getToken().then((value) {
      getToken(value!,studentId);
    });
  }

  Stream<StudentModel> listenToUser() => firebaseFirestore
      .collection(studentCollection)
      .doc(firebaseUser.value?.uid)
      .snapshots()
      .map((snapshot) => StudentModel.fromSnapshot(snapshot));
}
