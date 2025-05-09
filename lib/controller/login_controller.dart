import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrm_attendance_proj/model/user_model.dart';
import 'package:hrm_attendance_proj/router/app_router.dart';
import 'package:hrm_attendance_proj/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginController extends GetxController {

  RxList<UserModel>userList=<UserModel>[].obs;

  var userId = ''.obs;
  var uId = ''.obs;
  var userPassword = ''.obs;
  var userName = ''.obs;
  var userDesignation = ''.obs;
  var userPhoneNumber = ''.obs;
  var userEmailId = ''.obs;

  late Stream<DocumentSnapshot> adminDataStream;


  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();


  loginSubmit(BuildContext context) async {
    if (await validateFields(context)) {
      String userName = usernameController.text.trim();
      String password = passwordController.text.trim();

      try {
        bool isAdmin = await isCheckAdminData(context, userName, password);
        if (isAdmin) return;

        bool isUser = await isCheckUserData(userName, password, context);
        if (isUser) return;

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
      String userName = usernameController.text.trim(); // Changed mobileNumber to userName
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
      if (userName.length < 3) {  // You can change this condition based on your username validation requirements
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
    DocumentSnapshot adminSnapshot = await FirebaseFirestore.instance
        .collection(AppConstants.collectionAdmin)
        .doc(AppConstants.adminId)
        .get();

    if (adminSnapshot.exists) {
      String storedName = adminSnapshot['username']?.toString().trim() ?? '';
      String storedPassword = adminSnapshot['password']?.toString().trim() ?? '';

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

  isCheckUserData(String userName, String password, BuildContext context) async {

    print("UserLogin");

    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection(AppConstants.collectionUser)
        .where('userName', isEqualTo: userName)
        .where('password', isEqualTo: password)
        .get();


    if (userSnapshot.docs.isNotEmpty) {
      var userData = userSnapshot.docs.first;
      String userName = userData['userName'];
      String staffId = userData['uId'];
      String position = userData['position'];

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
      await prefs.setString('userName', userName);      // e.g. "mind"
      await prefs.setString('position', position);      // e.g. "trainee"
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
    usernameController.clear();
    passwordController.clear();
  }

  void listenAdminDataUpdates(BuildContext context, String id) {
    try {
      adminDataStream = firebaseFirestore
          .collection(AppConstants.collectionAdmin)
          .doc(id)
          .snapshots();

      adminDataStream.listen((documentSnapshots) {
        if (documentSnapshots.exists) {
          userName.value = documentSnapshots['userName'] ?? 'Not Found';
          userPassword.value = documentSnapshots['password'] ?? 'Not Found';
          userId.value = documentSnapshots['id'] ?? 'Not Found';

          print('userName: ${userName.value}');
          print('password: ${userPassword.value}');
          print('position: ${userDesignation.value}');
          print('userId: ${userId.value}');
        } else {
          print("ID not found");
        }
      });
    } catch (e) {
      print("timeout ");
    }
  }

  Future<void> listenUserDataUpdates(BuildContext context, String id) async {
    try {
      DocumentSnapshot documentSnapshot = await firebaseFirestore
          .collection('user')
          .doc(id)
          .get();

      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map<String, dynamic>;

        userName.value = data['userName'] ?? 'Not Found';
        userDesignation.value = data['position'] ?? 'Not Found';
        userId.value = data['uId'] ?? 'Not Found';
        userPassword.value = data['password'] ?? 'Not Found';
        userPhoneNumber.value = data['phoneNo'] ?? 'Not Found';
        userEmailId.value = data['emailId'] ?? 'Not Found';

        print('userName: ${userName.value}');
        print('position: ${userDesignation.value}');
        print('userId: ${userId.value}');
      } else {
        print("User ID not found");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> getAdminDataFromPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userName = prefs.getString('name');
  String? password = prefs.getString('password');

  // Print retrieved data with newlines
  print(
      "Retrieved Admin Data:\nUser Name: $userName\nPassword: $password");
}
}
