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
              TextFormField(
                controller: controller.nameController,

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

              ),

              const SizedBox(height: 15),

              /// Phone
              TextFormField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,

              ),

              const SizedBox(height: 15),

              /// Gender
              Obx(() => DropdownButtonFormField<String>(
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

              ),

              const SizedBox(height: 15),

              /// Weight
              TextFormField(
                controller: controller.weightController,
                keyboardType: TextInputType.number,

              ),

              const SizedBox(height: 15),

              /// District
              TextFormField(
                controller: controller.districtController,
                decoration: const InputDecoration(
                  labelText: "District",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city),
                ),
              ),

              const SizedBox(height: 15),

              /// Place
              TextFormField(
                controller: controller.placeController,

              ),

              const SizedBox(height: 15),

              /// Latitude
              TextFormField(
                controller: controller.latitudeController,
                keyboardType: TextInputType.number,

              ),

              const SizedBox(height: 15),

              /// Longitude
              TextFormField(
                controller: controller.longitudeController,
                keyboardType: TextInputType.number,

              ),

              const SizedBox(height: 15),

              /// Profile Image
              TextFormField(
                controller: controller.profileImageController,
                
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
                width: 100,
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
            ],
          ),
        ),
      ),
    );
  }
}