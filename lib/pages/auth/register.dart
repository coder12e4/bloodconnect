import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/RegisterController.dart';


class DonorRegistrationPage extends StatefulWidget {
  DonorRegistrationPage({super.key});

  @override
  State<DonorRegistrationPage> createState() => _DonorRegistrationPageState();
}

class _DonorRegistrationPageState extends State<DonorRegistrationPage> {
  late final RegisterController controller ;
  @override
  void initState() {
   controller = Get.find<RegisterController>();
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
        title: const Text("Blood Donor Registration"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              /// Name
              ///
              ///
              ///
              ///

              Obx(() {
                return GestureDetector(
                  onTap: controller.uploadImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: controller.selectedImage.value != null
                        ? FileImage(controller.selectedImage.value!)
                        : null,
                    child: controller.selectedImage.value == null
                        ? const Icon(Icons.camera_alt, size: 40)
                        : null,
                  ),
                );
              }),
              const SizedBox(height: 15),
              TextFormField(
                controller: controller.nameController,
                decoration: InputDecoration(hintText: "Enter Your Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter your name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              /// Email
              TextFormField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: "Enter Your Email"),

              ),

              const SizedBox(height: 15),

              /// Phone
              TextFormField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(hintText: "Enter Your Phone Number"),

              ),

              const SizedBox(height: 15),

              /// Gender
              Obx(() => DropdownButtonFormField<String>(
                hint: Text("Gender"),
                value: controller.gender.value,

                items: controller.genders
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
                    .toList(),
                onChanged: (value) {
                  controller.gender.value = value!;
                },
              )),

              const SizedBox(height: 15),

              /// Blood Group
              Obx(() => DropdownButtonFormField<String>(
                hint: Text("Blood Group"),
                value: controller.bloodGroup.value,

                items: controller.bloodGroups
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
                    .toList(),
                onChanged: (value) {
                  controller.bloodGroup.value = value!;
                },
              )),

              const SizedBox(height: 15),

              /// Age
              TextFormField(
                controller: controller.ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "Enter Your Age"),

              ),

              const SizedBox(height: 15),

              /// Weight
              TextFormField(
                controller: controller.weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "Enter Your Weight"),

              ),

              const SizedBox(height: 15),

              /// District


              Obx(() => DropdownButtonFormField<String>(
                hint: Text("Blood Group"),
                value: controller.district.value,

                items: controller.keralaDistricts
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
                    .toList(),
                onChanged: (value) {
                  controller.district.value = value!;
                },
              )),


              const SizedBox(height: 15),

              /// Place
              TextFormField(
                controller: controller.placeController,
                decoration: InputDecoration(hintText: "Enter Your Place"),

              ),


              const SizedBox(height: 20),

              /// Become Donor
              Obx(() => Card(
                child: SwitchListTile(
                  title: const Text("Become Blood Donor"),
                  subtitle:
                  const Text("Allow others to request blood"),
                  value: controller.isDonor.value,
                  activeColor: Colors.red,
                  onChanged: (value) {
                    controller.isDonor.value = value;
                  },
                ),
              )),

              const SizedBox(height: 10),

              /// Available
              Obx(() => Card(
                child: SwitchListTile(
                  title: const Text("Available Now"),
                  subtitle:
                  const Text("Available for emergency donation"),
                  value: controller.isAvailable.value,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    controller.isAvailable.value = value;
                  },
                ),
              )),

              const SizedBox(height: 20),

              /// Last Donation Date
              Obx(() => ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.grey),
                ),
                title: Text(
                  controller.lastDonationDate.value == null
                      ? "Select Last Donation Date"
                      : controller.lastDonationDate.value!
                      .toString()
                      .split(" ")
                      .first,
                ),
                trailing: const Icon(Icons.calendar_month),
                onTap: () {
                  controller.pickDate(context);
                },
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
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.registerDonor,
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              )),
              const SizedBox(height: 20),
              GestureDetector(onTap: (){
                controller.moveTologin();
              },child: Text("Already Registered? Go to login"))

            ],
          ),
        ),
      ),
    );
  }
}