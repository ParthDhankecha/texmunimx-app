import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/controllers/user_controller.dart';
import 'package:textile_po/screens/users/widgets/user_list_card.dart';

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
                    return UserListCard(user: user);
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
