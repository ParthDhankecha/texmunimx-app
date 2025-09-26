import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('users'.tr)),
      body: Center(child: Text('Users List Screen')),
    );
  }
}
