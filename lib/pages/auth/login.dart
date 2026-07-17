import 'package:bloodconnect/Controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginKey = GlobalKey<FormState>();
  final userName = TextEditingController();
  final passWord = TextEditingController();
  final login = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: GetX<LoginController>(builder: (controller) {
        return Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                color: Colors.red,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.bloodtype, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      "Blood Connect",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Login", style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Form(
                      key: loginKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: userName,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Username is required";
                              }
                              return null;
                            },

                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: passWord,
                            obscureText: controller.obsecuredText.value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is required";
                              }
                              return null;
                            },

                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (loginKey.currentState!.validate()) {
                          login.login(
                            email: userName.text.trim(),
                            password: passWord.text,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 55),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Center(
                        child: Text("Login", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            login.goToRegistration();
                            // TODO: navigate to registration page
                          },
                          child: const Text(
                            "Register now",
                            style: TextStyle(fontSize: 14, color: Colors.red),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            login.goToPasswordChange();
                            // TODO: navigate to forgot-password page
                          },
                          child: const Text(
                            "Forgot Password",
                            style: TextStyle(fontSize: 14, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "version 0.001",
                          style: TextStyle(fontSize: 6, color: Colors.red),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  @override
  void dispose() {
    userName.dispose();
    passWord.dispose();
    super.dispose();
  }
}