import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hrm_attendance_proj/controller/user_controller.dart';
import 'package:hrm_attendance_proj/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/login_controller.dart';
import '../router/app_router.dart';
import '../utils/functions.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final LoginController loginController = Get.put(LoginController());
  final UserController userController = Get.put(UserController());

  bool isUserDetailsVisible = false;
  UserModel? selectedUser;

  @override
  void initState() {
    super.initState();
    loadUserData();
    userController.fetchUsers();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? 'Not Available';
    print("AdminId : $id");
    loginController.listenAdminDataUpdates(context, id);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.yellowAccent,
          title: Obx(() {
            String initials = loginController.userName.value.isNotEmpty
                ? loginController.userName.value.substring(0, 2).toUpperCase()
                : "--";

            return LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue,
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextFun(
                          context,
                          title: "Hi, ${loginController.userName.value}!",
                          fontsize: 18,
                          fontweight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        buildTextFun(
                          context,
                          title: loginController.userDesignation.value,
                          fontsize: 14,
                          fontweight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    if (screenWidth > 600) // Only show on wider screens
                      buildTextFun(
                        context,
                        title: "HRM Admin",
                        fontsize: 30,
                        fontweight: FontWeight.bold,
                        color: Colors.red,
                      )
                  ],
                );
              },
            );
          }),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Get.offNamed(AppRouter.LOGIN_SCREEN);
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Obx(() {
              return userController.userList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: List.generate(userController.userList.length, (index) {
                      final userData = userController.userList[index];
                      return Card(
                        child: ListTile(
                          title: buildTextFun(
                            context,
                            title: "Customer Name: ${userData.userName}",
                            fontsize: 14,
                            fontweight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          subtitle: buildTextFun(
                            context,
                            title: "Customer Position: ${userData.position}",
                            fontsize: 14,
                            fontweight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isUserDetailsVisible = true;
                                    selectedUser = userData;
                                  });
                                },
                                icon: const Icon(Icons.edit, color: Colors.red),
                              ),
                              IconButton(
                                onPressed: () {
                                  userController.deleteCustomerData(context, userData.uId);
                                },
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              );
            }),
            if (isUserDetailsVisible)
              SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 600, // restrict max width for web
                      minHeight: MediaQuery.of(context).size.height * 0.9,
                    ),
                    child: buildUserUIFun(context, selectedUser),
                  ),
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              isUserDetailsVisible = true;
              selectedUser = null;
            });
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }

  buildUserUIFun(BuildContext context, UserModel? userData) {
    if (userData != null) {
      userController.userNameController.text = userData.userName;
      userController.phoneNoController.text = userData.phoneNo;
      userController.emailIdController.text = userData.emailId;
      userController.passwordController.text = userData.password;
      userController.positionController.text = userData.position ;
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withValues(alpha: 0.5), blurRadius: 10, spreadRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            buildTextFun(context, title: "User Details", fontsize: 22, fontweight: FontWeight.bold, color: Colors.black),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () {
                setState(() {
                  isUserDetailsVisible = false;
                  selectedUser = null;
                });
              },
            )
          ]),
          const SizedBox(height: 10),
          buildTextFormFieldFun(context, isPassword: false, hint: "Name", controller: userController.userNameController, border: true),
          const SizedBox(height: 10),
          buildTextFormFieldFun(
            context,
            isPassword: false,
            hint: "Mobile No",
            controller: userController.phoneNoController,
            border: true,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
          ),
          const SizedBox(height: 10),
          buildTextFormFieldFun(context, isPassword: true, hint: "Password", controller: userController.passwordController, border: true),
          const SizedBox(height: 10),
          buildTextFormFieldFun(
            context,
            isPassword: false,
            hint: "Mail ID",
            controller: userController.emailIdController,
            border: true,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10),
          buildTextFormFieldFun(context, isPassword: false, hint: "Position", controller: userController.positionController, border: true, maxLines: 2),
          const SizedBox(height: 20),
          Center(
            child: buildContainerButtonFun(
              context,

              userData != null ? "Update" : "Submit",
              color: Colors.blue,
              onPressed: () async {
                onSaveComplete() {
                  setState(() {
                    isUserDetailsVisible = false;
                  });
                }

                await userController.addUpdateUserDetails(context, onSaveComplete, userData);
              },
            ),
          )
        ],
      ),
    );
  }
}
