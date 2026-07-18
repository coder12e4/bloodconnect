import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class forgetPasswordController extends GetxController{

  RxBool isLoading = false.obs;
  Future<void> forgotPassword(String email) async {
    try {
      isLoading.value =  true;
      if (email.trim().isEmpty) {
        Get.snackbar(
          "Error",
          "Please enter your email address.",
        );
        isLoading.value =  false;


      }

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email.trim(),
      );

      Get.snackbar(
        "Success",
        "Password reset link has been sent to your email.",
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value =  false;
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case "user-not-found":
          message = "No account found with this email.";
          break;

        case "invalid-email":
          message = "Please enter a valid email.";
          break;

        default:
          message = e.message ?? "Something went wrong.";
      }

      Get.snackbar(
        "Error",
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value =  false;

    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }



}