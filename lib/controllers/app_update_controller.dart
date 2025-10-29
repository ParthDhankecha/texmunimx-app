import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:texmunimx/screens/app_updates/app_updates_dialog.dart';
import 'package:texmunimx/utils/shared_pref.dart';

class AppUpdateController extends GetxController implements GetxService {
  RxString currentAppVersion = ''.obs;
  RxString latestAppVersion = ''.obs;
  RxBool forceUpdate = false.obs;
  RxBool isUpdateAvailable = false.obs;
  RxBool showPopup = false.obs;

  Sharedprefs sp = Get.find<Sharedprefs>();

  setData(
    String latestVersion,
    bool forceUpdateFlag,
    bool showPopupFlag,
  ) async {
    latestAppVersion.value = latestVersion;
    forceUpdate.value = forceUpdateFlag;
    isUpdateAvailable.value = false;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version; //default version
    currentAppVersion.value = version;

    int currentVersionInt = int.tryParse(version.replaceAll('.', '')) ?? 0;
    int latestVersionInt =
        int.tryParse(latestAppVersion.value.replaceAll('.', '')) ?? 0;

    showPopup.value = showPopupFlag;

    log(
      'getSettings : version : $currentVersionInt , latestVersionInt: $latestVersionInt',
    );
    isUpdateAvailable.value = latestVersionInt > currentVersionInt
        ? true
        : false;

    await checkforVersionUpdate();
  }

  //save last update prompt time
  void saveLastUpdatePromptTime(DateTime timestamp) {
    sp.lastUpdatePromptTime = timestamp.millisecondsSinceEpoch;
  }

  Future<bool> shouldPromptForUpdate() async {
    int lastPromptTime = sp.lastUpdatePromptTime;

    DateTime lastPromptDateTime = DateTime.fromMillisecondsSinceEpoch(
      lastPromptTime,
    );
    Duration difference = DateTime.now().difference(lastPromptDateTime);
    log('Difference in hours: ${difference.inHours}');
    if (difference.inMinutes >= 24 || lastPromptTime == 0) {
      return true;
    }
    return false;
  }

  //check for version updates
  checkforVersionUpdate() {
    if (isUpdateAvailable.value) {
      if (forceUpdate.value) {
        // Show mandatory update dialog
        Get.dialog(
          barrierDismissible: false,
          PopScope(canPop: false, child: AppUpdatesDialog()),
        );
        return;
      }
      shouldPromptForUpdate().then((shouldPrompt) {
        if (shouldPrompt && showPopup.value) {
          saveLastUpdatePromptTime(DateTime.now());
          Get.dialog(
            barrierDismissible: true,
            PopScope(canPop: true, child: AppUpdatesDialog()),
          );
        }
      });
    }
  }
}
