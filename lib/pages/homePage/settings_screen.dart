import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  RxBool notificationsEnabled = true.obs;
  RxBool locationSharingEnabled = true.obs;
  RxBool darkMode = false.obs;
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          Obx(
            () => SwitchListTile(
              title: const Text("Notifications"),
              subtitle: const Text("Get notified about donation requests"),
              value: controller.notificationsEnabled.value,
              onChanged: (v) => controller.notificationsEnabled.value = v,
            ),
          ),
          Obx(
            () => SwitchListTile(
              title: const Text("Share My Location"),
              subtitle: const Text("Show my location to nearby requesters"),
              value: controller.locationSharingEnabled.value,
              onChanged: (v) => controller.locationSharingEnabled.value = v,
            ),
          ),
          Obx(
            () => SwitchListTile(
              title: const Text("Dark Mode"),
              value: controller.darkMode.value,
              onChanged: (v) => controller.darkMode.value = v,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text("Privacy Policy"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
