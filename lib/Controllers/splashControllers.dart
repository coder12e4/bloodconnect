

import 'dart:async';

import 'package:get/state_manager.dart';

import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../core/Routs/routes.dart';

class SplashController extends GetxController {
  late Timer timer;
  final box = GetStorage();
  @override
  void onInit() {
    super.onInit();
    splash();
  }

  void splash() {
    timer = Timer(const Duration(seconds: 2), () {
      print("Navigate to Home");

      bool loggedIn = box.read("isLoggedIn") ?? false;
      if (loggedIn) {
        Get.offAllNamed("/home");
      } else {
        Get.offAllNamed("/login");
      }

    });
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }
}