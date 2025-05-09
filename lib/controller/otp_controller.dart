import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  var verificationId = ''.obs;
  var isOtpSent = false.obs;
  var isLoading = false.obs;

  Future<void> sendOtp(String phoneNumber) async {
    isLoading.value = true;
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar("Error", e.message ?? "OTP Failed");
        },
        codeSent: (String verId, int? resendToken) {
          verificationId.value = verId;
          isOtpSent.value = true;
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId.value = verId;
        },
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp(String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: smsCode,
      );
      await auth.signInWithCredential(credential);
      Get.snackbar("Success", "Phone Verified");

      // Save UID in SharedPreferences if needed
      final user = auth.currentUser;
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('id', user.uid);
        await prefs.setString('userName', "Phone User");
        Get.offAllNamed('/main-navigation');
      }

    } catch (e) {
      Get.snackbar("Error", "Invalid OTP");
    }
  }
}
