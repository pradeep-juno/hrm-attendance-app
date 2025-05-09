import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hrm_attendance_proj/router/app_router.dart';
import '../model/leave_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LeaveController extends GetxController {
  final firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController reasonController = TextEditingController();

  // Observable variables for leave request form
  var selectedLeaveType = ''.obs; // You might still need this for record-keeping
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  var offDayLeaveDuration = 0.obs;
  var reason = ''.obs;
  var totalLeaveDays = 0.obs;
  var leaveCreatedAt = ''.obs;
  var leaveStatus = ''.obs;



  // Observable variables for user data
  var userId = ''.obs;
  var userName = ''.obs;

  // Observable list to hold the leave requests fetched from Firestore
  var leaveRequests = <LeaveModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeaveRequests();
  }

  // Method to set the selected leave type
  void setLeaveType(String value) {
    selectedLeaveType.value = value;
  }

  // Method to set the start date and calculate total leave days
  void setStartDate(DateTime date) {
    startDate.value = date;
    _updateTotalDays();
  }

  // Method to set the end date and calculate total leave days
  void setEndDate(DateTime date) {
    endDate.value = date;
    _updateTotalDays();
  }

  // Method to set the off-day leave duration
  void setOffDayLeaveDuration(int value) {
    offDayLeaveDuration.value = value;
  }

  // Method to set the reason for the leave
  void setReason(String value) {
    reason.value = value;
  }

  // Private method to update the total leave days based on start and end date
  void _updateTotalDays() {
    totalLeaveDays.value =
        endDate.value.difference(startDate.value).inDays + 1;
  }

  // Validation method to check if the leave request form is filled correctly
  bool _validateForm() {
    final isLeaveRequest = totalLeaveDays.value > 0;
    final isPermissionRequest = offDayLeaveDuration.value > 0;

    if (!isLeaveRequest && !isPermissionRequest) {
      Get.snackbar('Validation Error', 'Please specify a leave duration (start and end date) or a permission duration');
      return false;
    }

    if (isLeaveRequest && endDate.value.isBefore(startDate.value)) {
      Get.snackbar('Validation Error', 'End date cannot be before start date');
      return false;
    }

    if (isLeaveRequest && reason.value.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Please enter a reason for leave');
      return false;
    }

    // You might want to add a validation if both leave and permission are submitted,
    // depending on your application's logic. For now, we allow both.

    return true;
  }

  // Method to submit the leave request to Firestore
  Future<void> submitLeaveRequest() async {
    if (!_validateForm()) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uId = prefs.getString('uId') ?? '';
    final userName = prefs.getString('userName') ?? '';

    // Step 1: Create the leave data map (without id)
    final data = {
      'leaveType': selectedLeaveType.value,
      'startDate': Timestamp.fromDate(startDate.value),
      'endDate': Timestamp.fromDate(endDate.value),
      'offDayLeaveDuration': offDayLeaveDuration.value,
      'reason': reason.value.trim(),
      'totalDays': totalLeaveDays.value,
      'uId': uId,
      'userName': userName,
      'leaveCreatedDate': Timestamp.fromDate(DateTime.now()),
      'leaveStatus': leaveStatus.value.trim(),
    };

    // Step 2: Add to Firestore
    final docRef = await firebaseFirestore.collection('leaveRequests').add(data);

    // Step 3: Now update the same document with its own ID
    await docRef.update({'id': docRef.id});

    // Step 4: Refresh list
    await fetchLeaveRequests();

    Get.snackbar('Success', 'Leave applied successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.black);

    _resetForm();

    Get.toNamed(AppRouter.APPROVAL_QUEUE_SCREEN);
  }


  // Private method to reset the form after submitting a leave request
  void _resetForm() {
    selectedLeaveType.value = '';
    startDate.value = DateTime.now();
    endDate.value = DateTime.now();
    offDayLeaveDuration.value = 0;
    reasonController.clear();
    totalLeaveDays.value = 0;
  }

  // Method to fetch leave requests from Firestore
  Future<void> fetchLeaveRequests() async {
    try {
      final querySnapshot = await firebaseFirestore
          .collection('leaveRequests')
      .orderBy('leaveCreatedDate', descending: true)
          .get();

      // Mapping Firestore data to LeaveModel list
      final leaveData = querySnapshot.docs.map((doc) {
        return LeaveModel.fromMap(doc.data(), doc.id);

      }).toList();

      leaveRequests.value = leaveData; // Assign fetched data to observable list
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch leave requests: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
  Future<void> updateLeaveStatus(String docId, String newStatus) async {
    try {
      await firebaseFirestore
          .collection('leaveRequests')
          .doc(docId)
          .update({'leaveStatus': newStatus});

      // Refresh the list
      await fetchLeaveRequests();

      Get.snackbar('Success', 'Leave status updated to $newStatus',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.black);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update status: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

}