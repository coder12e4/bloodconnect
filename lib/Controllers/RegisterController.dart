import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final districtController = TextEditingController();
  final placeController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final profileImageController = TextEditingController();

  // Observable Variables
  RxString gender = "Male".obs;
  RxString bloodGroup = "O+".obs;

  RxBool isDonor = true.obs;
  RxBool isAvailable = true.obs;

  Rx<DateTime?> lastDonationDate = Rx<DateTime?>(null);

  RxBool isLoading = false.obs;

  // Dropdown Lists
  final genders = [
    "Male",
    "Female",
    "Other",
  ];

  final bloodGroups = [
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-",
  ];

  /// Pick Date
  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      lastDonationDate.value = picked;
    }
  }

  /// Register User
  Future<void> registerDonor() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      UserCredential credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: "1234567890",
      );

      await credential.user!.sendEmailVerification();

      await FirebaseFirestore.instance
          .collection("users")
          .doc(credential.user!.uid)
          .set({
        "uid": credential.user!.uid,
        "name": "test",
        "email": emailController.text,
        "phone": "1234567890",
        "bloodGroup": bloodGroup.value,
        "gender": gender.value,
        "age": "00",
        "weight": "00",
        "district": "",
        "place": "",
        "latitude": "",
        "longitude": "",
        "profileImage": "",
        "isAvailable": true,
        "lastDonationDate": null,
        "emergencyContact": "",
        "role": "donor",
        "isVerified": false,
        "currentlat":"",
        "currentlong":"",
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });



      // TODO:
      // await FirebaseFirestore.instance
      //     .collection("users")
      //     .doc(uid)
      //     .set(data);

      Get.snackbar(
        "Success",
        "Registration Completed",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );

      print(e.toString());
    }

    isLoading.value = false;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    ageController.dispose();
    weightController.dispose();
    districtController.dispose();
    placeController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    profileImageController.dispose();
    super.onClose();
  }


}