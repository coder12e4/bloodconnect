import 'dart:io';

import 'package:bloodconnect/Controllers/location_Controller/location_Controller.dart';
import 'package:bloodconnect/core/Routs/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
final location=Get.put( LocationController());
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
  late double lat;
  late double long;

  // Observable Variables
  RxString gender = "Male".obs;
  RxString bloodGroup = "O+".obs;
  RxString district="Malappuram".obs;

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

  final keralaDistricts = [

    "Thiruvananthapuram",
    "Kollam",
    "Pathanamthitta",
    "Alappuzha",
    "Kottayam",
    "Idukki",
    "Ernakulam",
    "Thrissur",
    "Palakkad",
    "Malappuram",
    "Kozhikode",
    "Wayanad",
    "Kannur",
    "Kasaragod",
  ];

  final picker = ImagePicker();

  Rx<File?> selectedImage = Rx<File?>(null);

  RxBool isUploading = false.obs;


  final LocationController locationController=Get.put(LocationController());
  @override
  void onInit() {
    location.getPosition();
    lat=location.lat.value;
    long=location.long.value;

  }

  Future<String?> uploadImage() async {
    if (selectedImage.value == null) return null;

    try {
      isUploading.value = true;

      String fileName =
          "profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg";

      Reference reference =
      FirebaseStorage.instance.ref().child(fileName);

      UploadTask uploadTask =
      reference.putFile(selectedImage.value!);

      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl =
      await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return null;
    } finally {
      isUploading.value = false;
    }
  }


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



    try {
      UserCredential credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: "1234567890",
      );

      await credential.user!.sendEmailVerification();
      String? imageUrl = await uploadImage();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(credential.user!.uid)
          .set({
        "uid": credential.user!.uid,
        "name": nameController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "bloodGroup": bloodGroup.value,
        "gender": gender.value,
        "age": ageController.text,
        "weight": weightController.text,
        "district": "",
        "place": "",
        "latitude": lat,
        "longitude": long,
        "profileImage": imageUrl,
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
      Get.offAllNamed(AppRoutes.Register);
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

void moveTologin(){
    Get.toNamed(AppRoutes.Login);
}
}