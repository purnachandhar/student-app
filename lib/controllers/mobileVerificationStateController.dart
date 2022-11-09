import 'package:get/get.dart';

class MobileVerificationStateController extends GetxController{
  static MobileVerificationStateController instance = Get.find();
    Rx<MobileVerificationState> myEnum = Rx<MobileVerificationState>(MobileVerificationState.SHOW_MOBILE_FORM_STATE);
}
enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}