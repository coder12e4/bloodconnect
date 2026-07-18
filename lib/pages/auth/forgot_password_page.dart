import 'package:bloodconnect/Controllers/forgetPasswordController.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../Controllers/RegisterController.dart';
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _forgotPasswordPageState();
}

class _forgotPasswordPageState extends State<ForgotPasswordPage> {
  var forgotPassword=GlobalKey<FormState>();
  var emailController=TextEditingController();
  late final forgetPasswordController controller ;

  @override
  void initState() {
    controller = Get.find<forgetPasswordController>();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),),
        title: const Text("Forgot Password"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
        
            Text("Enter your e mail id,we will sent you a reset link"),
            SizedBox(height: 14,),
        
            Form(
                key: forgotPassword,
                child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                decoration: InputDecoration(
                hintText: "Enter your e mail id"
        
        
                ),
                )
              ],
            )),
            const SizedBox(height: 30),
        
            /// Register Button
            Obx(() => SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
        
                style: ElevatedButton.styleFrom(
        
                  backgroundColor: Colors.red,
                ),
                onPressed: (){
                  controller.forgotPassword(emailController.text);
                },
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  "Sent Password Reset Link",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
