import 'package:flutter/material.dart';
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _forgotPasswordPageState();
}

class _forgotPasswordPageState extends State<ForgotPasswordPage> {
  var forgotPassword=GlobalKey<FormState>();
  var emailController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Column(
        children: [
          Form(
              key: forgotPassword,
              child: Column(
            children: [
              TextFormField(
                controller: emailController,
              decoration: InputDecoration(
              border: OutlineInputBorder(

              )


              ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
