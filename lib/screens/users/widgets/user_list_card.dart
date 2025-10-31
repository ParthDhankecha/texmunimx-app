import 'package:flutter/material.dart';
import 'package:texmunimx/common_widgets/animated_active_switch.dart';
import 'package:texmunimx/common_widgets/app_text_styles.dart';
import 'package:texmunimx/models/user_list_response.dart';
import 'package:texmunimx/utils/app_colors.dart';

class UserListCard extends StatelessWidget {
  final UserModel user;
  final String role;
  final int index;
  final Function()? onEdit;
  final Function(bool status)? onStatusChange;
  const UserListCard({
    super.key,
    required this.user,
    required this.role,
    required this.index,
    this.onEdit,
    this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline_outlined,
                              size: 26,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(width: 10),
                            Text(user.fullname, style: titleStyle),
                          ],
                        ),
                        SizedBox(height: 8),
                        _buildRow(
                          icon: Icons.email_outlined,
                          value: user.email,
                        ),
                        SizedBox(height: 6),
                        _buildRow(
                          icon: Icons.phone_outlined,
                          value: user.mobile,
                        ),
                        SizedBox(height: 6),
                        _buildRow(icon: Icons.work_outline, value: role),
                      ],
                    ),

                    // Positioned(
                    //   right: 0,
                    //   top: 0,
                    //   child: Switch.adaptive(
                    //     value: user.isActive,
                    //     onChanged: onStatusChange,
                    //   ),
                    // ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: SizedBox(
                        width: 120,
                        child: AnimatedActiveSwitch(
                          current: user.isActive,
                          onChanged: onStatusChange!,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
