import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/controllers/user_controller.dart';
import 'package:texmunimx/screens/users/create_users_screen.dart';
import 'package:texmunimx/screens/users/widgets/user_list_card.dart';
import 'package:texmunimx/utils/app_colors.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    userController.fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('users'.tr)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.mainColor,
        onPressed: () {
          // Navigate to add user screen
          Get.to(() => CreateUsersScreen());
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Obx(() {
            if (userController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (userController.users.isEmpty) {
              return Center(child: Text('no_users_found'.tr));
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: userController.users.length,
                  itemBuilder: (context, index) {
                    final user = userController.users[index];
                    final role = userController.getUserRolesById(user.userType);
                    return UserListCard(
                      user: user,
                      role: role,
                      index: index,
                      onEdit: () {
                        Get.to(() => CreateUsersScreen(user: user));
                      },
                      onStatusChange: (status) {
                        userController.updateUserActiveStatus(
                          userId: user.id.toString(),
                          isActive: status,
                          intdex: index,
                        );
                      },
                    );
                  },
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
