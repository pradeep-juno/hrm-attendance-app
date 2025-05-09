import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrm_attendance_proj/controller/leave_Controler.dart';
import 'package:hrm_attendance_proj/utils/app_colors.dart';
import 'package:intl/intl.dart';

import '../router/app_router.dart';


class ApprovalQueueScreen extends StatefulWidget {
  const ApprovalQueueScreen({super.key});

  @override
  State<ApprovalQueueScreen> createState() => _LeaveRequestScreenState();
}



class _LeaveRequestScreenState extends State<ApprovalQueueScreen> {

  @override
  void initState() {
    super.initState();
    leaveController.fetchLeaveRequests();

  }
  LeaveController leaveController = Get.put(LeaveController());

  Color _getStatusColor(String status) {
    if (status == 'Approved') {
      return Colors.green; // Green for Approved
    } else if (status == 'Rejected') {
      return Colors.red; // Red for Rejected
    } else {
      return Colors.orange; // Black for Pending (or initial state)
    }
  }




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Image.asset(
              "assets/icons/back.png",
              height: 32,
              width: 32,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Approval Queue',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              height: 1.0,
              letterSpacing: 0.32,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack.withValues(alpha: 0.9),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: AppColors.backGroundColor.withAlpha(50),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const Text(
                  "Lorem Ipsum Dolor Sit Amet Consectetur. Enim Risus Egestas Scelerisque Elit Placerat Lectus Sed Id Sed",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Obx(() {
                    if (leaveController.leaveRequests.isEmpty) {
                      return Center(
                        child: Image.asset("assets/images/no_data.jpg"),
                      );
                    }

                    return ListView.builder(
                      itemCount: leaveController.leaveRequests.length,
                      itemBuilder: (context, index) {
                        final item = leaveController.leaveRequests[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          color: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 80,
                                  width: 62,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${item.leaveCreatedDate.day}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('MMMM').format(item.startDate), // This gives full month name
                                          // Use 'MMM' for short name like 'May'
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.leaveType,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.reason,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black87,
                                        ),
                                      ),

                                      const SizedBox(height: 4),
                                      Text(
                                        "${DateFormat('d MMMM, y').format(item.startDate)} - ${DateFormat('d MMMM, y').format(item.endDate)}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      )

                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        if (item.totalDays > 0)
                                          Text(
                                            '${item.totalDays} ${item.totalDays == 1 ? 'Day' : 'Days'}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        if (item.totalDays > 0 && item.offDayLeaveDuration > 0)
                                          const Text(
                                            '\t', // Add 'and' if both leave and permission exist
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        if (item.offDayLeaveDuration > 0)
                                          Text(
                                            '${item.offDayLeaveDuration} hrs Permission',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      item.leaveStatus.isEmpty ? 'Pending' : item.leaveStatus, // Default to 'Pending' if leaveStatus is empty
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _getStatusColor(item.leaveStatus), // Use the helper function to get color dynamically
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )

                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(AppRouter.LEAVE_SCREEN);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC107),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Apply Leave",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
