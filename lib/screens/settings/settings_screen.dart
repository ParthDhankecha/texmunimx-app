import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/screens/calculator/calculator_screen.dart';
import 'package:textile_po/screens/create_design/design_list_screen.dart';
import 'package:textile_po/screens/party/party_list_screen.dart';
import 'package:textile_po/screens/settings/widgets/language_bottom_sheet.dart';
import 'package:textile_po/screens/settings/widgets/logout_dialog.dart';
import 'package:textile_po/screens/settings/widgets/settings_card.dart';
import 'package:textile_po/screens/users/users_list_screen.dart';
import 'package:textile_po/utils/shared_pref.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Sharedprefs sp = Get.find<Sharedprefs>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(centerTitle: true, title: Text('Settings')),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // First Group
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                SettingsCard(
                  icon: Icons.design_services,
                  iconColor: Colors.blue,
                  title: 'browse_design'.tr,
                  onTap: () {
                    Get.to(() => const DesignListScreen());
                  },
                ),
                _buildDivider(),
                SettingsCard(
                  icon: Icons.people,
                  iconColor: Colors.blueGrey,
                  title: 'browse_party'.tr,
                  onTap: () {
                    Get.to(() => const PartyListScreen());
                  },
                ),

                _buildDivider(),
                SettingsCard(
                  icon: Icons.calculate,
                  iconColor: Colors.orange,
                  title: 'calculator'.tr,
                  onTap: () {
                    Get.to(() => const CalculatorScreen());
                  },
                ),

                _buildDivider(),
                if (sp.userRole == sp.owner)
                  Column(
                    children: [
                      SettingsCard(
                        icon: Icons.account_circle,
                        iconColor: Colors.purple,
                        title: 'users'.tr,
                        onTap: () {
                          Get.to(() => const UsersListScreen());
                        },
                      ),
                      _buildDivider(),
                    ],
                  ),

                SettingsCard(
                  icon: Icons.language,
                  iconColor: Colors.green,
                  title: 'language_change'.tr,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => LanguageBottomSheet(),
                    );
                  },
                ),
                _buildDivider(),
                SettingsCard(
                  icon: Icons.logout,
                  iconColor: Colors.redAccent,
                  title: 'logout'.tr,
                  onTap: () {
                    Get.dialog(LogoutDialog());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 52.0),
            child: Divider(color: Colors.grey[300], height: 1),
          ),
        ),
      ],
    );
  }
}
