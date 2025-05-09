import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrm_attendance_proj/utils/constants.dart';

import '../model/user_model.dart';

class UserController extends GetxController {

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;



  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailIdController = TextEditingController();
  final phoneNoController = TextEditingController();
  final positionController = TextEditingController();

  final loggedInUserId = ''.obs;


  RxList<UserModel> userList = <UserModel>[].obs;

  var currentUser = Rxn<UserModel>(); // Rxn = reactive nullable





  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }


  Future<void> fetchUsers() async {
    try {
      final snapshot = await firebaseFirestore
          .collection(AppConstants.collectionUser)
          .get();

      userList.value = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();

      print("Customer data fetched successfully : $userList");
    } catch (e) {
      print("Something went wrong");
    }
  }

  // Call this when user "logs in" with their userId
  Future<void> setLoggedInUser(String userId) async {
    loggedInUserId.value = userId;
    await fetchCurrentUser();
  }

  // Fetch only the current user's data
  Future<void> fetchCurrentUser() async {
    if (loggedInUserId.value.isEmpty) return;

    try {
      final doc = await firebaseFirestore
          .collection(AppConstants.collectionUser)
          .doc(loggedInUserId.value)
          .get();

      if (doc.exists) {
        currentUser.value = UserModel.fromMap(doc.data()!);
      }
    } catch (e) {
      print("Error fetching current user: $e");
    }
  }


  Future<void> addUpdateUserDetails(BuildContext context,
      Function() onSaveComplete, UserModel? updateUserData) async {
    if (await validateFields(context)) {
      if (updateUserData != null) {
        var docRef = firebaseFirestore
            .collection(AppConstants.collectionUser)
            .doc(updateUserData.uId);

        print("User Name : ${userNameController.text}");


        var userData = UserModel(uId: updateUserData.uId,
            userName: userNameController.text.trim().toString(),
            password: passwordController.text.trim().toString(),
            emailId: emailIdController.text.trim().toString(),
            phoneNo: phoneNoController.text.trim().toString(),
            position: positionController.text.trim().toString(),);


        print("userData : ${userData.toString()}");

        await docRef.update(userData.toMap());

        clearController(context);
        fetchUsers();

      } else {
        var docRef =
        firebaseFirestore.collection(AppConstants.collectionUser).doc();

        var userId = docRef.id;

        print("Customer Name : ${userNameController.text}");

        var userData = UserModel(uId: userId,
          userName: userNameController.text.trim().toString(),
          password: passwordController.text.trim().toString(),
          emailId: emailIdController.text.trim().toString(),
          phoneNo: phoneNoController.text.trim().toString(),
          position: positionController.text.trim().toString(),);

        print("UserData : ${userData.toString()}");

        await docRef.set(userData.toMap());

        clearController(context);
        fetchUsers();
      }

      onSaveComplete();
      Get.back();

      clearController(context);
    }
  }


  validateFields(BuildContext context) {
    if (userNameController.text.isEmpty) {
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

    if (passwordController.text.isEmpty) {
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


  void deleteCustomerData(BuildContext context, String userId) {
    firebaseFirestore
        .collection(AppConstants.collectionUser)
        .doc(userId)
        .delete();

    fetchUsers();
  }

  void clearController(BuildContext context) {
    userNameController.clear();
    passwordController.clear();
    emailIdController.clear();
    phoneNoController.clear();
    positionController.clear();
  }
}






