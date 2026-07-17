import 'package:bloodconnect/core/Routs/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  /// Whether the password field is currently obscured.
  /// Starts as true so the password is hidden by default.
  final RxBool obsecuredText = true.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoading = false.obs;
  final box=GetStorage();

  void changeObsecured() {
    obsecuredText.value = !obsecuredText.value;
  }

  /// Placeholder for actual authentication logic.
  Future<void> login({required String email, required String password}) async {
    print("Login Pressed");

    try{
      final UserCredential user = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      box.write("isLoggedIn", true);
      box.write("email", email);
      box.write("userId", user.user!.uid);

Get.toNamed(AppRoutes.home);
    }on FirebaseAuthException catch (e){
      String message = "";

      switch (e.code) {
        case "user-not-found":
          message = "No account found with this email.";
          break;

        case "wrong-password":
          message = "Incorrect password.";
          break;

        case "invalid-email":
          message = "Invalid email address.";
          break;

        case "invalid-credential":
          message = "Invalid email or password.";
          break;

        case "too-many-requests":
          message = "Too many attempts. Please try again later.";
          break;

        default:
          message = e.message ?? "Login failed.";
      }

      Get.snackbar("Error", message);
    }catch(e){
      Get.snackbar("Error", e.toString());
    }finally{
      isLoading.value = false;
    }






  }

  void goToRegistration(){
    Get.toNamed(AppRoutes.Register);
  }

  void goToPasswordChange(){
    Get.toNamed(AppRoutes.forgotPassword);
  }

}