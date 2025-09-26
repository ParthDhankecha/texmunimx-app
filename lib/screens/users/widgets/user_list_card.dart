import 'package:flutter/material.dart';
import 'package:textile_po/common_widgets/app_text_styles.dart';
import 'package:textile_po/common_widgets/custom_btn.dart';
import 'package:textile_po/common_widgets/custom_btn_red.dart';
import 'package:textile_po/models/user_list_response.dart';
import 'package:textile_po/models/user_role_enum.dart';
import 'package:textile_po/utils/app_colors.dart';

class UserListCard extends StatelessWidget {
  final UserModel user;
  const UserListCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 26,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(width: 10),
                          Text(user.fullname, style: titleStyle),
                        ],
                      ),
                      SizedBox(height: 8),
                      _buildRow(icon: Icons.email, value: user.email),
                      SizedBox(height: 6),
                      _buildRow(icon: Icons.phone, value: user.mobile),
                      SizedBox(height: 6),
                      _buildRow(
                        icon: Icons.badge,
                        value: UserRole.fromValue(user.userType).apiName,
                      ),
                      SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Edit',
                              style: bodyStyle.copyWith(
                                color: AppColors.mainColor,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Delete',
                              style: bodyStyle.copyWith(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Positioned(
                    right: 0,
                    top: 0,
                    child: Switch.adaptive(
                      activeThumbColor: Colors.green,
                      trackOutlineWidth: WidgetStatePropertyAll(1),

                      value: user.isActive,
                      onChanged: (value) {
                        // Handle switch change
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _buildRow({required IconData icon, required String value}) {
    return Row(
      children: [
        Icon(icon, size: 22, color: AppColors.mainColor),
        SizedBox(width: 10),
        Text(value, style: bodyStyle1),
      ],
    );
  }
}
