import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrm_attendance_proj/router/app_router.dart';

import '../utils/app_colors.dart';

class AnnualLeave extends StatefulWidget {
  const AnnualLeave({super.key});

  @override
  State<AnnualLeave> createState() => _AnnualLeaveState();
}

class _AnnualLeaveState extends State<AnnualLeave> {

  final List<Map<String, dynamic>> leaveData = [

    {
      'date': '14 Jan',
      'type': 'Annual Leave',
      'description': 'This Leave Is Taken Due To Symptoms Of Cold',
      'days': '2 Days',
      'status': 'Pending',
    },
    {
      'date': '14 Jan',
      'type': 'Annual Leave',
      'description': 'This Leave Is Taken Due To Symptoms Of fever',
      'days': '2 Days',
      'status': 'Approved',
    },
    {
      'date': '14 Jan',
      'type': 'Annual Leave',
      'description': 'This Leave Is Taken Due To Symptoms Of fever',
      'days': '2 Days',
      'status': 'Pending',
    },
    {
      'date': '14 Jan',
      'type': 'Annual Leave',
      'description': 'This Leave Is Taken Due To Symptoms Of fever',
      'days': '2 Days',
      'status': 'Rejected',
    },
    {
      'date': '14 Jan',
      'type': 'Annual Leave',
      'description': 'This Leave Is Taken Due To Symptoms Of fever',
      'days': '2 Days',
      'status': 'Rejected',
    },
    {
      'date': '14 Jan',
      'type': 'Annual Leave',
      'description': 'This Leave Is Taken Due To Symptoms Of fever',
      'days': '2 Days',
      'status': 'Rejected',
    },
    {
      'date': '14 Jan',
      'type': 'Annual Leave',
      'description': 'This Leave Is Taken Due To Symptoms Of fever',
      'days': '2 Days',
      'status': 'Approved',
    },
    {
      'date': '14 Jan',
      'type': 'Annual Leave',
      'description': 'This Leave Is Taken Due To Symptoms Of fever',
      'days': '2 Days',
      'status': 'Pending',
    },


  ];

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leading:  InkWell(
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
            'Annual Leave',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              height: 1.0, // 100% line height
              letterSpacing: 0.32, // 2% of 16px
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
                  child: ListView.builder(
                    itemCount: leaveData.length,
                    itemBuilder: (context, index) {
                      final item = leaveData[index];
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
                                height : 80,
                                width: 62,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.annualLeaveColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    item['date'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['type'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${item['description']} More..",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Jan 14 - 15, 2024",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    item['days'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    item['status'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.annualLeaveColor,
                                      fontWeight: FontWeight.bold,
                                    )
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
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
                      backgroundColor: AppColors.annualLeaveColor,
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
