import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileEditController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final districtController = TextEditingController();
  final placeController = TextEditingController();

  RxString gender = "Male".obs;
  RxString bloodGroup = "O+".obs;
  RxBool isAvailable = true.obs;
  RxBool isLoading = false.obs;

  final genders = const ["Male", "Female", "Other"];
  final bloodGroups = const [
    "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-",
  ];

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (_uid == null) return;
    isLoading.value = true;
    try {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(_uid)
          .get();
      final data = doc.data();
      if (data == null) return;

      nameController.text = (data['name'] ?? '').toString();
      phoneController.text = (data['phone'] ?? '').toString();
      ageController.text = (data['age'] ?? '').toString();
      weightController.text = (data['weight'] ?? '').toString();
      districtController.text = (data['district'] ?? '').toString();
      placeController.text = (data['place'] ?? '').toString();
      gender.value = (data['gender'] ?? 'Male').toString();
      bloodGroup.value = (data['bloodGroup'] ?? 'O+').toString();
      isAvailable.value = data['isAvailable'] == true;
    } catch (e) {
      Get.snackbar("Error", "Failed to load profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate() || _uid == null) return;

    isLoading.value = true;
    try {
      await FirebaseFirestore.instance.collection("users").doc(_uid).update({
        "name": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "age": ageController.text.trim(),
        "weight": weightController.text.trim(),
        "district": districtController.text.trim(),
        "place": placeController.text.trim(),
        "gender": gender.value,
        "bloodGroup": bloodGroup.value,
        "isAvailable": isAvailable.value,
        "updatedAt": FieldValue.serverTimestamp(),
      });
      Get.back();
      Get.snackbar("Success", "Profile updated");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    ageController.dispose();
    weightController.dispose();
    districtController.dispose();
    placeController.dispose();
    super.onClose();
  }
}

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileEditController());

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: controller.formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextFormField(
                      controller: controller.nameController,
                      decoration: const InputDecoration(labelText: "Name"),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: controller.phoneController,
                      decoration: const InputDecoration(labelText: "Phone"),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: controller.ageController,
                      decoration: const InputDecoration(labelText: "Age"),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: controller.weightController,
                      decoration: const InputDecoration(labelText: "Weight (kg)"),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: controller.districtController,
                      decoration: const InputDecoration(labelText: "District"),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: controller.placeController,
                      decoration: const InputDecoration(labelText: "Place"),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => DropdownButtonFormField<String>(
                        value: controller.gender.value,
                        decoration: const InputDecoration(labelText: "Gender"),
                        items: controller.genders
                            .map((g) =>
                                DropdownMenuItem(value: g, child: Text(g)))
                            .toList(),
                        onChanged: (v) => controller.gender.value = v!,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => DropdownButtonFormField<String>(
                        value: controller.bloodGroup.value,
                        decoration:
                            const InputDecoration(labelText: "Blood Group"),
                        items: controller.bloodGroups
                            .map((g) =>
                                DropdownMenuItem(value: g, child: Text(g)))
                            .toList(),
                        onChanged: (v) => controller.bloodGroup.value = v!,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => SwitchListTile(
                        title: const Text("Available to Donate"),
                        value: controller.isAvailable.value,
                        onChanged: (v) => controller.isAvailable.value = v,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: controller.saveProfile,
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
