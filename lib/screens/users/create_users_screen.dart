import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateUsersScreen extends StatefulWidget {
  const CreateUsersScreen({super.key});

  @override
  State<CreateUsersScreen> createState() => _CreateUsersScreenState();
}

class _CreateUsersScreenState extends State<CreateUsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('add_user'.tr)),
      body: Center(child: Text('User Creation Screen')),
    );
  }
}
