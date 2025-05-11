import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hrm_attendance_proj/router/app_router.dart';
import '../model/leave_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LeaveController extends GetxController {
  final firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController reasonController = TextEditingController();


  var annualLeaveCount = '0/12'.obs;
  var sickLeaveCount = '0/14'.obs;
  var compensationalLeaveCount = '0/03'.obs;
  var unpaidLeaveCount = '0/05'.obs;
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

  // Method to count the annual leave days taken
  Future<void> getAnnualLeaveCount() async {
    // Filter the leaveRequests to find annual leave with "approved" status
    final approvedAnnualLeaveRequests = leaveRequests.where((leave) {
      return leave.leaveType == 'Annual Leave' && leave.leaveStatus == 'Approved';
    }).toList();

    // Calculate the total leave days taken for annual leave
    int totalAnnualLeaveDays = approvedAnnualLeaveRequests.fold(0, (sum, leave) {
      return sum + leave.totalDays;
    });

    // Calculate total annual leave available (e.g., 12 days per year)
    int totalAnnualLeaveAvailable = 12; // You can fetch this dynamically if needed

    // Set the count in the observable variable
    annualLeaveCount.value = '$totalAnnualLeaveDays/$totalAnnualLeaveAvailable';
  }

  Future<void> getSickLeaveCount() async {
    // Filter the leaveRequests to find annual leave with "approved" status
    final approvedSickLeaveRequests = leaveRequests.where((leave) {
      return leave.leaveType == 'Sick Leave' && leave.leaveStatus == 'Approved';
    }).toList();

    // Calculate the total leave days taken for annual leave
    int totalSickLeaveDays = approvedSickLeaveRequests.fold(0, (sum, leave) {
      return sum + leave.totalDays;
    });

    // Calculate total annual leave available (e.g., 12 days per year)
    int totalSickLeaveAvailable = 14; // You can fetch this dynamically if needed

    // Set the count in the observable variable
    sickLeaveCount.value = '$totalSickLeaveDays/$totalSickLeaveAvailable';
  }

  Future<void> getCompensationalLeaveCount() async {
    // Filter the leaveRequests to find annual leave with "approved" status
    final approvedCompensationalLeaveRequests = leaveRequests.where((leave) {
      return leave.leaveType == 'Compensational Leave' && leave.leaveStatus == 'Approved';
    }).toList();

    // Calculate the total leave days taken for annual leave
    int totalCompensationalLeaveDays = approvedCompensationalLeaveRequests.fold(0, (sum, leave) {
      return sum + leave.totalDays;
    });

    // Calculate total annual leave available (e.g., 12 days per year)
    int totalCompensationalLeaveAvailable = 03; // You can fetch this dynamically if needed

    // Set the count in the observable variable
    compensationalLeaveCount.value = '$totalCompensationalLeaveDays/$totalCompensationalLeaveAvailable';
  }

  Future<void> getUnpaidLeaveCount() async {
    // Filter the leaveRequests to find annual leave with "approved" status
    final approvedUnpaidLeaveRequests = leaveRequests.where((leave) {
      return leave.leaveType == 'Unpaid Leave' && leave.leaveStatus == 'Approved';
    }).toList();

    // Calculate the total leave days taken for annual leave
    int totalUnpaidLeaveDays = approvedUnpaidLeaveRequests.fold(0, (sum, leave) {
      return sum + leave.totalDays;
    });

    // Calculate total annual leave available (e.g., 12 days per year)
    int totalUnpaidLeaveAvailable = 05; // You can fetch this dynamically if needed

    // Set the count in the observable variable
    unpaidLeaveCount.value = '$totalUnpaidLeaveDays/$totalUnpaidLeaveAvailable';
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

      leaveRequests.value = leaveData;
      getAnnualLeaveCount();
      getSickLeaveCount();
      getCompensationalLeaveCount();
      getUnpaidLeaveCount();

      // Assign fetched data to observable list
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