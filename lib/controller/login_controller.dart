import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrm_attendance_proj/model/user_model.dart';
import 'package:hrm_attendance_proj/router/app_router.dart';
import 'package:hrm_attendance_proj/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var userList = <UserModel>[].obs;

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
        await isCheckUserData(userName, password, context);

        // Show "Invalid Credentials" only if both admin and user login failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid Credentials'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
          ),
        );
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

  Future<bool> isCheckAdminData(
    BuildContext context,
    String userName,
    String password,
  ) async {
    DocumentSnapshot adminSnapshot =
        await FirebaseFirestore.instance
            .collection(AppConstants.collectionAdmin)
            .doc(AppConstants.adminId)
            .get();

    if (adminSnapshot.exists) {
      String storedName = adminSnapshot['username']?.toString().trim() ?? '';
      String storedPassword =
          adminSnapshot['password']?.toString().trim() ?? '';

      print("Stored UserName: $storedName");
      print("Stored Password: $storedPassword");

      if (userName.trim() == storedName && password.trim() == storedPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Successfully'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
          ),
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', userName);
        await prefs.setString('password', password);

        getAdminDataFromPreferences();
        clearController(context);
        Get.offNamed(AppRouter.ADMIN_HOME_SCREEN);
        return true;
      }
    }

    return false; // Only return false, don't show snack here
  }

  isCheckUserData(
    String userName,
    String password,
    BuildContext context,
  ) async {
    print("UserLogin");

    QuerySnapshot userSnapshot =
        await FirebaseFirestore.instance
            .collection(AppConstants.collectionUser)
            .where('userName', isEqualTo: userName)
            .where('password', isEqualTo: password)
            .get();

    if (userSnapshot.docs.isNotEmpty) {
      var userData = userSnapshot.docs.first;
      String userName = userData['userName'];
      String staffId = userData['uId'];
      String position = userData['position'];
      String emailId = userData['emailId'];
      String phoneNo = userData['phoneNo'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome $userName'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
        ),
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('uId', staffId);
      await prefs.setString('userName', userName); // e.g. "mind"
      await prefs.setString('position', position);
      await prefs.setString('emailId', emailId); // e.g. "mind"
      await prefs.setString('phoneNo', phoneNo); // e.g. "trainee"
      await prefs.setBool('isClockInDone', false);
      await prefs.setBool('isAttendanceSuccessDone', false);
      await prefs.setString('id', AppConstants.adminId);

      getAdminDataFromPreferences();

      clearController(context);
      Get.offNamed(AppRouter.CLOCK_IN_SCREEN);

      return true;
    }
    return false;
  }

  void clearController(BuildContext context) {
    userNameController.clear();
    passwordController.clear();
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

  Future<void> registerUser(BuildContext context) async {
    if (await registerValidateFields(context)) {
      var docRef =
          firebaseFirestore.collection(AppConstants.collectionUser).doc();

      var userId = docRef.id;

      print("Registering User: ${registerUserNameController.text}");

      var userData = UserModel(
        uId: userId,
        userName: registerUserNameController.text.trim(),
        password: registerPasswordController.text.trim(),
        emailId: emailIdController.text.trim(),
        phoneNo: phoneNoController.text.trim(),
        position: positionController.text.trim(),
      );

      print("UserData: ${userData.toString()}");

      await docRef.set(userData.toMap());

      clearController(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Get.offAllNamed(AppRouter.LOGIN_SCREEN);
    }
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


  Future<void> getUserData(String userId) async {
    try {
      DocumentSnapshot userDoc = await firebaseFirestore
          .collection(AppConstants.collectionUser)
          .doc(userId)
          .get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;

        userNameController.text = data['userName'] ?? '';
        emailIdController.text = data['emailId'] ?? '';
        phoneNoController.text = data['phoneNo'] ?? '';

      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> updateUserProfile(String userId) async {
    try {
      String phone = phoneNoController.text.trim();
      String email = emailIdController.text.trim();


      await firebaseFirestore.collection(AppConstants.collectionUser).doc(userId).update({
        'phoneNo': phone,
        'emailId': email,

      });

      Get.snackbar("Success", "Profile updated successfully!");
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile: $e");
    }
  }


}
