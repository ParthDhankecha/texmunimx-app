import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/screens/create_design/design_list_screen.dart';
import 'package:textile_po/screens/party/party_list_screen.dart';
import 'package:textile_po/screens/settings/widgets/language_bottom_sheet.dart';
import 'package:textile_po/screens/settings/widgets/settings_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
            child: SettingsCard(
              img: 'textile',
              title: 'browse_design'.tr,
              onTap: () {
                Get.to(() => DesignListScreen());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
            child: SettingsCard(
              img: 'supplier',
              title: 'browse_party'.tr,
              onTap: () {
                Get.to(() => PartyListScreen());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
            child: SettingsCard(
              img: 'languages',
              title: 'language_change'.tr,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => LanguageBottomSheet(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
