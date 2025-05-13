import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrm_attendance_proj/model/user_model.dart';
import 'package:hrm_attendance_proj/router/app_router.dart';
import 'package:hrm_attendance_proj/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../storage_service/storage_service.dart';

class LoginController extends GetxController {
  var userList = <UserModel>[].obs;

  var isRegistering = false.obs;



  var userId = ''.obs;
  var uId = ''.obs;
  var userPassword = ''.obs;
  var userName = ''.obs;
  var userDesignation = ''.obs;
  var userPhoneNumber = ''.obs;
  var userEmailId = ''.obs;

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailIdController = TextEditingController();
  final phoneNoController = TextEditingController();
  final positionController = TextEditingController();

  loginSubmit(BuildContext context) async {
    if (await validateFields(context)) {
      String userName = userNameController.text.trim();
      String password = passwordController.text.trim();

      try {
        bool userFound = await isCheckUserData(userName, password, context);

        // If the user is found, we move them to the correct screen
        if (userFound) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome $userName'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.blue,
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Set data in SharedPreferences for the logged-in user
          await UsersStorageService.saveUserDetails(
            uId: uId.value,
            userName: userName,
            emailId: userEmailId.value,
            phoneNo: userPhoneNumber.value,
            position: userDesignation.value,
          );

          // Set default flags for clock-in and attendance success
          await UsersStorageService.setClockInDone(false);
          await UsersStorageService.setAttendanceSuccessDone(false);

          // Proceed to the next screen
          Get.offNamed(AppRouter.CLOCK_IN_SCREEN);
        } else {
          // Invalid credentials, show error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid Credentials'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.blue,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        print("firebase Error $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong $e'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<bool> validateFields(BuildContext context) async {
    String userName =
        userNameController.text.trim(); // Changed mobileNumber to userName
    String password = passwordController.text.trim();

    if (userName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please Provide Username'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    if (userName.length < 3) {
      // You can change this condition based on your username validation requirements
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username must be at least 3 characters'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please Provide Password'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    if (password.length < 4) {
      // Password too short
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password length must be at least 4'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    if (password.length >= 4 && password.length < 8) {
      // Password length is between 4 and 7 characters
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password length must be exactly 8'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    return true;
  }

  // New user check: This method will check if the user exists and save data if not
  Future<bool> isCheckUserData(
      String userName, String password, BuildContext context) async {
    print("UserLogin");

    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection(AppConstants.collectionUser)
        .where('userName', isEqualTo: userName)
        .where('password', isEqualTo: password)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      var userData = userSnapshot.docs.first;
      uId.value = userData['uId'];
      userName = userData['userName'];
      String position = userData['position'];
      String emailId = userData['emailId'];
      String phoneNo = userData['phoneNo'];

      // Set the user data in variables
      userDesignation.value = position;
      userEmailId.value = emailId;
      userPhoneNumber.value = phoneNo;

      return true; // Existing user found
    } else {
      return false; // User not found, new user
    }
  }

  void clearController(BuildContext context) {
    registerUserNameController.clear();
    registerPasswordController.clear();
    // userNameController.clear();
    // passwordController.clear();
    emailIdController.clear();
    phoneNoController.clear();
    positionController.clear();
  }

  Future<void> getAdminDataFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('name');
    String? password = prefs.getString('password');

    // Print retrieved data with newlines
    print("Retrieved Admin Data:\nUser Name: $userName\nPassword: $password");
  }





  //-------------------Register Field -------------------------//

  final registerUserNameController = TextEditingController();
  final registerPasswordController = TextEditingController();

  // Register New User method
  Future<void> registerUser(BuildContext context) async {
    if (isRegistering.value) return;

    isRegistering.value = true;

    if (await registerValidateFields(context)) {
      try {
        var docRef = firebaseFirestore.collection(AppConstants.collectionUser).doc();
        var userId = docRef.id;

        var userData = UserModel(
          uId: userId,
          userName: registerUserNameController.text.trim(),
          password: registerPasswordController.text.trim(),
          emailId: emailIdController.text.trim(),
          phoneNo: phoneNoController.text.trim(),
          position: positionController.text.trim(),
        );

        await docRef.set(userData.toMap());

        await UsersStorageService.saveUserDetails(
          uId: userId,
          userName: userData.userName,
          emailId: userData.emailId,
          phoneNo: userData.phoneNo,
          position: userData.position,
        );

        clearController(context);
        Get.offAllNamed(AppRouter.LOGIN_SCREEN);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    isRegistering.value = false;
  }



  registerValidateFields(BuildContext context) {
    if (registerUserNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill the name field',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red, // Red color for the error
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false; // Validation failed, stop further validation
    }

    if (registerPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill the password field',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red, // Red color for the error
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false; // Validation failed, stop further validation
    }

    if (emailIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill the mail field',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red, // Red color for the error
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false; // Validation failed, stop further validation
    }

    if (phoneNoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill the mobile number field',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red, // Red color for the error
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false; // Validation failed, stop further validation
    }

    if (positionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill the position field',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red, // Red color for the error
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false; // Validation failed, stop further validation
    }

    //clearController(context);
    return true;
  }



  Future<void> updateUserProfile(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('user').doc(userId).update({
        'emailId': emailIdController.text.trim(),
        'phoneNo': phoneNoController.text.trim(),
      });

      // Optional: show success snackbar
      Get.snackbar("Success", "Profile updated successfully",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      print("Error updating profile: $e");
      Get.snackbar("Error", "Failed to update profile",
          snackPosition: SnackPosition.BOTTOM);
    }
  }



}
